local waltz = require("waltz")

print(mode)

local inspect = require("inspect")

if (mode == "OC") then
	local term = require("term")
	local colours = require("colors")
	local window = require("window")
	local thread = require("thread")
	local event = require("event")
	local component = require("component")
	if (term.isAvailable() == true) then
		monitor = term
	else 
		exit(0)
	end
end
local mainMonitor = peripheral.find("monitor")
mainMonitor.setTextScale(1)
term.redirect(mainMonitor)
if (mode == "CC") then
	monitor = term
	thread = parallel
end

monitor.clear()
if (mode == "CC") then
	monitor.setCursorPos(1, 1)
end
if (mode == "OC") then
	monitor.setCursor(1, 1)
end

theme = {
	titleForegroundColour = 0x200,
	titleBackgroundColour = 0x80,
	textForegroundColour = 0x1,
	textBackgroundColour = 0x8000,
	successForegroundColour = 0x20,
	successBackgroundColour = 0x8000,
	failureForegroundColour = 0x4000,
	failureBackgroundColour = 0x8000,
	buttonForegroundColour = 0x800,
	buttonBackgroundColour = 0x8000,
	textScale = 0.5
}
print("Creating window...")
local x, y = 1, 1
local sizeX, sizeY
local w = nil
if (mode == "CC") then
	sizeX, sizeY = monitor.getSize()
	w = window.create(monitor.current(), x, y, sizeX, sizeY)
else
	sizeX, sizeY = monitor.gpu().getResolution()
	w = Window.create(x, y, sizeX, sizeY)
end


if (w == nil) then
	error("Could not initialise window!")
end

print("Created window: @ " .. x .. "&" .. y .. "/" .. sizeX .. "x" .. sizeY)
sleep(2.5)
--local w2 = Window:create(x, 11, 80, 10)

--print("Creating GUI...")
local g = Waltz.create(w, theme, "Waltz Demo")
local btnClose = Button.create(g, "ˣ", colours.red, titleBackgroundColour, sizeX, 1, 1, 1)
btnClose:setAction(function() g.exit = true end)
g:addComponent(btnClose)

g:run()