local totalCode, errorMessage = ""
local installLink = "https://raw.githubusercontent.com/Auxirius/GleebOS/master/Installer/Installer.lua"
local component = require("component")

print("Download: INSTALLER...")
for chunk in component.proxy(component.list("internet")() or error("You need an internet component to install GleebOS")).request(installLink) do
    totalCode = totalCode..chunk
end
print("Downloaded: INSTALLER")

totalCode, errorMessage = load(totalCode, "=installer")

if totalCode then
    totalCode, errorMessage = xpcall(totalCode, debug.traceback)

    if not totalCode then
        error(errorMessage)
    end
else
    error(errorMessage)
end




