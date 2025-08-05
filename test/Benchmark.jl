using DiscreteEventsLite

scheduler = Scheduler()
register!(scheduler, s -> s, every, 1.0, 2)
@time run!(scheduler, 10^5)
