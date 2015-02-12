local StartScene = class("StartScene",function()
    return cc.Scene:create()
end)

function StartScene:createScene()
	local scene = StartScene.new()
	scene:startMenu()
	return scene
end

function StartScene:startMenu()
    --creat a layer, and add it to this scene
    local layer = cc.LayerColor:create(cc.c4b(255,255,255,255))
    --add this layer to the scene
    self:addChild(layer)
    
    --get the window's size
    local size = cc.Director:getInstance():getWinSize()
    
    --input the game scene
    local baseScene = require("scene.BaseScene")
    
    --create a start game menu item
    local startButton = cc.MenuItemFont:create("start")
    startButton:setColor(cc.c3b(0,0,0))
    startButton:setPosition(size.width/2, size.height/2)
    startButton:registerScriptTapHandler(function(sender) 
        local newScene = baseScene:createScene()
         cc.Director:getInstance():replaceScene(newScene)
    end)
    --create a exit game menu item
    local exitButton = cc.MenuItemFont:create("exit")
    exitButton:setScale(0.5)
    exitButton:setColor(cc.c3b(0,0,0))
    exitButton:setPosition(size.width-50, 50)
    exitButton:registerScriptTapHandler(function(sender) 
        cc.Director:getInstance():endToLua()
    end)
    
    --create a menu
    local menu = cc.Menu:create(startButton,exitButton)
    menu:setPosition(0,0)
    layer:addChild(menu)
end

return StartScene