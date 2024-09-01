reaper.Undo_BeginBlock()

local num_tracks = reaper.CountTracks()

local perc_keys = {
    "drum",
    "kick",
    "snare",
    "clap",
    "hat",
    "cymbal",
    "cymbl",
    "crash",
    "splash",
    "ride",
    "tambo",
    "perc",
    "tom",
    "overhead"
}

local oriental_perc_keys = {
  "riq",
  "tabla",
  "mazhar",
  "tabl",
  "derbakkeh",
  "iqa3",
  "cajun"
}

local oriental_perc_color = 0xdd7766

local perc_color = 0xff5550

local synth_keys = {
    "synth",
    "pad"
}

local synth_color = 0xa8ef6d

local wind_keys = {
  "sax",
  "trumpet",
  "trombone",
  "accordion",
  "melodica",
  "flute",
  "recorder",
  "duduk"
}

local wind_color = 0x88dfa0

local bass_keys = {
    "bass"
}

local bass_color = 0x3670be

local guitar_keys = {
    "guitar", "banjo", "mandolin"
}
local guitar_color = 0x50d0fe

local oriental_plucks_keys = {
  "buzuq",
  "oud",
  "qanun",
  "saz"
}

local oriental_plucks_color = 0xaabc60

local piano_color = 0x905066
local piano_keys = {
    "piano",
    "key"
}

local vocals_color = 0xefd570
local vocals_keys = {
  "vocals",
  "vocal",
  "vox"
}

local fx_keys = {
  "fx", "noise", "sound"
}
local fx_color = 0xf89d40

local name_color_dict = {
  { perc_keys, perc_color },
  { wind_keys, wind_color },
  { oriental_plucks_keys, oriental_plucks_color}, 
  { oriental_perc_keys, oriental_perc_color },
  { synth_keys, synth_color },
  { bass_keys, bass_color },
  { guitar_keys, guitar_color },
  { vocals_keys, vocals_color },
  { piano_keys, piano_color },
  { fx_keys, fx_color }
}


local track_types = {
  [0]="bus",
  [1]="audio",
  [2]="midi",
  [3]="fx",
  [4]="mixed",
  [5]="empty"
}

local track_types_brightness = {
  [0]=0.6,
  [1]=0.8,
  [2]=0.9,
  [3]=1.4,
  [4]=0.7,
  [5]=1
}

local function change_brightness(color, brightness)
  local r, g, b = reaper.ColorFromNative(color)

  local brightness_floor = math.floor(brightness)
  local bighthness_floor_factor = math.abs(1-brightness)

  r = math.floor((1-bighthness_floor_factor)*r + bighthness_floor_factor*brightness_floor*255)
  if r > 255 then 
    r = 255
  end
  g = math.floor((1-bighthness_floor_factor)*g + bighthness_floor_factor*brightness_floor*255)
  if g > 255 then
    g = 255
  end
  b = math.floor((1-bighthness_floor_factor)*b + bighthness_floor_factor*brightness_floor*255)
  if b > 255 then
    b = 255
  end
  -- reaper.ShowConsoleMsg(r .. ' ' .. g .. ' ' .. b .. '\n')
  return reaper.ColorToNative(r, g, b)
end


local function get_media_items_type(track, number_of_media_items)
  local is_audio = false
  local is_midi = false
   
  for i = 0, number_of_media_items - 1 do
    local media_item = reaper.GetTrackMediaItem(track, i)
    local number_of_takes = reaper.GetMediaItemNumTakes(media_item)
    -- reaper.ShowConsoleMsg('number_of_takes' .. number_of_takes .. '\n')
    for j = 0, number_of_takes - 1 do
      local take = reaper.GetMediaItemTake(media_item, j)
      if take ~= nil then 

        -- reaper.ShowConsoleMsg('media item ' .. j .. ' type ' .. type(take) .. '\n')
        local take_source = reaper.GetMediaItemTake_Source(take)
        local type_buff = ""
        type_buff = reaper.GetMediaSourceType(take_source, type_buff)

        is_audio = type_buff == "WAVE"
        is_midi = type_buff == "MIDI"
      end
    end
  end
  if is_audio and is_midi then
    return 4
  elseif is_audio then
    return 1
  elseif is_midi then
    return 2
  end
  return 5
end

local function get_name_color(track_name, default_color)
  for i, name_color in ipairs(name_color_dict) do
    for j, name in ipairs(name_color[1]) do
      if string.find(track_name, name) then
        return name_color[2]
      end
    end
  end
  return default_color
end

for i = 0, num_tracks - 1 do

  local track = reaper.GetTrack(0, i)
  local ret_value, track_name = reaper.GetTrackName(track)
    
  if ret_value then
    local number_of_receives = reaper.GetTrackNumSends(track, -1)
    local number_of_sends = reaper.GetTrackNumSends(track, 0)
    local folder_depth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
    local number_of_media_items = reaper.GetTrackNumMediaItems(track)
    local track_type = 1
    -- reaper.ShowConsoleMsg(track_name .. "\n")
    track_type = get_media_items_type(track, number_of_media_items)
    
    if track_type == 5 and number_of_receives > 0 then
      track_type = 3
    end
    
    if folder_depth == 1 then
      track_type = 0
    end


    local default_color = reaper.GetTrackColor(track)
    -- reaper.ShowConsoleMsg("get" .. track_name .. default_color .. "\n")
    local color = get_name_color(track_name, default_color)
    -- reaper.ShowConsoleMsg("set" .. track_name .. color .. "\n")
    -- color = change_brightness(color, track_types_brightness[track_type])

    reaper.SetTrackColor(track, color)

    -- reaper.ShowConsoleMsg(track_name .. "\n" ..
    --   "\tr: " .. number_of_receives ..
    --   ", s: " .. number_of_sends .. "\n" ..
    --   "\ttype: " .. track_types[track_type] .. "\n" ..
    --   "\tmedia items: " .. number_of_media_items .. "\n" .. 
    --   "\tcolor: " .. color .. "\n")
  end
end


reaper.Undo_EndBlock("Custom Coloring", 1)

