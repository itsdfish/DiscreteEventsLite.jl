"""
API: 
- `Scheduler`
- `Event`
- `run!`
- `schedule`
- `remove_event!`
- `stop!`
- `add_event!`
- `reset!`
- `replay_events`
- `when types:` now, at, after, every

Use help for more information, e.i.
````julia
] add_event!
````
"""
module DiscreteEventsLite
    using DataStructures
    export Scheduler, Event, run!, remove_event!, stop!
    export add_event!, after, at, now, every, remove_events!, reset!
    export replay_events
    include("structs.jl")
    include("functions.jl")
end
