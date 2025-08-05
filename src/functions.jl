function register!(
    scheduler,
    fun,
    t,
    args...;
    id = "",
    type = "",
    description = "",
    kwargs...
)
    event = Event(() -> fun(args...; kwargs...), t, id, type, description)
    return register!(scheduler, event, t)
end

"""
    register!(scheduler, event::AbstractEvent, t::Real)

An interface for adding events to the scheduler. 

# Arguments 

- `scheduler`: an event scheduler
- `event::AbstractEvent`: an event 
- `t::Real`: time value associated with `when` 
"""
function register!(scheduler, event::AbstractEvent, t::Real)
    push!(scheduler.events, event => t)
    return nothing
end

"""
    register!(
        scheduler,
        fun,
        when,
        args...;
        id = "",
        type = "",
        description = "",
        kwargs...
    )

An interface for adding events to the scheduler. 

# Arguments 

- `scheduler`: an event scheduler
- `fun`: a function to execute during the event 
- `when`::Now: schedules the event to execute at the current time 
- `args...`: optional positional arguments for `fun`

# Keywords

- `id`: optional id string 
- `type`: the type of event 
- `description`: optional description
- `kwargs...`: optional keyword arguments for `fun`
"""
function register!(
    scheduler,
    fun,
    when::Now,
    args...;
    id = "",
    type = "",
    description = "",
    kwargs...
)
    return register!(scheduler, fun, scheduler.time, args...; id, type, description, kwargs...)
end

"""
    register!(
        scheduler,
        fun,
        when,
        t,
        args...;
        id = "",
        type = "",
        description = "",
        kwargs...
    )

An interface for adding events to the scheduler. 

# Arguments 

- `scheduler`: an event scheduler
- `fun`: a function to execute during the event 
- `when`: when ∈ {every, after, at} determines the time at which the event occurs relative to `t`
- `t`: time value associated with `when` 
- `args...`: optional positional arguments for `fun`

# Keywords

- `id`: optional id string 
- `type`: the type of event 
- `description`: optional description
- `kwargs...`: optional keyword arguments for `fun`
"""
function register!(
    scheduler,
    fun,
    when::At,
    t,
    args...;
    id = "",
    type = "",
    description = "",
    kwargs...
)
    return register!(scheduler, fun, t, args...; id, type, description, kwargs...)
end

function register!(
    scheduler,
    fun,
    when::After,
    t,
    args...;
    id = "",
    type = "",
    description = "",
    kwargs...
)
    return register!(scheduler, fun, scheduler.time + t, args...; id, type, description, kwargs...)
end

function register!(
    scheduler,
    fun,
    when::Every,
    t,
    args...;
    id = "",
    type = "",
    description = "",
    kwargs...
)
    function f(args...; kwargs...)
        fun1 = () -> fun(args...; kwargs...)
        fun1()
        register!(scheduler, fun, every, t, args...; id, type, description, kwargs...)
    end
    return register!(scheduler, f, after, t, args...; id, type, description, kwargs...)
end

"""
    stop!(scheduler)

Stops simulation 

# Arguments

- `scheduler`: an event scheduler 
"""
function stop!(scheduler)
    scheduler.can_run = false
end

"""
    reset!(scheduler)

Resets time to 0 and empties event queue

# Arguments

- `scheduler`: an event scheduler 
"""
function reset!(scheduler)
    scheduler.can_run = true
    scheduler.time = 0.0
    empty!(scheduler.events)
end

"""
    run!(s::AbstractScheduler, until=Inf)

Run simulation until specified time

# Arguments

- `scheduler`: an event scheduler 
- `until=Inf`: time at which simulation ends
"""
function run!(s::AbstractScheduler, until = Inf)
    last_event!(s, until)
    while is_running(s, until)
        execute!(s)
    end
    s.trace && !s.running ? print_event(s.time, "", "stopped") : nothing
    return nothing
end

function execute!(s::AbstractScheduler)
    event, new_time = popfirst!(s.events)
    s.time = new_time
    event.fun()
    s.store ? push!(s.complete_events, event) : nothing
    s.trace ? print_event(event) : nothing
    return nothing
end

function is_running(s, until)
    return !isempty(s.events) && s.can_run && first(s.events).first.time ≤ until
end

function last_event!(scheduler, until)
    if until == Inf
    else
        register!(scheduler, ()->(), after, until; description = "done")
    end
    return nothing
end

print_event(event) = print_event(event.time, event.id, event.description)

function print_event(time, id, description)
    @printf("time:  %0.3f", time)
    println("   id   ", id, "    ", description)
end

"""
    remove_events!(scheduler, id, f = (x, id) -> x.first.id == id)

Remove events by id 

# Arguments

-`scheduler`: an event scheduler
- `id`: event id
- `f`: removal function. Defaults to exact match.
````
"""
function remove_events!(scheduler, id, f = (x, id) -> x.first.id == id)
    events = filter(x->f(x, id), scheduler.events)
    for event in events
        delete!(scheduler.events, event.first)
    end
    return nothing
end

"""
    replay_events(s::AbstractScheduler) 

Print completed events 

# Arguments

- `scheduler`: an event scheduler
"""
function replay_events(s::AbstractScheduler)
    for event in s.complete_events
        print_event(event)
    end
    return nothing
end
