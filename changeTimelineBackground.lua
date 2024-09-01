loopState = reaper.GetSetRepeat(-1)

if loopState == 0 then
  reaper.SetThemeColor('col_tl_bgsel2', -1, 1)
  reaper.SetThemeColor('col_tl_bgsel', -1, 1)
else
  reaper.SetThemeColor('col_tl_bgsel2', 0x96e54c, 1)
  reaper.SetThemeColor('col_tl_bgsel', 0x96e54c, 1)
end

reaper.UpdateTimeline()
