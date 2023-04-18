local computer = require("computer")
local component = require("component")

function missingComponent(name)
    return error(string.format("Missing Component for GleebOS: '%s' ", name))
end

function findComponent(name)
    return component[name] or missingComponent(name)
end

local eeprom, gpu = findComponent("eeprom"), findComponent("gpu")
local internet = require("internet") or missingComponent("Internet")

local repoURL = ""
local installURL = repoURL.."/Installer"

gpu.bind(component.list("screen")() or missingComponent("Screen"))

local screenWidth, screenHeight = gpu.getResolution()
local temporaryHDD, selectedHDD

function exit()
    return computer.shutdown(true)
end

function centrize(width)
    return math.floor(screenWidth / 2 - width / 2 )
end

function centrizedText(y, text)
    gpu.fill(1, y, screenWidth, 1, "" )
    gpu.setForeground(0xFFFFFF)
    gpu.set(centrize(#text), y, text)
end

function title()
    local y = math.floor(screenHeight / 2 - 1)
    centrizedText(y, "GleebOS")

    return y + 2
end

function status(text, pauseThread)
    local y = title()
    centrizedText(y, text)

    if pauseThread then
        centrizedText(y + 1, "Click or press any key to continue")
        
        repeat
            pauseThread = computer.pullSignal()
        until pauseThread == "key_down" or pauseThread == "touch"
    end
end

function progress(value)
	local width = 26
	local x, y, part = centrize(width), title(), math.floor(width * value + 0.5)
	
	gpu.setForeground(0xFFFFFF)
	gpu.set(x, y, string.rep("─", part))
	--[[gpu.setForeground(0xC3C3C3)
	gpu.set(x + part, y, string.rep("─", width - part))]]
end

gpu.setBackground(0x000000)
gpu.fill(1, 1, screenWidth, screenHeight, " ")

status("Finding suitable hard disk drive...", false)
for address in component.list("filesystem") do
	local proxy = component.proxy(address)
	if proxy.spaceTotal() >=  then
		temporaryHDD, selectedHDD = proxy, proxy
		break
	end
end

if not temporaryHDD then
	status("No suitable hard disk drive found", true)
	return exit()
end
status("Found suitable hard disk drive found!", true)
