module DiscreteEventsLite
    using DataStructures
    export Scheduler, Event, run!, schedule, remove_event!, stop!
    export add_event!, after, at, now, every, remove_events!
    include("structs.jl")
    include("functions.jl")
end
