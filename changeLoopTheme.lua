reaper.Undo_BeginBlock()

local loopState = reaper.GetSetRepeat(-1)

if loopState == 0 then
local themeFile = reaper.GetExePath() .. "/" .. "ColorThemes" .. "/" .. "Nova_2.02_loopDisabled.ReaperTheme"
reaper.OpenColorThemeFile(themeFile)
end

if loopState == 1 then
local themeFile = reaper.GetExePath() .. "/" .. "ColorThemes" .. "/" .. "Nova_2.02_loopEnabled.ReaperTheme"
reaper.OpenColorThemeFile(themeFile)
end
