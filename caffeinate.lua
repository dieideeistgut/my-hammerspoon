hs.loadSpoon('Caffeine')

hs.hotkey.bind({"alt", "ctrl"}, "l", function()
  hs.caffeinate.startScreensaver()
  hyper.triggered = true
end)