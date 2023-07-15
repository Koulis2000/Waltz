
local label = require("label")

--Meta class
Icon = {}
Icon.__index = Icon

function Icon.create(gui, style, foregroundColour, backgroundColour, x, y)
	local self = setmetatable({}, Icon)
	self.gui = gui
	self.foregroundColour = foregroundColour
	self.backgroundColour = backgroundColour
	self.pos = { x = x, y = y }
	self.style = style
	self.labels = {}
	self.type = "icon"
	return self
end

function Icon:getColours()
	local colours = {foregroundColour = self.foregroundColour, backgroundColour = self.backgroundColour}
	return colours
end

function Icon:setColours(foregroundColour, backgroundColour)
	self.foregroundColour = foregroundColour
	self.backgroundColour = backgroundColour
end

function Icon:getSize()
	if (self.size == nil) then
		self.size = { x = 1, y = #self.style }
		for _, l in pairs(self.style) do
			if (#l > self.size['x']) then self.size['x'] = #l end
		end
	end
	return self.size
end

function Icon:setStyle(style)
	self.size = nil
	self.labels = {}
	self.style = style
end

function Icon:draw()
	local i = 0 --yes, zero.
	for _, l in pairs(self.style) do
		local labelText = table.concat(l, "")
		if (self.labels[i + 1] == nil) then
			local c = self:getColours()
			self.labels[i + 1] = Label.create(self.gui, labelText, c['foregroundColour'], c['backgroundColour'], self.pos['x'], self.pos['y'] + i, #labelText, 1)
		end
		self.labels[i + 1]:draw()
		i = i + 1
	end
end