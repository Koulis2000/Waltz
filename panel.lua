--Meta class
Panel = {}
Panel.__index = Panel

function Panel.create(gui, title, x, y, width, height, border)
	local self = setmetatable({}, Panel)
	self.gui = gui
	self.pos = { x = x, y = y}
	self.size = { x = width, y = height}
	self.border = border or false
	self.title = title
	self.components = {}
	self.type = "panel"
	return self
end

function Panel:addComponent(c)
	local cNum = 1
	if (self.components ~= nil) then
		cNum = #self.components + 1
	end
	self.components[cNum] = c
	local pos = c.pos
	c.pos = { x = pos['x'] + self.pos['x'], y = pos['y'] + self.pos['y'] }
end

function Panel:getComponents()
	return self.components
end

function Panel:getTitle()
	return self.title
end

function Panel:setTitle(title)
	self.title = tostring(title)
end

function Panel:getText()
	return self.title
end

function Panel:setText(text)
	self:setTitle(text)
end

function Panel:draw()
	self:drawBorder() 
	self:drawTitle()
	for i = 1, #self.components, 1 do
		comp = self.components[i]
		comp:draw(self.gui)
	end
end

function Panel:drawBorder()
	if (self.border == true) then 
		if (mode == "OC") then
			self.gui:printAt("┌", self.pos['x'], self.pos['y'])
			self.gui:printAt("┐", self.pos['x'] + self.size['x'] - 1, self.pos['y'])
			self.gui:printAt("└", self.pos['x'], (self.pos['y'] - 1) + (self.size['y']))
			self.gui:printAt("┘", self.pos['x'] + self.size['x'] - 1, self.pos['y'] + self.size['y'] - 1)
			self.gui:fill(self.pos['x'] + 1, self.pos['y'], self.size['x'] - 2, 1, "─")
			self.gui:fill(self.pos['x'] + 1, self.pos['y'] + self.size['y'] - 1, self.size['x'] - 2, 1, "─")
			self.gui:fill(self.pos['x'], self.pos['y'] + 1, 1, self.size['y'] - 2, "│")
			self.gui:fill(self.pos['x'] + self.size['x'] -1, self.pos['y'] + 1, 1, self.size['y'] - 2, "│")
		end
		if (mode == "CC") then
			self.gui:printAt("/", self.pos['x'], self.pos['y'])
			self.gui:printAt("\\", self.pos['x'] + self.size['x'] - 1, self.pos['y'])
			self.gui:printAt("\\", self.pos['x'], (self.pos['y'] - 1) + (self.size['y']))
			self.gui:printAt("/", self.pos['x'] + self.size['x'] - 1, self.pos['y'] + self.size['y'] - 1)
			self.gui:fill(self.pos['x'] + 1, self.pos['y'], self.size['x'] - 2, 1, "¯")
			self.gui:fill(self.pos['x'] + 1, self.pos['y'] + self.size['y'] - 1, self.size['x'] - 2, 1, "_")
			self.gui:fill(self.pos['x'], self.pos['y'] + 1, 1, self.size['y'] - 2, "|")
			self.gui:fill(self.pos['x'] + self.size['x'] -1, self.pos['y'] + 1, 1, self.size['y'] - 2, "|")
		end
	end
end

function Panel:drawTitle()
	if (self.title ~= nil) then
		local tPos = self.gui:calculateTitlePos(#self.title + 4, self.pos['x'], self.pos['y'], self.size['x'], 1)
		if (mode == "CC") then
			if (self.border == true) then
				self.gui:printAt("T " .. self.title .. " T", tPos['x'], tPos['y'])
			else 
				self.gui:printAt("- " .. self.title .. " -", tPos['x'], tPos['y'])
			end
		end

		if (mode == "OC") then
			if (self.border == true) then
				self.gui:printAt("┤ " .. self.title .. " ├", tPos['x'], tPos['y'])
			else 
				self.gui:printAt("- " .. self.title .. " -", tPos['x'], tPos['y'])
			end
		end
	end
end

function Panel:getPos()
	return self.pos
end

function Panel:setPos(x, y)
	self.pos['x'] = tonumber(x)
	self.pos['y'] = tonumber(y)
end

function Panel:getSize()
	return self.size
end

function Panel:setSize(x, y)
	self.size['x'] = tonumber(x)
	self.size['y'] = tonumber(y)
end