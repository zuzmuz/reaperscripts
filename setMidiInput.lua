-- Set the selected track(s) to MIDI input

local midi_channel = 0

-- Get the number of selected tracks
local num_tracks = reaper.CountSelectedTracks()

-- If we don't have any selected tracks, abort the script
if num_tracks == 0 then
    return
end

-- Keeps Reaper's undo history tidy
reaper.Undo_BeginBlock()

-- The selected tracks are numbered from 0
for i = 0, num_tracks - 1 do
    
    -- Get the track's info
    local track = reaper.GetSelectedTrack(0, i)
    
    --[[
        
    reaper.SetMediaTrackInfo_Value( tr, parmname, newvalue )
    
    I_RECINPUT : int * : record input. 
        
        <0      = no input, 
        0..n    = mono hardware input, 
        512+n = rearoute input, 
        1024 set for stereo input pair. 
        4096 set for MIDI input, 
            if set  then low 5 bits represent channel (0=all, 1-16=only chan), 
                    then next 5 bits represent physical input (63=all, 62=VKB)
    ]]--
    
    
    reaper.SetMediaTrackInfo_Value(track, "I_RECINPUT", 4096 + 63*32)
    
end

reaper.Undo_EndBlock("Set the selected track(s) to MIDI input", 1)