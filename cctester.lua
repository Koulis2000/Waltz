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
--local g2 = Gui.create(w2, theme, "Second window")
--print("Created GUI.")

--g:fill(10, 10, 5, 5, "#")
--sleep(4)

close = Button.create(g, "X", colours.red, buttonBackgroundColour, sizeX, 1, 1, 1)
close.action = function() g.exit = true end

b1 = Button.create(g, "Button", colours.white, colours.green, 2, 3, 19, 3)
b1.action = function(comp) comp:setText("You clicked me @ " .. os.time() .. "!") end
pb = ProgressBar.create(g, colours.lime, colours.green, 2, 8, 19, 1, 0, 100, 55)
pbl = Label.create(g, " Progbar:", colours.grey, colours.white, 2, 7, 19, 1)
vpb = VerticalProgressBar.create(g, colours.cyan, colours.grey, 22, 3, 3, 8, 0, 100, 55)
vpbl = Label.create(g, "Vertical Progbar ->", colours.cyan, colours.grey, 2, 10, 19, 1)
p1 = Panel.create(g, "Panel", 26, 3, 25, 17, true)
l1 = Label.create(g, "Label", colours.white, colours.blue, 3, 2, 19, 1)
p2 = Panel.create(g, "Borderless  Panel", 1, 12, 25, 8, false)
l2 = Label.create(g, "Labels", colours.white, colours.blue, 1, 2, 23, 1)
l3 = Label.create(g, "in the", colours.cyan, colours.yellow, 1, 4, 23, 1)
l4 = Label.create(g, "panel!", colours.orange, colours.cyan, 1, 6, 23, 1)

l5 = Label.create(g, "!Attention!", colours.white, colours.red, 3, 4, 19, 1)
l6 = Label.create(g, "Crash testing", colours.white, colours.red, 3, 5, 19, 1)
l7 = Label.create(g, " Do not stop!", colours.white, colours.red, 3, 6, 19, 1)
l8 = Label.create(g, "(You may click", colours.red, colours.white, 3, 7, 19, 1)
l9 = Label.create(g, "the Green Button)", colours.red, colours.white, 3, 8, 19, 1)
l10 = Label.create(g, "Ran for: ", colours.blue, colours.black, 3, 10, 19, 1)
l11 = Label.create(g, "", colours.blue, colours.black, 3, 11, 19, 1)


function gTasks()
	if (pb:getProgress() >= 100) then 
		pb:setProgress(0)
		if (vpb:getProgress() >= 100) then 
			vpb:setProgress(0)
		else 
			vpb:setProgress(vpb:getProgress() + 10)
		end 
	else 
		if (pb:getProgress() > 10 and pb:getProgress() < 40) then
			if (vpb:getProgress() >= 100) then 
				vpb:setProgress(0)
			else 
				vpb:setProgress((vpb:getProgress() + 3) * 1.02)
			end 
		end
		if (pb:getProgress() > 60 and pb:getProgress() < 80) then
			vpb:setProgress(vpb:getProgress() * 0.9)
		end
		pb:setProgress(pb:getProgress() + 10)
	end 
	l11:setText(os.clock() .. " sec")
end

p1:addComponent(l1)
p1:addComponent(l5)
p1:addComponent(l6)
p1:addComponent(l7)
p1:addComponent(l8)
p1:addComponent(l9)
p1:addComponent(l10)
p1:addComponent(l11)

p2:addComponent(l2)
p2:addComponent(l3)
p2:addComponent(l4)


g:addComponent(close)
g:addComponent(pbl)
g:addComponent(b1)
g:addComponent(pb)
g:addComponent(vpb)
g:addComponent(vpbl)
g:addComponent(p1)
g:addComponent(p2)
if (mode == "CC") then
	local function guiTick()
		g:run(gTasks)
	end
	thread.waitForAny(guiTick())
end

if (mode == "OC") then
	local t1 = thread.create(g:run(function() b2.text = os.date("%H:%M:%S"); b2.size = { x = nil, y = 3 } end))
	thread.waitForAny({t1})
end

