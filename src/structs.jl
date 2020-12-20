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

function add_event!(scheduler, fun, t, args...; id="", kwargs...)
    event = Event(()->fun(args...; kwargs...), t, id)
    enqueue!(scheduler.events, event, t)
end

function add_event!(scheduler, fun, when::Now, t, args...; id="", kwargs...)
    add_event!(scheduler, fun, scheduler.time, args...; id=id, kwargs...)
end

function add_event!(scheduler, fun, when::At, t, args...; id="", kwargs...)
    add_event!(scheduler, fun, t, args; id=id, kwargs...)
end

function add_event!(scheduler, fun, when::After, t, args...; id="", kwargs...)
    add_event!(scheduler, fun, scheduler.time + t, args...; id=id, kwargs...)
end

function remove_events!(scheduler)

end

function stop!(scheduler)
    scheduler.running = false
end

function resume!()
    scheduler.running = true
end

scheduler = Scheduler()

f(a; k) = println(a, k)
add_event!(scheduler, f, 1.0, "bye"; k=1)

event = dequeue!(scheduler.events)

event.fun()