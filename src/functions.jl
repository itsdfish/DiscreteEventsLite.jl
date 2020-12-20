function run(scheduler)
    events = scheduler.events
    while !isempty(events) && scheduler.running
        event = dequeue!(events)
        event.fun()
    end
end
  