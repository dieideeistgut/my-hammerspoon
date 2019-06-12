-- Copyright (c) 2016 Miro Mannino
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this
-- software and associated documentation files (the "Software"), to deal in the Software
-- without restriction, including without limitation the rights to use, copy, modify, merge,
-- publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
-- to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies
-- or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.

hs.window.animationDuration = 0.2

switcher_browsers = hs.window.switcher.new{'Safari','Google Chrome'}

local moveModifiers = {"alt", "ctrl"}
local selectNumberModifiers = {"alt", "ctrl", "cmd"}

local numbers = {}

local fullScreenSizes = {1, 1.5, 2}

local GRID = {w = 12, h = 6}
hs.grid.setGrid(GRID.w .. 'x' .. GRID.h)

hs.grid.HINTS={
    {'f1', 'f2' , 'f3' , 'f4' , 'f5', 'f6', 'f7', 'f8', 'f9', 'f10', 'f11', 'f12'},
    {'1' , 'f11', 'f15', 'f19', 'f3', '=' , ']' , '2' , '3' , '4'  , '5'  , '6'  },
    {'Q' , 'f12', 'f16', 'f20', 'f4', '-' , '[' , 'W' , 'E' , 'R'  , 'T'  , 'Y'  },
    {'A' , 'f13', 'f17', 'f1' , 'f5', 'f7', '\\', 'S' , 'D' , 'F'  , 'G'  , 'H'  },
    {'X' , 'f14', 'f18', 'f2' , 'f6', 'f8', ';' , '/' , '.' , 'Z'  , 'X'  , 'C'  },
    {'X' , 'f14', 'f18', 'f2' , 'f6', 'f8', ';' , '/' , '.' , 'Z'  , 'X'  , 'C'  }
}

hs.grid.MARGINX = 20
hs.grid.MARGINY = 20

hs.grid.ui.textSize = 16
hs.grid.ui.cellStrokeWidth = 1
hs.grid.ui.highlightStrokeWidth = 1
hs.grid.ui.fontName = 'IBM Plex Sans Condensed'
hs.grid.ui.cellStrokeColor = {1,1,1,0.125}
hs.grid.ui.textColor = {1,1,1,0}
hs.grid.ui.cellColor = {0,0,0,0.0}
hs.grid.ui.showExtraKeys = false

local pressed = {
  up = false,
  down = false,
  left = false,
  right = false
}

function move(cb)
  if hs.window.focusedWindow() then
    local win = hs.window.frontmostWindow()
    local screen = win:screen()

    cell = hs.grid.get(win, screen)
    cb(cell)

    hs.alert.show(cell.x .. 'x' .. cell.y, defaultStyle)

    hs.grid.set(win, cell, screen)
  end
end

function goTo (x, y, w, h)
  move(function (cell)
    cell.x = x * GRID.w / 3
    cell.y = y * GRID.h / 2
    cell.w = GRID.w / w
    cell.h = GRID.h / h
  end)
end

function nextFullScreenStep()
  if hs.window.focusedWindow() then
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local screen = win:screen()

    cell = hs.grid.get(win, screen)

    local nextSize = fullScreenSizes[1]

    for i=1,#fullScreenSizes do
      if cell.w == GRID.w / fullScreenSizes[i] and
         cell.h == GRID.h / fullScreenSizes[i] and
         cell.x == (GRID.w - GRID.w / fullScreenSizes[i]) / 2 and
         cell.y == (GRID.h - GRID.h / fullScreenSizes[i]) / 2 then
        nextSize = fullScreenSizes[(i % #fullScreenSizes) + 1]
        break
      end
    end

    cell.w = GRID.w / nextSize
    cell.h = GRID.h / nextSize
    cell.x = (GRID.w - GRID.w / nextSize) / 2
    cell.y = (GRID.h - GRID.h / nextSize) / 2

    hs.alert.show(cell.w .. 'x' .. cell.h, defaultStyle)

    hs.grid.set(win, cell, screen)
  end
end

function left () goTo(0, 0, 3, 1) end
function center () goTo(1, 0, 3, 1) end
function right () goTo(2, 0, 3, 1) end
function topLeft () goTo(0, 0, 3, 2) end
function topCenter () goTo(1, 0, 3, 2) end
function topRight () goTo(2, 0, 3, 2) end
function bottomLeft () goTo(0, 1, 3, 2) end
function bottomCenter () goTo(1, 1, 3, 2) end
function bottomRight () goTo(2, 1, 3, 2) end
function leftHalf () goTo(0, 0, 2, 1) end
function rightHalf () goTo(1.5, 0, 2, 1) end
function topLeftHalf () goTo(0, 0, 2, 2) end
function topRightHalf () goTo(1.5, 0, 2, 2) end
function bottomLeftHalf () goTo(0, 1, 2, 2) end
function bottomRightHalf () goTo(1.5, 1, 2, 2) end
function leftTwoThirds () goTo(0, 0, 3/2, 1) end
function rightTwoThirds () goTo(1, 0, 3/2, 1) end
function focus () goTo(3/4, 1/2, 2, 2) end
function fullScreen () goTo(0, 0, 1, 1) end

function createFilter (x, x2, y)
  return hs.window.filter.new(function (win)
    local maxX = x * GRID.w / 3
    local maxX2 = x2 * GRID.w / 2
    local maxY = y * GRID.h / 2
    local cell = hs.grid.get(win)
    return (cell.x == maxX or cell.x == maxX2) and cell.y == maxY
  end)
end

local filter1 = createFilter(0, 0, 0)
local filter2 = createFilter(1, 1, 0)
local filter3 = createFilter(2, 1, 0)
local filter4 = createFilter(0, 0, 1)
local filter5 = createFilter(1, 1, 1)
local filter6 = createFilter(2, 1, 1)

function activateFilter(filter)
  return function ()
    local windows = filter:getWindows()
    if windows[1] then
      windows[1]:focus()
    end
  end
end

hs.hotkey.bind(selectNumberModifiers, "1", activateFilter(filter1))
hs.hotkey.bind(selectNumberModifiers, "2", activateFilter(filter2))
hs.hotkey.bind(selectNumberModifiers, "3", activateFilter(filter3))
hs.hotkey.bind(selectNumberModifiers, "4", activateFilter(filter4))
hs.hotkey.bind(selectNumberModifiers, "5", activateFilter(filter5))
hs.hotkey.bind(selectNumberModifiers, "6", activateFilter(filter6))

hs.hotkey.bind(moveModifiers, "return", function ()
  focus()
end)

hs.hotkey.bind(moveModifiers, "down", function ()
  pressed.down = true
  if pressed.left and pressed.right and pressed.up then
    fullScreen()
  elseif pressed.left and pressed.up then
    leftTwoThirds()
  elseif pressed.right and pressed.up then
    rightTwoThirds()
  elseif pressed.up then
    center()
  elseif pressed.left then
    bottomLeft()
  elseif pressed.right then
    bottomRight()
  else
    bottomCenter()
  end
end, function ()
  pressed.down = false
end)

hs.hotkey.bind(moveModifiers, "up", function ()
  pressed.up = true
  if pressed.down and pressed.left and pressed.right then
    fullScreen()
  elseif pressed.left and pressed.down then
    leftTwoThirds()
  elseif pressed.right and pressed.down then
    rightTwoThirds()
  elseif pressed.down then
    center()
  elseif pressed.left then
    topLeft()
  elseif pressed.right then
    topRight()
  else
    topCenter()
  end
end, function ()
  pressed.up = false
end)

hs.hotkey.bind(moveModifiers, "right", function ()
  pressed.right = true
  if pressed.down and pressed.left and pressed.up then
    fullScreen()
  elseif pressed.up and pressed.down then
    rightTwoThirds()
  elseif pressed.left then
    if pressed.up then
      topLeftHalf()
    elseif pressed.down then
      bottomLeftHalf()
    else
      leftHalf()
    end
  elseif pressed.up then
    topRight()
  elseif pressed.down then
    bottomRight()
  else
    right()
  end
end, function ()
  pressed.right = false
end)

hs.hotkey.bind(moveModifiers, "left", function ()
  pressed.left = true
  if pressed.down and pressed.right and pressed.up then
    fullScreen()
  elseif pressed.up and pressed.down then
    leftTwoThirds()
  elseif pressed.right then
    if pressed.up then
      topRightHalf()
    elseif pressed.down then
      bottomRightHalf()
    else
      rightHalf()
    end
  elseif pressed.up then
    topLeft()
  elseif pressed.down then
    bottomLeft()
  else
    left()
  end
end, function ()
  pressed.left = false
end)

hs.hotkey.bind(moveModifiers, "f", function()
  nextFullScreenStep()
end)

hs.hotkey.bind(moveModifiers, "c", function()
  center()
end)

hs.hotkey.bind(moveModifiers, "return", function()
  hs.grid.toggleShow()
end)

hs.hotkey.bind(moveModifiers, "tab", function()
  switcher_browsers:previous()
end)