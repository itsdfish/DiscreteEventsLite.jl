"""
    register!(scheduler, fun, when, t, args...; id="", description="", kwargs...)

An interface for adding events to the scheduler. 

# Arguments 

- `scheduler`: an event scheduler
- `fun`: a function to execute
- `when`: timing for the execution of `fun`. Options: `at`, `now`, `every`, `after`
- `t`: time value associated with `when` 
- `args...`: optional positional arguments for `fun`
- `id`: optional id string 
- `description`: optional description

# Keywords

- `kwargs...`: option keyword arguments for `fun`

"""
function register!(scheduler, fun, t, args...; id="", type="", description="", kwargs...)
    event = Event(() -> fun(args...; kwargs...), t, id, type, description)
    enqueue!(scheduler.events, event, t)
end

function register!(scheduler, fun, when::Now, args...; id="", type="", description="", kwargs...)
    register!(scheduler, fun, scheduler.time, args...; id, type, description, kwargs...)
end

function register!(scheduler, fun, when::At, t, args...; id="", type="", description="", kwargs...)
    register!(scheduler, fun, t, args...; id, type, description, kwargs...)
end

function register!(scheduler, fun, when::After, t, args...; id="", type="", description="", kwargs...)
    register!(scheduler, fun, scheduler.time + t, args...; id, type, description, kwargs...)
end

function register!(scheduler, fun, when::Every, t, args...; id="", type="", description="", kwargs...)
    function f(args...; kwargs...) 
        fun1 = () -> fun(args...; kwargs...)
        fun1()
        register!(scheduler, fun, every, t, args...; id, type, description, kwargs...)
    end
    register!(scheduler, f, after, t, args...; id, type, description, kwargs...)
end

"""
    stop!(scheduler)

Stops simulation 

# Arguments

- `scheduler`: an event scheduler 
"""
function stop!(scheduler)
    scheduler.running = false
end


"""
    reset!(scheduler)

Resets time to 0 and empties event queue

# Arguments

- `scheduler`: an event scheduler 
"""
function reset!(scheduler)
    scheduler.running = true
    scheduler.time = 0.0
    empty!(scheduler.events)
end

"""
    run!(s::AbstractScheduler, until=Inf)

Run simulation until specified time

# Arguments

- `scheduler`: an event scheduler 
- `until`: time at which simulation ends
"""
function run!(s::AbstractScheduler, until=Inf)
    last_event!(s, until)
    while is_running(s, until)
        execute!(s)
    end
    s.trace && !s.running ? print_event(s.time, "", "stopped") : nothing
    return nothing
end

function execute!(s::AbstractScheduler)
    event = dequeue!(s.events)
    new_time = event.time
    s.time = new_time
    event.fun()
    s.store ? push!(s.complete_events, event) : nothing
    s.trace ? print_event(event) : nothing
    return nothing 
end

function is_running(s, until)
    !isempty(s.events) && s.running && 
        peek(s.events).first.time ≤ until
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
remove_events!: remove events by id 
-`s`: scheduler
- `until`: run until 
- `f`: removal function. Defaults to exact match.

Function signiture:
````julia
remove_events!(scheduler, id, f=(x,id)->x.first.id == id)
````
"""
function remove_events!(scheduler, id, f=(x,id)->x.first.id == id)
    events = filter(x->f(x, id), scheduler.events)
    for event in events
        delete!(scheduler.events, event.first)
    end
end

"""
replay_events: print completed events if stored 

Function signiture:
````julia
replay_events(s::AbstractScheduler)
````
"""
function replay_events(s::AbstractScheduler)
    for event in s.complete_events
       print_event(event)
    end
end