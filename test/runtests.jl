using SafeTestsets


@safetestset "events" begin 
    using DiscreteEventsLite
    using DataStructures
    using Test
    f(a; k) = (a, k)
    scheduler = Scheduler()
    register!(scheduler, f, after, 0.99, "hi "; k = 1, description = "123")
    event = first(scheduler.events).first

    @test event.description == "123"
    @test event.time == .99
    @test event.id == ""
    @test event.type == ""
end

@safetestset "run after" begin 
    using DiscreteEventsLite
    using DataStructures
    using Test

    f(a; k) = (a, k)
    scheduler = Scheduler()
    register!(scheduler, f, after, 0.99, "hi "; k = 1, description = "123")

    run!(scheduler, 11)
    @test scheduler.time ≈ 11
    @test isempty(scheduler.events)
    @test isempty(scheduler.complete_events)
end

@safetestset "stop!" begin 
    using DiscreteEventsLite
    using DataStructures
    using Test

    f(a; k) = (a, k)
    scheduler = Scheduler()
    register!(scheduler, f, after, 0.99, "hi "; k = 1)
    register!(scheduler, stop!, 0.5, scheduler)
    run!(scheduler, 11)
    @test scheduler.time ≈ 0.5
    @test length(scheduler.events) == 2
end

@safetestset "arguments" begin 
    using DiscreteEventsLite
    using DataStructures
    using Test

    f(a; k) = (a, k)
    scheduler = Scheduler()
    register!(scheduler, f, after, 0.99, "hi "; k = 1)
    event, _ = popfirst!(scheduler.events)
    v1, v2 = event.fun()
    @test v1 == "hi "
    @test v2 == 1
end

@safetestset "arguments" begin 
    using DiscreteEventsLite
    using DataStructures
    using Test

    f(a; k) = (a, k)
    scheduler = Scheduler()
    register!(scheduler, f, after, 0.99, "hi "; k = 1)
    event, _ = popfirst!(scheduler.events)
    v1, v2 = event.fun()
    @test v1 == "hi "
    @test v2 == 1
end

@safetestset "remove_events" begin 
    using DiscreteEventsLite
    using DataStructures
    using Test

    f(a; k) = (a, k)
    scheduler = Scheduler()
    register!(scheduler, f, after, 0.99, "hi "; k = 1, id = "1")
    register!(scheduler, f, after, 1.99, "hi "; k = 1, id = "2")
    remove_events!(scheduler, "1")
    event, _ = popfirst!(scheduler.events)
    @test event.id == "2"
end

@safetestset "run every" begin 
    using DiscreteEventsLite
    using DataStructures
    using Test
    
    f(a; k) = (a, k)
    scheduler = Scheduler()
    register!(scheduler, f, every, 1.0, "hi "; k = 1)
    register!(scheduler, () -> (), at, 10.5)
    run!(scheduler, 10)
    @test scheduler.time == 10
    @test !isempty(scheduler.events)
end

@safetestset "run at" begin 
    using DiscreteEventsLite
    using DataStructures
    using Test
    
    f(a; k) = (a, k)
    scheduler = Scheduler()
    register!(scheduler, f, every, 1.0, "hi "; k = 1)
    register!(scheduler, () -> (), at, 10.5)
    register!(scheduler, stop!, 5.0, scheduler)
    
    run!(scheduler, 10)
    @test scheduler.time == 5
    @test !isempty(scheduler.events)
end

@safetestset "run every stop" begin 
    using DiscreteEventsLite
    using DataStructures
    using Test
    
    f(a; k) = (a, k)
    scheduler = Scheduler()
    register!(scheduler, f, every, 1.0, "hi "; k = 1)
    register!(scheduler, () -> (), at, 10.5)
    register!(scheduler, stop!, 5.0, scheduler)
    DiscreteEventsLite.reset!(scheduler)
    @test scheduler.time == 0
    @test isempty(scheduler.events)
end

@safetestset "run every stop" begin 
    using DiscreteEventsLite
    using DataStructures
    using Test
    
    f(a; k) = (a, k)
    scheduler = Scheduler(; store = true)
    register!(scheduler, f, every, 1.0, "hi "; k = 1)
    register!(scheduler, () -> (), at, 10.5)
    run!(scheduler, 11)
    @test length(scheduler.complete_events) == 13
end

@safetestset "print" begin 
    using DiscreteEventsLite
    using DiscreteEventsLite: print_event
    using DataStructures
    using Suppressor
    using Test
    
    include("print_test.jl")
end
