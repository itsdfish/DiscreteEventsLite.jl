using DiscreteEventsLite
scheduler = Scheduler()

f(a; k) = println(a, k)
add_event!(scheduler, f, 1.0, "bye"; k=1)

run!(scheduler)