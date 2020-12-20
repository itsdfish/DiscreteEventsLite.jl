function add_event!(scheduler, fun, t, args...; id="", kwargs...)
    event = Event(()->fun(args...; kwargs...), t, id)
    enqueue!(scheduler.events, event, t)
end

function add_event!(scheduler, fun, when::Now, t, args...; id="", kwargs...)
    add_event!(scheduler, fun, scheduler.time, args...; id=id, kwargs...)
end

function add_event!(scheduler, fun, when::At, t, args...; id="", kwargs...)
    add_event!(scheduler, fun, t, args; id=id, kwargs...)
end

function add_event!(scheduler, fun, when::After, t, args...; id="", kwargs...)
    add_event!(scheduler, fun, scheduler.time + t, args...; id=id, kwargs...)
end

function remove_events!(scheduler)

end

function stop!(scheduler)
    scheduler.running = false
end

function resume!()
    scheduler.running = true
end

function run!(scheduler)
    events = scheduler.events
    while !isempty(events) && scheduler.running
        event = dequeue!(events)
        event.fun()
    end
end
  