
-- check components

local function getCompoAddr(name)
    return component.list(name)() or error("Missing Component: " .. name)
end

-- setup proxies for components

local eepromProxy, internetProxy, gpuProxy =
    component.proxy(getCompoAddr("eeprom")),
    component.proxy(getCompoAddr("internet")),
    component.proxy(getCompoAddr("gpu"))

-- bind GPU to screen in case it isn't done

gpuProxy.bind(getCompoAddr("screen"))

local screenWidth, screenHeight = gpu.getResolution()