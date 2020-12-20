function add_event!(scheduler, fun, t, args...; id="", description="", kwargs...)
    event = Event(()->fun(args...; kwargs...), t, id, description)
    enqueue!(scheduler.events, event, t)
end

function add_event!(scheduler, fun, when::Now, t, args...; id="", description="", kwargs...)
    add_event!(scheduler, fun, scheduler.time, args...; id=id, description=description, kwargs...)
end

function add_event!(scheduler, fun, when::At, t, args...; id="",  description="", kwargs...)
    add_event!(scheduler, fun, t, args...; id=id, description=description, kwargs...)
end

function add_event!(scheduler, fun, when::After, t, args...; id="",  description="", kwargs...)
    add_event!(scheduler, fun, scheduler.time + t, args...; id=id, description=description, kwargs...)
end

function add_event!(scheduler, fun, when::Every, t, args...; id="",  description="", kwargs...)
    function f(args...; kwargs...) 
        add_event!(scheduler, fun, now, t, args...; id=id,  description=description, kwargs...)
        add_event!(scheduler, fun, every, t, args...; id=id,  description=description, kwargs...)
    end
    add_event!(scheduler, f, after, t, args...; id=id,  description=description, kwargs...)

    # add_event!(scheduler, fun, after, t, args...; id=id,  description=description, kwargs...)
    # add_event!(scheduler, f, after, t, args...; id=id,  description=description, kwargs...)
    # add_event!(scheduler, fun, every, t, args...; id=id,  description=description, kwargs...)
end

function remove_events!(scheduler)

end

function stop!(scheduler)
    scheduler.running = false
end

function resume!()
    scheduler.running = true
end

function run!(scheduler, until=Inf)
    events = scheduler.events
    last_event!(scheduler, until)
    while is_running(scheduler, until)
        event = dequeue!(events)
        new_time = event.time
        scheduler.time = new_time
        event.fun()
        scheduler.trace ? println(new_time, " ", event.description) : nothing
    end
    if scheduler.trace
        if scheduler.running 
             println(scheduler.time, " ", "done") 
        else 
            println(scheduler.time, " ", "paused")
        end
    end
    return nothing
end

function is_running(s, until)
    !isempty(s.events) && s.running && s.time ≤ until
end

function last_event!(scheduler, until)
    if until == Inf 
    else
        add_event!(scheduler, ()->(), after, until)
    end
    return nothing 
end
  