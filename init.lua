-- setup hs.alert.defaultStyle
defaultStyle = {fillColor = {black = 0.1}, strokeColor = {white = 0.1}, strokeWidth = 2, radius = 4, textColor = {white = 1}, textFont = 'InputSansCondensed-Thin', textSize = 13}

-- load stuffy
require "wmparty"
require "corners"
require "caffeinate"
require "clock"

-- confirm loading of config
hs.alert.show("Config loaded :)", defaultStyle)