
local table = require("table")

---@class Queue
Queue = {
    ---@type any[]
    items = {}
}
Queue.__index = Queue

---@param items any[]
---@return Queue
function Queue:new(items)
    local obj = setmetatable({}, Queue)
    obj.items = items
    return obj
end

---@param item any
function Queue:enqueue(item)
    table.insert(self.items, item)
end

---@return any
function Queue:dequeue()
    if #self.items == 0 then
        return nil
    end
    return table.remove(self.items, 1)
end

---@return boolean
function Queue:isEmpty()
    return #self.items == 0
end

---@return integer
function Queue:size()
    return #self.items
end


---@class Luroutine
local Luroutine = {
    ---@type thread
    coro = nil,
    ---@type any[]
    args = {},
}
Luroutine.__index = Luroutine

---@param co thread|fun(v: any):any
---@param ... any
---@return Luroutine
function Luroutine:new(co, ...)
    ---@class Luroutine
    local obj = setmetatable({}, Luroutine)
    local coro
    if type(co) == "thread" then
        coro = co
    elseif type(co) == "function" then
        coro = coroutine.create(co)
    else
        error("Parameter co must be an thread or a function")
    end
    
    obj.coro = coro
    obj.args = {...}
    return obj
end


---@class LuroutineContainer
local LuroutineContainer = {
    ---@type Queue
    queue = Queue:new({}),
}
LuroutineContainer.__index = LuroutineContainer

---@param lurs Luroutine[]
---@return LuroutineContainer
function LuroutineContainer:new(lurs)
    local obj = setmetatable({}, LuroutineContainer)
    obj.queue = Queue:new(lurs)
    return obj
end

---@param lurs Luroutine[]
function LuroutineContainer:setLurs(lurs)
    self.queue.items = lurs
end

---@param lurs Luroutine[]
function LuroutineContainer:appendLurs(lurs)
    local oldLurs = self.queue.items
    for _, lur in ipairs(lurs) do
        table.insert(oldLurs, lur)
    end
    self:setLurs(oldLurs)
end

function LuroutineContainer:step()
    local luro = self.queue:dequeue()
    if luro == nil then
        return
    end
    local status = coroutine.status(luro.coro)
    if status  == "suspended" then
        local success
        local message
        if luro.args == nil or #luro.args == 0 then
            success, message = coroutine.resume(luro.coro)
        else
            success, message = coroutine.resume(luro.coro, table.unpack(luro.args))
        end
        if not success then
            print(string.format("ERROR: %s", message))
        else
            self.queue:enqueue(luro)
        end
    end
end

function LuroutineContainer:poll(steps)
    local base = steps == nil and -1 or steps
    while not self.queue:isEmpty() and base ~= 0 do
        self:step()
        if base ~= -1 then
            base = base - 1
        end
    end
end


local async = {
    container = LuroutineContainer,
    luro = Luroutine
}
return async
