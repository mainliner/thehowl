local BaseLayer = class("BaseLayer",function()
    return cc.Layer:create()
end)


function BaseLayer:createLayer()
    local layer = BaseLayer:new()
    layer:updateLogic()
    return layer
end

function BaseLayer:ctor()
    self.winSize = cc.Director:getInstance():getWinSize()
end

function BaseLayer:updateLogic()
    self:scheduleUpdateWithPriorityLua(function(dt)
        
    end, 0)
end

return BaseLayer