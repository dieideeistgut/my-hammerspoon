-- setup hs.alert.defaultStyle
defaultStyle = {fillColor = {black = 0.1}, strokeColor = {white = 0.1}, strokeWidth = 2, radius = 7, textColor = {white = 1}, textFont = 'IBM Plex Sans Condensed Medium', textSize = 18}

-- load stuffy
require "wmparty"
require "corners"
require "caffeinate"

-- confirm loading of config
hs.alert.show("Config loaded", defaultStyle)