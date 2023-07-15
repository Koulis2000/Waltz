--Meta class
--Label = {gui, text = "", foregroundColour, backgroundColour, posX, posY, sizeX, sizeY}
Label = {}
Label.__index = Label

function Label.create(gui, text, foregroundColour, backgroundColour, x, y, width, height)
	local self = setmetatable({}, Label)
	self.gui = gui
	self.text = text
	self.foregroundColour = foregroundColour
	self.backgroundColour = backgroundColour
	self.pos = { x = x, y = y }
	self.size = { x = width, y = height }
	self.type = "label"
	return self
end

function Label:getText()
	return self.text
end

function Label:getTitle()
	return self:getText()
end

function Label:setText(text)
	text = tostring(text)
	-- be lazy, only update if different
	if (self.text ~= text) then
		self.text = text
		self.size['x'] = nil -- autoSize
		if (self.gui ~= nil) then
			--self.gui:blank()
		end
	end
end

function Label:setTitle(title)
	self:setText(title)
end

function Label:getColours()
	local colours = {foregroundColour = self.foregroundColour, backgroundColour = self.backgroundColour}
	return colours
end

function Label:setColours(foregroundColour, backgroundColour)
	self.foregroundColour = foregroundColour
	self.backgroundColour = backgroundColour
end

function Label:getPos()
	local pos = {x = self.pos['x'], y = self.pos['y']}
	return pos
end

function Label:setPos(x, y)
	self.pos['x'] = tonumber(x)
	self.pos['y'] = tonumber(y)
end

function Label:getSize()
	if (self.size['x'] == nil) then
		self.size['x'] = tonumber(#tostring(self.text))
	end
	if (self.size['y'] == nil) then
		self.size['y'] = 1
	end
	return self.size
end

function Label:setSize(x, y)
	self.size['x'] = tonumber(x)
	self.size['y'] = tonumber(y)
end

function Label:getType()
	return "label"
end

function Label:draw() 
	local colours = self:getColours()
	local pos = self.pos
	local size = self:getSize()
	if (colours['foregroundColour'] == nil) then
		colours['foregroundColour'] = self.gui.theme['buttonForegroundColour']
	end
	if (colours['backgroundColour'] == nil) then
		colours['backgroundColour'] = self.gui.theme['buttonBackgroundColour']
	end
	self.gui:setColours(colours['foregroundColour'], colours['backgroundColour'])
	self.gui:fill(pos['x'], pos['y'], size['x'], size['y'], " ")
	local textPos = self.gui:calculateTitlePos(#tostring(self:getText()), pos['x'], pos['y'], size['x'], size['y'])
	--print("Drawing label "..size['x'].."x"..size['y'].."@"..pos['x'].."x"..pos['y'])
	self.gui:printAt(self:getText(), textPos['x'], textPos['y'])
	self.gui:setColours()
end