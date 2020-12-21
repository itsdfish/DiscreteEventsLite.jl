using Revise, DiscreteEventsLite

f(a; k) = println(a, k)
g(scheduler, message) = add_event!(scheduler, f, 5.0, message; k=2)

scheduler = Scheduler(trace=false, store=true)
add_event!(scheduler, f, after, .99, "hi "; k=1, description="some event")
add_event!(scheduler, g, at, 2.0, scheduler, "I'm done "; id = "1")
add_event!(scheduler, stop!, at, 10.5, scheduler)
add_event!(scheduler, ()->(), every, 1.0; description="repeating")

run!(scheduler, 11)


replay_events(scheduler)