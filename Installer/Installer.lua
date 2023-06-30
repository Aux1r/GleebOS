
-- check components

local function getCompoAddr(name)
    return component.list(name)() or error("Missing Component: " .. name)
end

-- setup proxies for components

local eepromProxy, internetProxy, gpuProxy =
    component.proxy(getCompoAddr("eeprom")),
    component.proxy(getCompoAddr("internet")),
    component.proxy(getCompoAddr("gpu"))

-- GPU, Screen & Installation Directory prep

gpuProxy.bind(getCompoAddr("screen"))
local screenWidth, screenHeight = gpuProxy.getResolution()

local repoURL = "https://raw.githubusercontent.com/Auxirius/GleebOS/master"
local installerURL = "Installer/"

local installerPath = "/GleebOS installer/"
local OSPath = "/"

local temporaryFSProxy, selectedFSProxy

local testVal = 3

-----------------------------

local function centrize(width)
    return math.floor(screenWidth / 2 - width / 2)
end

local function centrizedText(y, color, text)
    gpuProxy.fill(1, y, screenWidth, screenHeight, 1, " ")
    gpuProxy.setForeground(color)
    gpuProxy.set(centrize(#text), y, text)
end

local function title()
    local y = math.floor(screenHeight / 2 - 1)
    centrizedText(y, E124F0, "GleebOS")
    
    return y + 2
end

local function status(text, needWait)
    centrizedText(title(), 0x878787, text)

	if needWait then
		repeat
			needWait = computer.pullSignal()
		until needWait == "key_down" or needWait == "touch"
	end
end

while true do
    title()
end

