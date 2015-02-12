local Hero = class("hero", function() 
    return cc.Sprite:create()
end)


function Hero:createSprite()
    local sp = Hero.new()
    sp:init()
    return sp
end

function Hero:ctor()
    self.walkAnimationFrame = {}
    self.standAnimationFrame = {}
    self.state = "stand"
end

function Hero:init()
    local width = 50
    local height = 50

    --set the spirte's size
    self:setContentSize(width,height)
    
    --set name and tag
    self:setName("hero")
    self:setTag(1)
    
    --create a physic box
    local heroBox = cc.PhysicsBody:createBox(cc.size(width, height))

    self:setPhysicsBody(heroBox)
    self:getPhysicsBody():setDynamic(false)
    self:getPhysicsBody():setRotationEnable(true)
    self:getPhysicsBody():setGravityEnable(false)
    self:getPhysicsBody():setCategoryBitmask(0x03)
    self:getPhysicsBody():setContactTestBitmask(0x01)
    self:getPhysicsBody():setCollisionBitmask(0x01)

    local cache = cc.SpriteFrameCache:getInstance()
    cache:addSpriteFrames("bob-0001-default.plist","bob-0001-default.png")
    
    for i = 1,4 do
        local frame = cache:getSpriteFrame(string.format("bob_walk_%d.png",i))
        self.walkAnimationFrame[i] = frame
        frame = cache:getSpriteFrame(string.format("bob_stand_%d.png",i))
        self.standAnimationFrame[i] = frame
    end
    local animation = cc.Animation:createWithSpriteFrames(self.standAnimationFrame,1.2,1)
    local animate = cc.Animate:create(animation)
    self:runAction(cc.RepeatForever:create(animate))
    
    --update in every frame
    self:scheduleUpdateWithPriorityLua(function(dt)
        print("this is update in every frame")
        self:unscheduleUpdate() 
    end,0)
    
    --this function define in the extern.lua 
    --schedule(self,self.updateCB,1.0)
end

function Hero:toWalk()
    self.state = "walk"
    self:stopAllActions()
    local animation = cc.Animation:createWithSpriteFrames(self.walkAnimationFrame,0.1,1)
    local animate = cc.Animate:create(animation)
    self:runAction(cc.RepeatForever:create(animate))
end

function Hero:toStand()
    self.state = "stand"
    self:stopAllActions()
    local animation = cc.Animation:createWithSpriteFrames(self.standAnimationFrame,1.2,1)
    local animate = cc.Animate:create(animation)
    self:runAction(cc.RepeatForever:create(animate))
end

function Hero:rotateSprite(radian)
    -- translate radian to degress
    local degress = math.deg(radian)
    self:setRotation(degress)
end


return Hero