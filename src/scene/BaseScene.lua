local BaseScene = class("BaseScene",function()
    return cc.Scene:create() 
end)


function BaseScene:createScene()
    local scene = BaseScene:new()
    scene:init()
    return scene
end

function BaseScene:init()
    --tile map and monster will add in this layer
    local TileMapLayer = require("src.layer.TileMapLayer")
    self.mapLayer = TileMapLayer:createLayer("map/start_map.tmx")
    self:addChild(self.mapLayer)
    
    --hero and ui will add in this layer
    local Layer = require("src.layer.BaseLayer")
    self.gameLayer = Layer:createLayer()
    self:addChild(self.gameLayer)
    
    --create a controller
    local Controller = require("src.controller.Controller")
    self.controller = Controller:create(self.mapLayer, self.gameLayer)
    self:addChild(self.controller)
end

function BaseScene:ctor()
    self.mapLayer = nil
    self.gameLayer = nil
    self.controller = nil
end

return BaseScene