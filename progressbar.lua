ProgressBar = {}
ProgressBar.__index = ProgressBar

function ProgressBar.create(gui, foregroundColour, backgroundColour, x, y, width, height, min, max, progress)
	local self = setmetatable({}, ProgressBar)
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

function ProgressBar:setProgress(p)
	if (p > 100) then
		self.progress = 100
	elseif (p < 0) then
		self.progress = 0
	else
		self.progress = p
	end
end

function ProgressBar:getProgress()
	return self.progress
end

function ProgressBar:getColours()
	local colours = {foregroundColour = self.foregroundColour, backgroundColour = self.backgroundColour}
	return colours
end

function ProgressBar:setColours(foregroundColour, backgroundColour)
	self.foregroundColour = foregroundColour
	self.backgroundColour = backgroundColour
end

function ProgressBar:getSize()
	return self.size
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function ProgressBar:calculateFillLevel()
	return round((self.size['x'] / 100) * self.progress)
end

function ProgressBar:draw(gui) 
	local colours = self:getColours()
	local pos = self.pos
	local size = self.size
	if (colours['foregroundColour'] == nil) then
		colours['foregroundColour'] = gui.theme['textForegroundColour']
	end
	if (colours['backgroundColour'] == nil) then
		colours['backgroundColour'] = gui.theme['textBackgroundColour']
	end
	gui:setColours(colours['foregroundColour'], colours['backgroundColour'])
	--for i = 1, size['y'] do
	--	gui:printLine(" ", size['x'], pos['y'] + (i - 1), pos['x'])
	--end
	if (mode == "CC") then
		gui:fill(pos['x'], pos['y'], size['x'], size['y'], " ")
	end
	if (mode == "OC") then
		gui.window:fill(pos['x'], pos['y'], size['x'], size['y'], " ")
	end
	gui:setColours(colours['foregroundColour'], colours['foregroundColour']) -- yes, foregroundColour in both places.
	if (mode == "CC") then
		gui:fill(pos['x'], pos['y'], self:calculateFillLevel(), size['y'], " ")
	end
	if (mode == "OC") then
		gui.window:fill(pos['x'], pos['y'], self:calculateFillLevel(), size['y'], " ")
	end
	gui:setColours()
end