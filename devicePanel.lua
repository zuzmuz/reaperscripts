local path = ({reaper.get_action_context()})[2]:match('^.+[\\//]')
package.path = path .. "?.lua"

local utils = require("rguilib.utils")
local view_state = require("rguilib.view_state")
local draw = require("rguilib.draw")

local margin_x, margin_y = 10, 10
local base_distance = 10

local function UpdateTrackFXChain(track, number_of_fx, base_y)
	local fx_width = 250

	for i=0, number_of_fx-1 do
		local fx_x, fx_y = margin_x + i*fx_width, base_y + base_distance

		local enabled = reaper.TrackFX_GetEnabled(track, i)
		local ret_value, fx_name = reaper.TrackFX_GetFXName(track, i, "")

		if enabled then
			gfx.set(0.2, 0.2, 0.2, 1)
		else
			gfx.set(0.05, 0.05, 0.05, 1)
		end
		draw.roundrect(fx_x,
                       fx_y,
				       fx_width - base_distance,
                       gfx.h - base_y - base_distance - margin_y,
                       base_distance,
                       true)

		local r, g, b = 0.9, 0.9, 0.9

		if not enabled then
			r, g, b = 0.3, 0.3, 0.3
		end

		if ret_value then
			draw.message(fx_name,
				         fx_x + (fx_width - base_distance)/2,
				         fx_y + (gfx.h - base_y - base_distance - margin_y)/2, true, r, g, b)
		end



	end
end


local function update_selected_track(track)
	if not track then
		draw.center_message("no selected track")
		return
	end

	local status, track_name = reaper.GetTrackName(track)
	if not status then
		draw.center_message("something wrong")
		return
	end
	local number_of_fx = reaper.TrackFX_GetCount(track)
	draw.message(track_name .. " " .. number_of_fx, margin_x, margin_y)
	UpdateTrackFXChain(track, number_of_fx, margin_y)
end






local function main()
    view_state.render()
    local char = gfx.getchar()
    if char ~= 27 and char ~= -1 then
        reaper.defer(main)
    end
end

gfx.clear = 0x202020
gfx.init("Channel Strip", 1000, 400, 1)
gfx.setfont(1, "Arial", 24)
gfx.setfont(2, "Arial", 16)

reaper.defer(main)
