local totalCode, errorMessage = ""
local installLink = "https://raw.githubusercontent.com/Auxirius/GleebOS/master/Installer/Installer.lua"

local handle, chunk = component.proxy(component.list("internet")() or error("Internet component required")).request(installLink)

while true do 
    chunk = handle.read(math.huge)

    if chunk then
        totalCode = totalCode .. chunk
    else
        break
    end
end

totalCode, errorMessage = load(totalCode, "=installer")

if totalCode then
    totalCode, errorMessage = xpcall(totalCode, debug.traceback)

    if not totalCode then
        error(errorMessage)
    end
else
    error(errorMessage)
end

