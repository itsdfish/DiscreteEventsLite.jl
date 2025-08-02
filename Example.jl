using Revise, DiscreteEventsLite

f(a; k) = println(a, k)
g(scheduler, message) = register!(scheduler, f, 5.0, message; k = 2)

scheduler = Scheduler(trace = true, store = true)
register!(scheduler, f, after, 0.99, "hi "; k = 1, description = "some event")
register!(scheduler, g, at, 2.0, scheduler, "I'm done "; id = "1")
register!(scheduler, stop!, at, 10.5, scheduler)
register!(scheduler, ()->(), every, 1.0; description = "repeating")

run!(scheduler, 11)

replay_events(scheduler)
