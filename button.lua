--Meta class
--Button = {gui, text = "", foregroundColour, backgroundColour, posX, posY, sizeX, sizeY, height, action}
Button = {}
Button.__index = Button

--function Button:new(o) 
--	local o = o or {}
--	setmetatable(o, self)
--	self.__index = self
--	return o
--end

function Button.create(gui, text, foregroundColour, backgroundColour, x, y, width, height)
	local self = setmetatable({}, Button)
	self.gui = gui
	self.text = text
	self.foregroundColour = foregroundColour or self.gui.theme['buttonForegroundColour']
	self.backgroundColour = backgroundColour or self.gui.theme['buttonBackgroundColour']
	self.pos = { x = x, y = y }
	self.size = { x = width, y = height }
	self.action = nil
	self.type = "button"
	return self
end

function Button:getTitle()
	return self.text
end

function Button:setTitle(text)
	self.text = tostring(text)
	self.width = nil -- autoSize
	if (self.gui ~= nil) then
		--self.gui:blank()
	end
end

function Button:getText()
	return self.text
end

function Button:setText(text)
	self:setTitle(text)
end

function Button:getColours()
	local colours = {foregroundColour = self.foregroundColour, backgroundColour = self.backgroundColour}
	return colours
end

function Button:setColours(foregroundColour, backgroundColour)
	self.foregroundColour = foregroundColour
	self.backgroundColour = backgroundColour
end

function Button:getPos()
	local pos = {x = self.pos['x'], y = self.pos['y']}
	return pos
end

function Button:setPos(x, y)
	self.pos['x'] = tonumber(x)
	self.pos['y'] = tonumber(y)
end

function Button:getSize()
	if (self.size['x'] == nil) then
		self.size['x'] = tonumber(#tostring(self.text) + 2)
	end
	if (self.size['y'] == nil) then
		self.size['y'] = 3
	end
	return self.size
end

function Button:setSize(x, y)
	self.width = tonumber(x)
	self.height = tonumber(y)
end

function Button:getType()
	return self.type
end

function Button:getAction()
	return self.action
end

function Button:setAction(action)
	self.action = action
end

function Button:draw(gui)
	local colours = self:getColours()
	local pos = self:getPos()
	local size = self:getSize()
	if (colours['foregroundColour'] == nil) then
		colours['foregroundColour'] = gui.theme['buttonForegroundColour']
	end
	if (colours['backgroundColour'] == nil) then
		colours['backgroundColour'] = gui.theme['buttonBackgroundColour']
	end
	gui:setColours(colours['foregroundColour'], colours['backgroundColour'])
	--for i = 1, size['y'] do
	--	gui:printLine(" ", size['x'], pos['y'] + (i - 1), pos['x'])
	--end
	if (mode == "OC") then
		gui.window:fill(pos['x'], pos['y'], size['x'], size['y'], " ")
	end
	if (mode == "CC") then
		gui:fill(pos['x'], pos['y'], size['x'], size['y'], " ")
	end
	gui:printAt(self:getTitle(), pos['x'], pos['y'])
	gui:setColours()
end
