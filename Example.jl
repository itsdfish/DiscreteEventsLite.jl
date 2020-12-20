using Revise, DiscreteEventsLite

f(a; k) = println(a, k)
g(scheduler, message) = add_event!(scheduler, f, 5.0, message; k=2)

scheduler = Scheduler(trace=true)
add_event!(scheduler, f, after, 1.0, "hi "; k=1)
add_event!(scheduler, g, at, 2.0, scheduler, "I'm done ")
add_event!(scheduler, stop!, at, 10.5, scheduler)
add_event!(scheduler, ()->println("repeat"), every, 1.0)

run!(scheduler, 10^1)


# 0.158844 seconds (2.64 M allocations: 66.258 MiB, 10.18% gc time)
# "run! finished with 100000 clock events, 0 sample steps, simulation time: 100000.0"