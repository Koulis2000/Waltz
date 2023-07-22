--Meta class
AdvancedPanel = {}
AdvancedPanel.__index = AdvancedPanel

function AdvancedPanel.create(gui, title, alignment, x, y, width, height, borders, corners, borderChars, cornerChars)
	local self = setmetatable({}, AdvancedPanel)
	self.gui = gui
	self.pos = { x = x, y = y }
	self.size = { x = width, y = height }
	self.borders = borders or ""
	self.corners = corners or ""
	self.borderChars = borderChars or {}
	self.cornerChars = cornerChars or {}
	self.title = title
	self.alignment = alignment
	self.components = {}
	self.type = "advancedpanel"
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
	self:drawBorder() 
	self:drawTitle("left")
	for i = 1, #self.components, 1 do
		comp = self.components[i]
		comp:draw(self.gui)
	end
end

function AdvancedPanel:drawBorder()
	local function hasCharacter(str, char)
		return str:find(char, 1, true) ~= nil
	end

	local function drawBorderChar(x, y, char)
		self.gui:printAt(char, x, y)
	end

	if self.borders == "" and self.corners == "" then
		return -- No borders or corners specified, no need to draw anything
	end

	local left = hasCharacter(self.borders, "l")
	local right = hasCharacter(self.borders, "r")
	local top = hasCharacter(self.borders, "t")
	local bottom = hasCharacter(self.borders, "b")

	local tlCorner = hasCharacter(self.corners, "tl")
	local trCorner = hasCharacter(self.corners, "tr")
	local blCorner = hasCharacter(self.corners, "bl")
	local brCorner = hasCharacter(self.corners, "br")

	if top then
		for x = self.pos['x'] + 1, self.pos['x'] + self.size['x'] - 2 do
			drawBorderChar(x, self.pos['y'], self.borderChars["t"] or "-")
		end
	end

	if bottom then
		for x = self.pos['x'] + 1, self.pos['x'] + self.size['x'] - 2 do
			drawBorderChar(x, self.pos['y'] + self.size['y'] - 1, self.borderChars["b"] or "-")
		end
	end

	if left then
		for y = self.pos['y'] + 1, self.pos['y'] + self.size['y'] - 2 do
			drawBorderChar(self.pos['x'], y, self.borderChars["l"] or "|")
		end
	end

	if right then
		for y = self.pos['y'] + 1, self.pos['y'] + self.size['y'] - 2 do
			drawBorderChar(self.pos['x'] + self.size['x'] - 1, y, self.borderChars["r"] or "|")
		end
	end

	if tlCorner then
		drawBorderChar(self.pos['x'], self.pos['y'], self.cornerChars["tl"] or "/")
	end

	if trCorner then
		drawBorderChar(self.pos['x'] + self.size['x'] - 1, self.pos['y'], self.cornerChars["tr"] or "\\")
	end

	if blCorner then
		drawBorderChar(self.pos['x'], self.pos['y'] + self.size['y'] - 1, self.cornerChars["bl"] or "\\")
	end

	if brCorner then
		drawBorderChar(self.pos['x'] + self.size['x'] - 1, self.pos['y'] + self.size['y'] - 1, self.cornerChars["br"] or "/")
	end
end

function AdvancedPanel:drawTitle(alignment)
	if self.title ~= nil then
		local titleLength = #self.title
		local titleX

		if alignment == "center" then
			titleX = self.pos['x'] + math.floor((self.size['x'] - #titleString) / 2)
		elseif alignment == "right" then
			titleX = self.pos['x'] + self.size['x'] - #titleString + 1
		else
			titleX = self.pos['x']
		end
		self.gui:printAt(title, titleX, self.pos['y'])
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