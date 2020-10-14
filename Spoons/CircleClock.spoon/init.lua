--- === CircleClock ===
---
--- A circleclock inset into the desktop
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/CircleClock.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/CircleClock.spoon.zip)

local obj={}
obj.__index = obj

-- Metadata
obj.name = "CircleClock"
obj.version = "1.0"
obj.author = "ashfinal <ashfinal@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- Internal function used to find our location, so we know where to load files from
local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end

obj.spoonPath = script_path()

local function updateClock()
    local secnum = math.tointeger(os.date("%S"))
    local minnum = math.tointeger(os.date("%M"))
    local hournum = math.tointeger(os.date("%I"))
    local secangle = 6*secnum
    local minangle = 6*minnum+6/60*secnum
    local hourangle = 30*hournum+30/60*minnum+30/60/60*secnum

    obj.canvas[4].endAngle = secangle
    obj.canvas[8].endAngle = minangle
    -- hourangle may be larger than 360 at 12pm-1pm
    if hourangle >= 360 then
        hourangle = hourangle-360
    end
    obj.canvas[6].endAngle = hourangle
end

function obj:init()
    local cscreen = hs.screen.mainScreen()
    local cres = cscreen:fullFrame()
    self.canvas = hs.canvas.new({
        x = cres.w-128-20,
        y = cres.h-128-20,
        w = 128,
        h = 128
    }):show()
    obj.canvas:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
    obj.canvas:level(hs.canvas.windowLevels.floating)
    obj.canvas[1] = {
        id = "watch_wall",
        type = "circle",
        fillColor = {hex="#000000", alpha=0.125},
        strokeColor = {hex="#9E9E9E", alpha=0.0},
        radius = "49.9%",
    }
    obj.canvas[2] = {
        id = "watch_image",
        type = "image",
        image = hs.image.imageFromPath(self.spoonPath .. "/watchbg_alt_new.png"),
        opacity = 0.4,
    }
    obj.canvas[3] = {
        id = "watch_circle",
        type = "circle",
        radius = "45%",
        action = "stroke",
        strokeColor = {hex="#9E9E9E", alpha=0.25},
    }
    obj.canvas[4] = {
        id = "watch_sechand",
        type = "arc",
        radius = "46%",
        fillColor = {hex="#9E9E9E", alpha=0.14},
        strokeColor = {hex="#9E9E9E", alpha=0.0},
        endAngle = 0,
    }
    obj.canvas[5] = {
        id = "watch_hourcircle",
        type = "circle",
        action = "stroke",
        radius = "24%",
        strokeWidth = 8,
        strokeColor = {hex="#FFFFFF", alpha=0.1},
    }
    obj.canvas[6] = {
        id = "watch_hourarc",
        type = "arc",
        action = "stroke",
        radius = "24%",
        arcRadii = false,
        strokeWidth = 8,
        strokeColor = {hex="#8f27ec", alpha=0.75},
        endAngle = 0,
    }
    obj.canvas[7] = {
        id = "watch_mincircle",
        type = "circle",
        action = "stroke",
        radius = "30%",
        strokeWidth = 6,
        strokeColor = {hex="#FFFFFF", alpha=0.1},
    }
    obj.canvas[8] = {
        id = "watch_minarc",
        type = "arc",
        action = "stroke",
        radius = "30%",
        arcRadii = false,
        strokeWidth = 6,
        strokeColor = {hex="#56daec", alpha=0.75},
        endAngle = 0,
    }
    if obj.timer == nil then
        obj.timer = hs.timer.doEvery(1, function() updateClock() end)
    else
        obj.timer:start()
    end
end

return obj
