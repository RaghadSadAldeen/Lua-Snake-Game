
local Entity = {}
Entity.__index = Entity

function Entity:new()
    local entity = {
        components = {}
    }

    return setmetatable(entity, Entity)
end

function Entity:addComponent(name, component)
    self.components[name] = component
end

function Entity:getComponent(name)
    return self.components[name]
end

function Entity:hasComponent(name)
    return self.components[name] ~= nil
end

return Entity
