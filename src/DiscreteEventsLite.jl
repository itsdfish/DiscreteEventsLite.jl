module DiscreteEventsLite
    using DataStructures
    export Scheduler, Event, run, schedule, remove_event!
    include("structs.jl")
    include("functions.jl")
end
