struct At end
struct After end
struct Now end
struct Every end

const after = After()
const at = At()
const now = Now()
const every = Every()

abstract type AbstractEvent end

"""
    Event <: AbstractEvent

#Fields 

- `fun`: a function
- `time`: time of function call 
- `id`: an event id
- `type`: type of event
- `description`: a description of the event
"""
mutable struct Event{F <: Function} <: AbstractEvent
    fun::F
    time::Float64
    id::String
    type::String
    description::String
end

function Event(; fun, time, id, type, description)
    return Event(fun, time, id, type, description)
end

abstract type AbstractScheduler end

"""
    Scheduler <: AbstractScheduler

# Fields

- `events`: a priority queue of events
- `time`: current time of the system 
- `can_run`: simulation can run if true
- `trace`: will print out the events if true
- `store`: will store a vector of completed events if true
- `complete_events`: an optional vector of completed events

# Constructors

    Scheduler(;
        event = Event,
        time = 0.0,
        can_run = true,
        trace = false,
        store = false
    )
        
    Scheduler(events, time, can_run, trace, store, complete_events)
"""
mutable struct Scheduler{PQ <: PriorityQueue, E} <: AbstractScheduler
    events::PQ
    time::Float64
    can_run::Bool
    trace::Bool
    store::Bool
    complete_events::E
end

function Scheduler(;
    event = Event,
    time = 0.0,
    can_run = true,
    trace = false,
    store = false
)
    events = PriorityQueue{event, Float64}()
    return Scheduler(events, time, can_run, trace, store, Vector{event}())
end
