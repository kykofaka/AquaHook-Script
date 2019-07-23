local DrawGavno = {}

local optionKey = Menu.AddKeyOption({"FLite","DrawMiniMap"}, "⛧SATANA⛧ KEY", Enum.ButtonCode.KEY_F)
local optionKeyHit = Menu.AddKeyOption({"FLite","DrawMiniMap"}, "卐HITLER卐 KEY", Enum.ButtonCode.KEY_F)

DrawGavno.OnUpdate = function()
    if Menu.IsKeyDown(optionKey) then
        MiniMap.SendLine(4405, -466, true)
        MiniMap.SendLine(-5005, -466, false)
        MiniMap.SendLine(-270, 3762, false)
        MiniMap.SendLine(4405, -466, false)
        MiniMap.SendLine(-128, -3987, true)
        MiniMap.SendLine(2331, 5685, false)
        MiniMap.SendLine(-3432, 5347, true)
        MiniMap.SendLine(-128, -3987, false)
        MiniMap.SendLine(-3432, 5347, true)
        MiniMap.SendLine(-270, 3762, false)
        MiniMap.SendLine(-270, 3762, true)
        MiniMap.SendLine(2331, 5685, false)
    end
    if Menu.IsKeyDown(optionKeyHit) then
        MiniMap.SendLine(-221, -4011, true)
        MiniMap.SendLine(-221, 4011, false)

        MiniMap.SendLine(-221, 4011, true)
        MiniMap.SendLine(3737, 4011, false)

        MiniMap.SendLine(-221, -4011, true)
        MiniMap.SendLine(-3937, -4011, false)

        MiniMap.SendLine(4011, -221, true)
        MiniMap.SendLine(-4011, -221, false)

        MiniMap.SendLine(4011, -221, true)
        MiniMap.SendLine(3937, -4011, false)

        MiniMap.SendLine(-4011, -221, true)
        MiniMap.SendLine(-3937, 4011, false)
    end
end

return DrawGavno