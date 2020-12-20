using Revise, DiscreteEventsLite

f(a; k) = println(a, k)
g(scheduler, message) = add_event!(scheduler, f, 5.0, message; k=2)

scheduler = Scheduler(trace=true)
# add_event!(scheduler, f, after, 1.0, "hi "; k=1)
# add_event!(scheduler, g, at, 2.0, scheduler, "I'm done ")
add_event!(scheduler, stop!, at, 10.5, scheduler)
add_event!(scheduler, x->println("hi $x"), every, 1.0, 1)

run!(scheduler, Inf)