reaper.Undo_BeginBlock()


local function hsv(hue, saturation, value)
    local c = value * saturation
    local x = c * (1 - math.abs((hue / 60) % 2 - 1))

    local r, g, b = 0, 0, 0
    if hue < 60 then
        r, g, b = c, x, 0
    elseif hue < 120 then
        r, g, b = x, c, 0
    elseif hue < 180 then
        r, g, b = 0, c, x
    elseif hue < 240 then
        r, g, b = 0, x, c
    elseif hue < 300 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end

    return reaper.ColorToNative(math.floor(255*(r + value - c)),
                                math.floor(255*(g + value - c)),
                                math.floor(255*(b + value - c)))
end

local track_color_indices = {
    dru = 0,
    per = 10,
    iqa = 20,
    efx = 40,
    vox = 60,
    voc = 60,
    syn = 90,
    pad = 110,
    win = 140,
    gui = 190,
    bas = 220,
    pia = 260,
    key = 280,
    vid = 320,
}

local default_color_indices = {
    a = 5,
    b = 15,
    c = 25,
    d = 35,
    e = 45,
    f = 55,
    g = 65,
    h = 75,
    i = 85,
    j = 95,
    k = 105,
    l = 115,
    m = 125,
    n = 135,
    o = 145,
    p = 155,
    q = 165,
    r = 175,
    s = 185,
    t = 195,
    u = 205,
    v = 215,
    w = 225,
    x = 235,
    y = 245,
    z = 255,
}

local last_color_index = {0,0,0}
local saturation = 0.58
local value = 0.85


local num_tracks = reaper.CountTracks()

for i = 0, num_tracks - 1 do
    local track = reaper.GetTrack(0, i)
    local status, track_name = reaper.GetTrackName(track)

    if status then
        local folder_depth = reaper.GetTrackDepth(track)
        if folder_depth == 0 then
            last_color_index = { track_color_indices[track_name:sub(1,3)],
                                 saturation,
                                 value }
            if not last_color_index[1] then
                last_color_index = { default_color_indices[track_name:sub(1,1)],
                                     saturation,
                                     value }
            end
            if not last_color_index[1] then
                last_color_index = { math.random(360), saturation, value }
            end
        end
        reaper.SetTrackColor(track, hsv(last_color_index[1],
                                        last_color_index[2],
                                        last_color_index[3]))
        last_color_index[1] = last_color_index[1]+1
        last_color_index[3] = last_color_index[3]*0.95
    end
end


reaper.Undo_EndBlock("Custom Coloring", 1)
