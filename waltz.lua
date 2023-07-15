mode = nil

if (os.version ~= nil) then -- check if ComputerCraft...
	print("We are running on ComputerCraft.")
	-- it's ComputerCraft...
	installPath = "/lib/waltz/"
	mode = "CC"
else
	print("We are running on OpenComputers")
	-- it's OpenComputers...
	installPath = "/bin/waltz/"
	mode = "OC"
end

if (mode == nil) then
	error("Could not detect whether we are running on ComputerCraft or OpenComputers!")
end

if (mode == "OC") then
	local thread = require('thread')
	local event = require('event')
	local computer = require('computer')
end

local button = require('button')
local label = require('label')
local progressbar = require('progressbar')
local verticalprogressbar = require('verticalprogressbar')
local panel = require('panel')
local icon = require('icon')
local inspect = require('inspect')
if (libPath == nil) then
	libPath = ""
end

--firstDraw = true
firstDraw = false
local previousBlankTime = 0
local redraw = true
local freeMemLabel

--Meta class
--Gui = {window, theme, headerText, size['x'], size['y'], cpx, cpy, components = {}}
Waltz = {}
Waltz.__index = Waltz

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function Waltz.create(window, theme, headerText, updateInterval)
	local sizeX, sizeY
	if (mode == "CC") then
		sizeX, sizeY = window.getSize()
	end
	if (mode == "OC") then
		sizeX = window.size[1]
		sizeY = window.size[2]
	end
	--print(size['x'] .. " " .. size['y'])
	--os.sleep(1)
	local cursorX, cursorY 
	if (mode == "CC") then
		cursorX, cursorY = window.getCursorPos()
	end
	if (mode == "OC") then
		cursorX, cursorY = window:getCursor()
	end
	local self = setmetatable({}, Waltz)
	self.theme = theme
	self.window = window
	self.headerText = headerText
	self.size = { x = sizeX, y = sizeY }
	self.cpx = cursorX
	self.cpy = cursorY
	self.components = {}
	self.exit = false
	self.updateInterval = updateInterval or 5
	self:setColours()
	return self
end

function Waltz:setColours(foregroundColour, backgroundColour)
	foregroundColour = foregroundColour or self.theme['textForegroundColour']
	--backgroundColour = backgroundColour or self.theme['textBackgroundColour']
	if (backgroundColour == nil) then
		backgroundColour = self.theme['textBackgroundColour']
	end

	if (mode == "OC") then
		self.window:setForeground(foregroundColour)
		self.window:setBackground(backgroundColour)
	end
	if (mode == "CC") then
		self.window.setTextColour(foregroundColour)
		self.window.setBackgroundColour(backgroundColour)
	end
end

function Waltz:printLine(character, number, posY, posX) -- note that posY is _FIRST_
	-- print("char: " .. tostring(character))
	-- optional arguments
	--number = number or self.size['x']
	--posY = posY or self.cpy
	--posX = posX or self.cpx
	if (number == nil) then
		number = self.size['x']
	end
	if (posY == nil) then
		--print("posY: " .. tostring(posY) .. " cpy: " .. tostring(self.cpy))
		--os.sleep(3)
		posY = self.cpy
	end
	if(posX == nil) then
		--print("posX: " .. tostring(posX) .. " cpx: " .. tostring(self.cpx))
		--os.sleep(3)
		posX = self.cpx
	end
	
	-- make sure everything is properly typed...
	character = tostring(character)
	number = tonumber(number)
	posX = tonumber(posX)
	posY = tonumber(posY)

	for i = 1, number do
		self.window:setCursor(posX + (i - 1), posY) -- i - 1 because otherwise we will start at position 2, not 1
		self.window:write(character)
	end
end

function Waltz:drawHeader()
	self:setColours(self.theme['titleForegroundColour'], self.theme['titleBackgroundColour'])
	if (mode == "OC") then
		self.window:fill(1, 1, self.size['x'], 1, " ")
	end
	if (mode == "CC") then
		local string = ""
		for char = 1, self.size['x'], 1 do
			string = string .. " "
		end
		self:printAt(string, 1, 1)
	end
	local text = "   " .. self.headerText .. "   "
	local pos = self:calculateTitlePos(#text, 1, 1, self.size['x'], 1)
	self:printAt(text, pos['x'], 1)
	self:setColours()
end

--deprecated
function Waltz:printCentered(text, posY)
	if (posY == nil) then
		posY = self.cpy
	end
	if (mode == "CC") then
		self.window.setCursorPos((self.size['x'] - #text) / 2, posY)
		self.window.write(text)
	end
	if (mode == "OC") then
		self.window:setCursor((self.size['x'] - #text) / 2, posY)
		self.window:write(text)
	end
end

function Waltz:printAt(text, posX, posY)
	local failed, err = pcall(print(posX .. " X " .. posY))
	if failed then
		print("Error printing \""..text.."\":"..err)
	end
	--os.sleep(1)
	if (mode == "CC") then
		self.window.setCursorPos(posX, posY)
		self.window.write(text)
		self.window.setCursorPos(1, 1)
	end
	if (mode == "OC") then
		self.window:setCursor(posX, posY)
		self.window:write(text)
		self.window:setCursor(1, 1)
	end
end

function Waltz:addComponent(c)
	local cNum = 1
	if (self.components ~= nil) then
		cNum = #self.components + 1
	end
	self.components[cNum] = c
	local pos = c.pos
	c.pos = { x = pos['x'], y = pos['y'] }
end

function Waltz:getComponentAt(x, y, container)
	container = container or self
	local comps = container.components
	for i = 1, #comps, 1 do
		local comp = comps[i]
		if (comp == nil) then
			print("Comp is nil!")
			os.sleep(3)
		end
		local compSize = comp:getSize()
		local minCoords = comp.pos
		if (compSize == nil or minCoords == nil or compSize['x'] == nil or compSize['y'] == nil or minCoords['x'] == nil or minCoords['y'] == nil) then
			print("Nil value on comp " .. comp.type .. " size or coords!")
			os.sleep(3)
		end
		--print("minCoords['x'] of type " .. comp.type .. ": " .. minCoords['x'])
		--print("size['x'] of type " .. comp.type .. ": " .. compSize['x'])
		local maxCoords = { 
			x = minCoords['x'] + compSize['x'],
			y = minCoords['y'] + compSize['y']
		}
		if (x >= minCoords['x'] and x <= maxCoords['x'] and y >= minCoords['y'] and y <= maxCoords['y']) then
			if (comp.components ~= nil) then
				return self:getComponentAt(x, y, comp)
			else 
				return comp
			end
		end
	end
end

function Waltz:blank() 
	self:setColours()
	self.window:clear(true)
end

function Waltz:draw()
	if (self.components == nil) then
		print("No components to draw!")
		return
	end
   --print("Comps: " .. #self.components)
	local comp
	if (redraw == true) then
		self:blank()
		self:drawHeader()
		self:drawFreeMem()
		for i = 1, #self.components, 1 do
			comp = self.components[i]
			--print("Drawing #" .. i .. " \"" .. comp:getText() .. "\" of type " .. comp:getType())
			--os.sleep(1)
			comp:draw(self)
		end
		--os.sleep(5)
	end
	redraw = true
	if (firstDraw == true) then
		firstDraw = false
		os.sleep(1)
	end
	if (mode == "CC") then
		os.sleep(0.20)
	end
	--event.push("draw_completed")
end

function Waltz:detectClick()
	--local _, _, _, _, _ = event.pull("draw_completed")
	if (mode == "CC") then
		local event, button, x, y = os.pullEvent("monitor_touch")
		local comp = self:getComponentAt(x, y)
		if (comp == nil) then
			return
		end
		if (comp.action ~= nil) then
			local f = comp.action
			f(comp)
		end
	end
	if (mode == "OC") then
		local a, b, c, d, e = event.pull(self.updateInterval)
		--print(a)
		if (a ~= nil) then
			--redraw = false
		end
		if (a == "touch") then
			local x = c
			local y = d
			--print("click @" .. x .. "x" .. y)
			local comp = self:getComponentAt(x, y)
			if (comp == nil) then
				--print("clicked outside components")
				return
			end
			--print("clicked button" .. comp:getText())
			if (comp.action ~= nil) then
				local f = comp.action
				f(comp)
			else 
				--print("clicked " .. comp:getType())
			end
		end
		if (a == "key_down" or a == "key_up") then
			local key = d
			--print(key)
	   	if (key == 46.0) then
	      	self.exit = true
	      else 
	      	self.exit = false
	    	end
	  	end
	end
end

function Waltz:fill(x, y, sizeX, sizeY, char)
	if (mode == "CC") then
		local fillString = ""
		for c = 1, sizeX, 1 do
			fillString = fillString .. char
		end
		for l = 1, sizeY, 1 do
			self:printAt(fillString, x, (y + l - 1))
		end
	end
	if (mode == "OC") then
		self.window:fill(x, y, sizeX, sizeY, char)
	end
end

function Waltz:run(tasks)
	self:draw()
	while true do 
		if (tasks ~= nil) then
			tasks()
		end
		if (self.exit == true) then
			self:blank()
			if (mode == "OC") then
				self.window.term.clear()
				self.window:setCursor(1, 1)
				os.exit()
			end
			if (mode == "CC") then
				error("Not an error: program closed.")
			end
		end
		if (tasks ~= nil) then
			tasks()
		end
		if (mode == "OC") then
			self:draw()
			self:detectClick()
		end
		if (mode == "CC") then
			parallel.waitForAny(function() self:draw() end, function() self:detectClick() end)
		end
	end
end

function Waltz:drawFreeMem()
	if (mode == "OC") then
		local labelText = round(computer.freeMemory() / 1024, 2) .. "k free"
		if (freeMemLabel == nil) then
			freeMemLabel = Label.create(self, labelText, self.theme['titleForegroundColour'], self.theme['titleBackgroundColour'], 1, 1, nil, 1)
		else
			freeMemLabel:setText(labelText)
		end
		freeMemLabel:draw(self)
	end
	if (mode == "CC") then
		-- CC does not have a concept of memory, so we'll print the time
		local labelText = os.time()
		if (freeMemLabel == nil) then
			freeMemLabel = Label.create(self, labelText, self.theme['titleForegroundColour'], self.theme['titleBackgroundColour'], 1, 1, nil, 1)
		end
		freeMemLabel:setText(labelText)
		freeMemLabel:draw(self)
	end
end

function Waltz:calculateTitlePos(titleLength, posX, posY, sizeX, sizeY) 
	local titleX = (posX + (sizeX / 2)) - (titleLength / 2)
	local titleY = math.floor((posY + sizeY) - (sizeY / 2))
	if (sizeX <= 1) then 
		titleX = posX
	end
	if (sizeY <= 1) then
		titleY = posY
	end
	return { x = titleX, y = titleY }
end

function Waltz:getSize()
	return self.size
end