--Meta class
AdvancedPanel = {}
AdvancedPanel.__index = AdvancedPanel

function AdvancedPanel.create(gui, title, titleColor, alignment, x, y, width, height, borderStyle)
	local self = setmetatable({}, AdvancedPanel)
	self.gui = gui
	self.pos = { x = x, y = y }
	self.size = { x = width, y = height }
	self.title = title
	self.titleColor = titleColor
	self.alignment = alignment
	self.components = {}
	self.type = "advancedpanel"
	self.borderStyle = borderStyle or {}
	return self
end

function AdvancedPanel:addComponent(c)
	local cNum = 1
	if (self.components ~= nil) then
		cNum = #self.components + 1
	end
	self.components[cNum] = c
	local pos = c.pos
	c.pos = { x = pos['x'] + self.pos['x'], y = pos['y'] + self.pos['y'] }
end

function AdvancedPanel:getComponents()
	return self.components
end

function AdvancedPanel:getTitle()
	return self.title
end

function AdvancedPanel:setTitle(title)
	self.title = tostring(title)
end

function AdvancedPanel:getText()
	return self.title
end

function AdvancedPanel:setText(text)
	self:setTitle(text)
end

function AdvancedPanel:draw()
	self:drawBorder(self.borderStyle) 
	self:drawTitle(self.title, self.titleColor, self.alignment)
	for i = 1, #self.components, 1 do
		comp = self.components[i]
		comp:draw(self.gui)
	end
end

function AdvancedPanel:drawBorder(borderStyle)
	
    local borders = borderStyle.borders or ""
    local corners = borderStyle.corners or ""
    local borderChars = borderStyle.borderChars or (mode == "OC" and { t = "─", b = "─", l = "│", r = "│" } or (mode == "CC" and { t = "¯", b = "_", l = "|", r = "|" }))
    local cornerChars = borderStyle.cornerChars or (mode == "OC" and { tl = "┌", tr = "┐", bl = "└", br = "┘" } or (mode == "CC" and { tl = "/", tr = "\\", bl = "\\", br = "/" }))
    local borderColors = borderStyle.borderColors or {}
    local cornerColors = borderStyle.cornerColors or {}

	local function hasCharacter(str, char)
		return str:find(char, 1, true) ~= nil
	end

	if borders == "" and corners == "" then
		return -- No borders or corners specified, no need to draw anything
	end

	local left = hasCharacter(borders, "l")
	local right = hasCharacter(borders, "r")
	local top = hasCharacter(borders, "t")
	local bottom = hasCharacter(borders, "b")

	local tlCorner = hasCharacter(corners, "tl")
	local trCorner = hasCharacter(corners, "tr")
	local blCorner = hasCharacter(corners, "bl")
	local brCorner = hasCharacter(corners, "br")

	local colorRevert = self.gui.window.getTextColor()

	if top then
		self.gui.window.setTextColor(borderColors["t"])
		self.gui:fill(self.pos['x'] + 1, self.pos['y'], self.size['x'] - 2, 1, borderChars["t"])
	end

	if bottom then
		self.gui.window.setTextColor(borderColors["b"])
		self.gui:fill(self.pos['x'] + 1, self.pos['y'] + self.size['y'] - 1, self.size['x'] - 2, 1, borderChars["b"])
	end

	if left then
		self.gui.window.setTextColor(borderColors["l"])
		self.gui:fill(self.pos['x'], self.pos['y'] + 1, 1, self.size['y'] - 2, borderChars["l"])
	end

	if right then
		self.gui.window.setTextColor(borderColors["r"])
		self.gui:fill(self.pos['x'] + self.size['x'] - 1, self.pos['y'] + 1, 1, self.size['y'] - 2, borderChars["r"])
	end

	if tlCorner then
		self.gui.window.setTextColor(cornerColors["tl"])
		self.gui:printAt(cornerChars["tl"], self.pos['x'], self.pos['y'])
	end

	if trCorner then
		self.gui.window.setTextColor(cornerColors["tr"])
		self.gui:printAt(cornerChars["tr"], self.pos['x'] + self.size['x'] - 1, self.pos['y'])
	end

	if blCorner then
		self.gui.window.setTextColor(cornerColors["bl"])
		self.gui:printAt(cornerChars["bl"], self.pos['x'], self.pos['y'] + self.size['y'] - 1)
	end

	if brCorner then
		self.gui.window.setTextColor(cornerColors["br"])
		self.gui:printAt(cornerChars["br"], self.pos['x'] + self.size['x'] - 1, self.pos['y'] + self.size['y'] - 1)
	end

	self.gui.window.setTextColor(colorRevert)
end

function AdvancedPanel:drawTitle(title, titleColor, alignment)
	if title ~= nil then
		local colorRevert = self.gui.window.getTextColor()
		local titleLength = #self.title
		local titleX
		if alignment == "center" then
			titleX = self.pos['x'] + math.floor((self.size['x'] - #titleString) / 2)
		elseif alignment == "right" then
			titleX = self.pos['x'] + self.size['x'] - #titleString + 1
		else
			titleX = self.pos['x']
		end
		self.gui.window.setTextColor(titleColor)
		self.gui:printAt(title, titleX, self.pos['y'])
		self.gui.window.setTextColor(colorRevert)
	end
end


function AdvancedPanel:getPos()
	return self.pos
end

function AdvancedPanel:setPos(x, y)
	self.pos['x'] = tonumber(x)
	self.pos['y'] = tonumber(y)
end

function AdvancedPanel:getSize()
	return self.size
end

function AdvancedPanel:setSize(x, y)
	self.size['x'] = tonumber(x)
	self.size['y'] = tonumber(y)
end