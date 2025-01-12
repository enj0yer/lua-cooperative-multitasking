local multitasking = require("cooperative-multitasking")


local container = multitasking.container:new({})

function Process(filename, iters)
    for i = 1, iters, 1 do
        print(string.format("Processing filename %s: %d%%", filename, math.floor(i / iters * 100)))
        io.popen("ls")
        coroutine.yield()
    end
end

function DoublePrinter(...)
    local args = {...}

    for i = 1, 2, 1 do
        for index, value in ipairs(args) do
            print(string.format("Given %s to printer", value))
            coroutine.yield()
        end
    end
end

local lurs = {
    multitasking.luro:new(coroutine.create(Process), "input.txt", 21),
    multitasking.luro:new(coroutine.create(Process), "input.txt", 24),
    multitasking.luro:new(coroutine.create(DoublePrinter), "Foo", math.random(1, 1000), math.random(400, 4824), math.random(1, 10), "Bar", "Baz"),
    multitasking.luro:new(coroutine.create(Process), "output.txt", 79),
    multitasking.luro:new(coroutine.create(Process), "output.txt", 30),
    multitasking.luro:new(coroutine.create(DoublePrinter), "Con", math.random(1, 1000), math.random(400, 4824), math.random(1, 10), "Cur", "Rent"),
    multitasking.luro:new(coroutine.create(Process), "some.data", 50),
    multitasking.luro:new(coroutine.create(Process), "some.data", 68),
    multitasking.luro:new(coroutine.create(DoublePrinter), "Co", math.random(100, 100000), math.random(848, 869), math.random(2, 20), "Rou", "Tine"),
}

container:setLurs(lurs)

container:process()
