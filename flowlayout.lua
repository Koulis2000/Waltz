--Meta class
FlowLayout = {}
FlowLayout.__index = FlowLayout

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function FlowLayout.create(window, theme, headerText)
	local size = window.size
	local cursorX, cursorY = window:getCursor()
	local self = setmetatable({}, FlowLayout)
	self.theme = theme
	self.window = window
	self.headerText = headerText
	self.size = { x = size['x'], y = size['y'] }
	self.cpx = cursorX
	self.cpy = cursorY
	self.components = {}
	self.exit = false
	self:setColours()
	return self
end