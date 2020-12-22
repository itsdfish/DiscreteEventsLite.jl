using SafeTestsets

@safetestset "DiscreteEventsLite" begin
    using DiscreteEventsLite, DataStructures, Test
    f(a; k) = (a, k)
    scheduler = Scheduler()
    register!(scheduler, f, after, .99, "hi "; k=1, description="123")
    event = peek(scheduler.events).first 
    @test event.description == "123"
    run!(scheduler, 11)
    @test scheduler.time ≈ 11
    @test length(scheduler.events) == 0

    scheduler = Scheduler()
    register!(scheduler, f, after, .99, "hi "; k=1)
    register!(scheduler, stop!, .5, scheduler)
    run!(scheduler, 11)
    @test scheduler.time ≈ .5
    @test length(scheduler.events) == 2

    scheduler = Scheduler()
    register!(scheduler, f, after, .99, "hi "; k=1)
    event = dequeue!(scheduler.events)
    v1,v2 = event.fun()
    @test v1 == "hi "
    @test v2 == 1

    scheduler = Scheduler()
    register!(scheduler, f, after, .99, "hi "; k=1, id="1")
    register!(scheduler, f, after, 1.99, "hi "; k=1, id="2")
    remove_events!(scheduler, "1")
    event = dequeue!(scheduler.events)
    @test event.id == "2"

    scheduler = Scheduler()
    register!(scheduler, f, every, 1.0, "hi "; k=1)
    run!(scheduler, 10)
    @test scheduler.time == 10

    scheduler = Scheduler()
    register!(scheduler, f, every, 1.0, "hi "; k=1)
    register!(scheduler, ()->(), at, 10.5)
    run!(scheduler, 10)
    @test scheduler.time == 10

    scheduler = Scheduler()
    register!(scheduler, f, every, 1.0, "hi "; k=1)
    register!(scheduler, ()->(), at, 10.5)
    register!(scheduler, stop!, 5.0, scheduler)
    run!(scheduler, 10)
    @test scheduler.time == 5

    scheduler = Scheduler()
    register!(scheduler, f, every, 1.0, "hi "; k=1)
    register!(scheduler, ()->(), at, 10.5)
    register!(scheduler, stop!, 5.0, scheduler)
    DiscreteEventsLite.reset!(scheduler)
    @test scheduler.time == 0
    @test isempty(scheduler.events)

    scheduler = Scheduler(;store=true)
    register!(scheduler, f, every, 1.0, "hi "; k=1)
    register!(scheduler, ()->(), at, 10.5)
    run!(scheduler, 11)
    @test length(scheduler.complete_events) == 13
end
