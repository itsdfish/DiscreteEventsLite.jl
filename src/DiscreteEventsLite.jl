"""
API: 
- `Scheduler`: scheduler object
- `Event`: event object
- `run!`: run simulation
- `remove_event!`: remove event
- `stop!`: stop simulation
- `register!`: add event to scheduler
- `reset!`: reset scheduler
- `replay_events`: print out completed events 
- `when types:` now, at, after, every

Use help for more information, e.i.
````julia
] register!
````
"""
module DiscreteEventsLite
using DataStructures, Printf
export Scheduler
export Event
export run!
export remove_event!
export stop!
export register!
export after
export at
export now
export every
export remove_events!
export reset!
export replay_events

include("structs.jl")
include("functions.jl")
end
