local async = require("cooperative-multitasking")

function ProcessFile(filename, index)
    local file = io.open(filename, "r")
    if not file then
        error("Unable to open file")
    end

    local rownum = 1
    for line in file:lines() do
        print(string.format("Num: %d, file: %s, data: %s", index, filename, line))
        rownum = rownum + 1
        coroutine.yield()
    end
    file:close()
end

local lurs = {
    async.luro:new(coroutine.create(ProcessFile), "data3.txt", 1),
    async.luro:new(ProcessFile, "data4.txt", 2),
    async.luro:new(coroutine.create(ProcessFile), "data3.txt", 3),
    async.luro:new(coroutine.create(ProcessFile), "data2.txt", 4),
    async.luro:new(ProcessFile, "data1.txt", 5),
    -- async.luro:new(coroutine.create(function (param, index)
    --     for i = 1, 100 do
    --         print(param .. " " .. index)
    --         coroutine.yield()
    --     end
    -- end), "data.txt", 6),
}

local container = async.container:new(lurs)
container:poll(8)
