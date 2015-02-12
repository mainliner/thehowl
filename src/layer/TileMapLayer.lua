local TileMapLayer = class("TileMapLayer", function() 
    return cc.Layer:create()
end)


function TileMapLayer:createLayer(mapName)
   local layer = TileMapLayer:new()
   layer:initTileMap(mapName)
   return layer 
end

function TileMapLayer:ctor()
    self.map = nil
    self.tileSize = nil
    self.mapSize = nil
    self.mapWidth = nil
    self.mapHeight = nil
    self.winSize = cc.Director:getInstance():getWinSize()
end

function TileMapLayer:initTileMap(mapName)
    self.map = ccexp.TMXTiledMap:create(mapName)
    self.map:setPosition(cc.p(0,0))
    self.tileSize = self.map:getTileSize()
    self.mapSize = self.map:getMapSize()
    self.mapWidth = self.tileSize.width*self.mapSize.width
    self.mapHeight = self.tileSize.height*self.mapSize.height
    self:addChild(self.map)
end

function TileMapLayer:checkMapPosition(x, y)
    -- don't let the hero run out of the tile map
    if x >= self.winSize.width/2 then 
        x = self.winSize.width/2
    end
    if x <= -1*(self.mapWidth-self.winSize.width/2) then
        x = -1*(self.mapWidth-self.winSize.width/2)
    end
    if y >= self.winSize.height/2 then
        y = self.winSize.height/2
    end 
    if y <= -1*(self.mapHeight-self.winSize.height/2) then
        y = -1*(self.mapHeight-self.winSize.height/2)
    end
    return x, y
end

function TileMapLayer:heroPosAtTileMap(curLayerX, curLayerY)
    -- find the tile map position of the screen's center
    local xDest = self.winSize.width/2 - curLayerX
    local yDest = self.winSize.height/2 -curLayerY
    local tileX = xDest / self.tileSize.width
    local tileY = (self.mapHeight - yDest) / self.tileSize.height
    local tilePos = cc.p(math.floor(tileX), math.floor(tileY))
    return tilePos
end

function TileMapLayer:isCollision(curLayerPosX, curLayerPoxY)
    local tilePos = self:heroPosAtTileMap(curLayerPosX, curLayerPoxY)
    local TileLayer = self.map:getLayer("background")
    local gid = TileLayer:getTileGIDAt(tilePos)
    local propertites = self.map:getPropertiesForGID(gid)
    if type(propertites) == type({}) and propertites['wall'] == '1' then
        --print("wall")
        return true
    else
        return false
    end
end

return TileMapLayer