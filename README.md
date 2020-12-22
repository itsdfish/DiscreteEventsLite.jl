# DiscreteEventsLite

DiscereteEventsLite is a lightweight package for running discrete event simulations. In DiscreteEventsLite, events are registered to a priority queue and executed in temporal sequence. 
Some inspiration for this package was taken from [DiscreteEvents](https://github.com/pbayer/DiscreteEvents.jl), which is a well-designed, comprehensive framework for discrete event simulation. 

I created this package because I wanted something simple and hackable. In addition, I needed something with the ability to remove events based on id or other criteria, optionally print event traces, and optionally log events. The package you should use will depend on your goals. If you want a package that is lightweight and easily hackable, this package might be suitable for you. Otherwise, you might prefer a full-featured framework, such as [DiscreteEvents](https://github.com/pbayer/DiscreteEvents.jl). You might also checkout [SimJulia](https://simjuliajl.readthedocs.io/en/stable/welcome.html), or [EventStimulation](https://github.com/bkamins/EventSimulation.jl) for other approaches.

## Usage

````julia
using DiscreteEventsLite
# Define some functions
f(a; k) = println(a, k)
g(scheduler, message) = register!(scheduler, f, 5.0, message; k=2)

# Create a scheduler
scheduler = Scheduler(store=true)
# some examples of event scheduling
register!(scheduler, f, after, .99, "hi "; k=1, description="some event")
register!(scheduler, g, at, 2.0, scheduler, "I'm done "; id = "1")
register!(scheduler, stop!, at, 10.5, scheduler)
register!(scheduler, ()->(), every, 1.0; description="repeating")
# Run the model
run!(scheduler, 11)
# Optionally print the events if store=true
replay_events(scheduler)
````
For more information, use the help function:
````julia

] DiscreteEventsLite
] register!
````

## Extending

The functionality of the package can be extended by creating subtypes of `AbstractEvent` and/or `AbstractScheduler`, and use multiple dispatch to add desired behavior. 