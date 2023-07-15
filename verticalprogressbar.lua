VerticalProgressBar = {}
VerticalProgressBar.__index = VerticalProgressBar

function VerticalProgressBar.create(gui, foregroundColour, backgroundColour, x, y, width, height, min, max, progress)
	local self = setmetatable({}, VerticalProgressBar)
	self.gui = gui
	self.foregroundColour = foregroundColour
	self.backgroundColour = backgroundColour
	self.pos = { x = x, y = y }
	self.size = { x = width, y = height }
	self.type = "progressbar"
	self.min = min or 0
	self.max = max or 100
	self.progress = progress or min
	return self
end

function VerticalProgressBar:setProgress(p)
	if (p > 100) then
		self.progress = 100
	elseif (p < 0) then
		self.progress = 0
	else
		self.progress = p
	end
end

function VerticalProgressBar:getProgress()
	return self.progress
end

function VerticalProgressBar:getColours()
	local colours = {foregroundColour = self.foregroundColour, backgroundColour = self.backgroundColour}
	return colours
end

function VerticalProgressBar:setColours(foregroundColour, backgroundColour)
	self.foregroundColour = foregroundColour
	self.backgroundColour = backgroundColour
end

function VerticalProgressBar:getSize()
	return self.size
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function VerticalProgressBar:calculateFillLevel()
	return round(self.size['y'] - ((self.size['y'] / 100) * self.progress))
end

function VerticalProgressBar:draw(gui) 
	local colours = self:getColours()
	local pos = self.pos
	local size = self.size
	if (colours['foregroundColour'] == nil) then
		colours['foregroundColour'] = gui.theme['textForegroundColour']
	end
	if (colours['backgroundColour'] == nil) then
		colours['backgroundColour'] = gui.theme['textBackgroundColour']
	end
	gui:setColours(colours['foregroundColour'], colours['foregroundColour']) -- yes, foregroundColour in both places.
	--for i = 1, size['y'] do
	--	gui:printLine(" ", size['x'], pos['y'] + (i - 1), pos['x'])
	--end
	if (mode == "CC") then
		gui:fill(pos['x'], pos['y'], size['x'], size['y'], " ")
	end
	if (mode == "OC") then
		gui.window:fill(pos['x'], pos['y'], size['x'], size['y'], " ")
	end
	gui:setColours(colours['foregroundColour'], colours['backgroundColour'])
	if (mode == "CC") then
		gui:fill(pos['x'], pos['y'], size['x'], self:calculateFillLevel(), " ")
	end
	if (mode == "OC") then
		gui.window:fill(pos['x'], pos['y'] + size['y'], size['x'], self:calculateFillLevel(), " ")
	end
	gui:setColours()
end