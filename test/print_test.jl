    event = Event(; fun = () -> (), time = 1.0, id = "3", type = "3", description = "hello")

    output = Suppressor.@capture_out print_event(event)
    @test output == "time:  1.000   id   3    hello\n"