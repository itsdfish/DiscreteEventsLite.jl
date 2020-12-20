module DiscreteEventsLite
    using DataStructures
    export Scheduler, Event, run!, schedule, remove_event!, stop!
    export add_event!, after, at, now, every
    include("structs.jl")
    include("functions.jl")
end
