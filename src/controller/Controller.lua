local Controller = class("Controller", function() 
    return cc.Node:create()
end)

function Controller:create(mapLayer ,gameLayer)
    --return a new object
    local controller = Controller:new()
    controller:initGameLayer(gameLayer)
    controller:initMapLayer(mapLayer)
    controller:registerEvent()
    controller:updateLogic()
    return controller
end

function Controller:ctor()
    -- this function be called in new()
    -- init all the member
    self.gameLayer = nil
    self.mapLayer = nil
    self.size = nil
    self.hero = nil
    
    self.right = 0
    self.left = 0
    self.up = 0
    self.down = 0
    self.speed = -1
end

function Controller:initMapLayer(mapLayer)
    self.mapLayer = mapLayer
end

function Controller:initGameLayer(layer)
    self.gameLayer = layer
    self.size = cc.Director:getInstance():getWinSize()
    
    --create a hero in this layer
    local Hero = require("src.sprite.Hero")
    self.hero = Hero:createSprite()
    self.hero:setAnchorPoint(cc.p(0.5,0.5))
    self.hero:setPosition(self.size.width/2,self.size.height/2)
    self.hero:setScale(1)
    print(self.hero:getContentSize().width .." : " ..self.hero:getContentSize().height)
    print(self.hero:getAnchorPoint().x .. self.hero:getAnchorPoint().y)
    self.gameLayer:addChild(self.hero)

end

function Controller:registerEvent()
    --register a keyboard event listener
    --controll the hero to move
    local dispatcher = cc.Director:getInstance():getEventDispatcher()
    local listener = cc.EventListenerKeyboard:create() 
    local onKeyPress = function(keyCode, event)
        if keyCode == cc.KeyCode.KEY_W then
            self.up = 1
        end
        if keyCode == cc.KeyCode.KEY_S then
            self.down = 1
        end
        if keyCode == cc.KeyCode.KEY_A then
            self.left = 1
        end
        if keyCode == cc.KeyCode.KEY_D then
            self.right = 1
        end 
    end

    local onKeyReleased = function(keyCode, event)
        if keyCode == cc.KeyCode.KEY_W then
            self.up = 0
        end
        if keyCode == cc.KeyCode.KEY_S then
            self.down = 0
        end
        if keyCode == cc.KeyCode.KEY_A then
            self.left = 0
        end
        if keyCode == cc.KeyCode.KEY_D then
            self.right = 0
        end
    end
    listener:registerScriptHandler(onKeyPress, cc.Handler.EVENT_KEYBOARD_PRESSED)
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
    dispatcher:addEventListenerWithSceneGraphPriority(listener,self)
end

function Controller:updateLogic()
    self:scheduleUpdateWithPriorityLua(function(dt)
        local vec_up = cc.p(0,self.up)
        local vec_down = cc.p(0, -1*self.down)
        local vec_right = cc.p(self.right, 0)
        local vec_left = cc.p(-1*self.left, 0)
        local arrow = cc.pAdd(cc.pAdd(vec_up,vec_down), cc.pAdd(vec_right,vec_left))
        
        if (arrow.x ~= 0 or arrow.y ~= 0) then
            self.hero:rotateSprite( cc.pGetAngle(arrow, cc.p(1,0)) )
            if self.hero.state == "stand" then
                self.hero:toWalk()
            end
            local currentPosX = self.mapLayer:getPositionX()
            local currentPosY = self.mapLayer:getPositionY()
            local destPosX = currentPosX+self.speed*arrow.x
            local destPosY = currentPosY+self.speed*arrow.y
            destPosX, destPosY = self.mapLayer:checkMapPosition(destPosX,destPosY) 
            if self.mapLayer:isCollision(destPosX, destPosY) then
                --collision happen
                print("collision")
            else
                self.mapLayer:setPosition(destPosX, destPosY)
            end
        else
            if self.hero.state == "walk" then
                self.hero:toStand()
            end
        end
    end,0)
end

return Controller