using DataStructures

struct At end
struct After end
struct Now end

const after = After()
const at = At()
const now = Now()

abstract type AbstractEvent end 

mutable struct Event{F<:Function} <: AbstractEvent
    fun::F 
    time::Float64
    id::String 
end

abstract type AbstractScheduler end 

mutable struct Scheduler{PQ<:PriorityQueue} <: AbstractScheduler
    events::PQ
    time::Float64
    running::Bool
end

function Scheduler(;event=Event, time=0.0, running=true)
    events = PriorityQueue{event,Float64}()
    return Scheduler(events, time, running)
end