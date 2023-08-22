
local function deepFreeze(root)

    table.freeze(root)
    
    for _, value in root do
        if typeof(value) == "table" and not table.isfrozen(value) and getmetatable(value) == nil then
            deepFreeze(value)
        end
    end
    
end

return {
    deep = function(nextDispatch, store)
        return function(action)
            deepFreeze(store:getState())
            
            return nextDispatch(action)
        end
    end, 
    
    oneLevel = function(nextDispatch, store)
        return function(action)

            for _, value in store:getState() do
                if typeof(value) == "table" and not table.isfrozen(value) and getmetatable(value) == nil then
                    table.freeze(value)
                end
            end

            return nextDispatch(action)
        end
    end, 
    
    shallow = function(nextDispatch, store)
        return function(action)

            table.freeze(store:getState())

            return nextDispatch(action)
        end
    end
}
