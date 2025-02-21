local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Emerson2-creator/OthersGui/refs/heads/main/My-Gui-Project/src/raw-gui/Gui1.lua"))()

--Variable
local gui = library.new("My GUI")
local page = gui:addPage("Main Page")
local section = page:addSection("Main Section")
--Button
section:addButton("Click Me", function()
    print("Button clicked!")
end)
--Toggle
section:addToggle("Enable Feature", false, function(state)
    print("Toggle state:", state)
end)


