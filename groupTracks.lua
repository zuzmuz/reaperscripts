
reaper.Undo_BeginBlock()
-- Get the number of selected tracks
local num_tracks = reaper.CountSelectedTracks()
-- If we don't have any selected tracks, abort the script
if num_tracks == 0 then
    return
end

-- The selected tracks are numbered from 0
local first_track = reaper.GetSelectedTrack(0, 0)
local first_track_index = reaper.GetMediaTrackInfo_Value(first_track, 'IP_TRACKNUMBER') - 1
reaper.InsertTrackAtIndex(first_track_index, false)
local inserted_track = reaper.GetTrack(0, first_track_index)
reaper.SetMediaTrackInfo_Value(inserted_track, 'I_FOLDERDEPTH', 1)

local last_track = reaper.GetSelectedTrack(0, num_tracks-1)
local last_track_depth = reaper.GetMediaTrackInfo_Value(last_track, 'I_FOLDERDEPTH')
if last_track_depth ~= 1 then
  reaper.SetMediaTrackInfo_Value(last_track, 'I_FOLDERDEPTH', last_track_depth-1)
else 
  local num_all_tracks = reaper.GetNumTracks(0)
  local last_track_index = reaper.GetMediaTrackInfo_Value(last_track, 'IP_TRACKNUMBER')
  while last_track_index < num_all_tracks do
    track = reaper.GetTrack(0, last_track_index)
    last_track_depth = reaper.GetMediaTrackInfo_Value(track, 'I_FOLDERDEPTH')
    if last_track_depth < 0 then
      break
    end
    last_track_index = last_track_index + 1
  end
  reaper.SetMediaTrackInfo_Value(track, 'I_FOLDERDEPTH', last_track_depth-1)
end

reaper.Undo_EndBlock('Created group folder for selected tracks', 1)
