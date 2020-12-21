"""
add_event!

An interface for adding events to the scheduler. 

- `scheduler`: an event scheduler
- `fun`: a function to execute
- `when`: timing for the execution of `fun`. Options: `at`, `now`, `every`, `after`
- `t`: time value associated with `when` 
- `args...`: optional positional arguments for `fun`
- `id`: optional id string 
- `description`: optional description
- `kwargs...`: option keyword arguments for `fun`

Function signiture:
```julia 
add_event!(scheduler, fun, when, t, args...; id="", description="", kwargs...)
```
"""
function add_event!(scheduler, fun, t, args...; id="", description="", kwargs...)
    event = Event(()->fun(args...; kwargs...), t, id, description)
    enqueue!(scheduler.events, event, t)
end

function add_event!(scheduler, fun, when::Now, t, args...; id="", description="", kwargs...)
    add_event!(scheduler, fun, scheduler.time, args...; id=id, description=description, kwargs...)
end

function add_event!(scheduler, fun, when::At, t, args...; id="", description="", kwargs...)
    add_event!(scheduler, fun, t, args...; id=id, description=description, kwargs...)
end

function add_event!(scheduler, fun, when::After, t, args...; id="", description="", kwargs...)
    add_event!(scheduler, fun, scheduler.time + t, args...; id=id, description=description, kwargs...)
end

function add_event!(scheduler, fun, when::Every, t, args...; id="", description="", kwargs...)
    function f(args...; kwargs...) 
        fun1 = ()->fun(args...; kwargs...)
        fun1()
        add_event!(scheduler, fun, every, t, args...; id=id, description=description, kwargs...)
    end
    add_event!(scheduler, f, after, t, args...; id=id, description=description, kwargs...)
end

function remove_events!(scheduler)

end

"""
`stop!`: stop simulation 

Function signiture:
````julia
stop!(scheduler)
````
"""
function stop!(scheduler)
    scheduler.running = false
end


"""
`reset!`: reset simulation 

Function signiture:
````julia
reset!(scheduler)
````
"""
function reset!(scheduler)
    scheduler.running = true
    scheduler.time = 0.0
    empty!(scheduler.events)
end

"""
run!: run simulation 
-`s`: scheduler
- `until`: run until 

Function signiture:
````julia
run!(s::AbstractScheduler, until=Inf)
````
"""
function run!(s::AbstractScheduler, until=Inf)
    events = s.events
    last_event!(s, until)
    while is_running(s, until)
        event = dequeue!(events)
        new_time = event.time
        s.time = new_time
        event.fun()
        s.store ? push!(s.complete_events, event) : nothing
        s.trace ? print_event(event) : nothing
    end
    if s.trace
        if s.running 
             println(s.time, " ", "done") 
        else 
            println(s.time, " ", "paused")
        end
    end
    return nothing
end

function is_running(s, until)
    !isempty(s.events) && s.running && peek(s.events).first.time ≤ until
end

function last_event!(scheduler, until)
    if until == Inf 
    else
        add_event!(scheduler, ()->(), after, until)
    end
    return nothing 
end

function print_event(event)
    println("time:  ", event.time, "   id   ", event.id, "    ", event.description)
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