local term = require("term")
local colours = require("colors")

firstDrawDelay = 0.01

Window = {}
Window.__index = Window

function Window.create(dx, dy, width, height)
	local self = setmetatable({}, Window)
	self.x = dx
	self.y = dy
	self.size = { x = width, y = height }
	self.term = term
	--self.cursor = term.getCursor()
	return self
end

function Window:setForeground(foregroundColour)
	self.term.gpu().setForeground(foregroundColour)
end

function Window:getForeground()
	return self.term.gpu().getForeground()
end

function Window:setBackground(backgroundColour) 
	self.term.gpu().setBackground(backgroundColour)
end

function Window:getBackground()
	return self.term.gpu().getBackground()
end

function Window:setCursor(x, y)
	--self.term.setCursor(self.x + x, self.y + y)
	self.term.setCursor(x, y)
	rawset(self, "cursor", self.term.getCursor())
end

function Window:getCursor()
	return self.term.getCursor()
end

function Window:write(txt, wrap)
	wrap = wrap or false
	if (firstDraw == true) then
		os.sleep(firstDrawDelay)
	end
	self.term.write(txt, wrap)
end

function Window:fill(x, y, w, h, c)
	if (firstDraw == true) then
		os.sleep(firstDrawDelay)
	end
	return self.term.gpu().fill(x, y, w, h, c)
end

function Window:clear(fastClear)
	self.term.clear()
end

function Window:clearLine()
	self.term.clearLine()
end