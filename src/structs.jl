using DataStructures

struct At end
struct After end
struct Now end
struct Every end

const after = After()
const at = At()
const now = Now()
const every = Every()

abstract type AbstractEvent end 

mutable struct Event{F<:Function} <: AbstractEvent
    fun::F 
    time::Float64
    id::String
    description::String 
end

abstract type AbstractScheduler end 

mutable struct Scheduler{PQ<:PriorityQueue} <: AbstractScheduler
    events::PQ
    time::Float64
    running::Bool
    trace::Bool
end

function Scheduler(;event=Event, time=0.0, running=true, trace=false)
    events = PriorityQueue{event,Float64}()
    return Scheduler(events, time, running, trace)
end