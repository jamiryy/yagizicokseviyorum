
if not game:IsLoaded() then
    game.Loaded:Wait()
end;

local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
if not localPlayer then
    players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    localPlayer = players.LocalPlayer
end;

local request = request or http_request or syn and syn.request or fluxus and fluxus.request
local loadstring = loadstring or function(body) return assert(load(body)) end

local function protectedLoad(url)
    local success, response = pcall(request, {Url = url, Method = "GET"})
    if not success or type(response) ~= "table" or type(response.Body) ~= "string" or response.StatusCode ~= 200 then
        warn("[amongus.hook] failed to load: " .. url)
        return
    end
    local loader = loadstring(response.Body)
    if not loader then
        warn("[amongus.hook] syntax error in loaded content: " .. url)
        return
    end
    return loader()
end

if not Drawing then
    protectedLoad("https://raw.githubusercontent.com/mainstreamed/amongus-hook/refs/heads/main/drawingfix.lua")
end

local placeid = game.PlaceId
local dir = "https://raw.githubusercontent.com/mainstreamed/amongus-hook/main/"

local statuslist = {}
statuslist.fallensurvival = {
    name = "Fallen Survival",
    status = "Undetected"
}
statuslist.tridentsurvival = {
    name = "Trident Survival",
    status = "Undetected"
}

local function load(name)
    local game = statuslist[name]
    return protectedLoad(dir .. name .. "/main.lua")
end

if placeid == 13253735473 then
    return load("tridentsurvival")
elseif placeid == 13800717766 or placeid == 15479377118 or placeid == 16849012343 then
    return load("fallensurvival")
end

warn("[amongus.hook] This game is unsupported. PlaceId: " .. placeid)
