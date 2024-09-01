local path = ({reaper.get_action_context()})[2]:match('^.+[\\//]')
package.path = path .. "?.lua"

local utils = require("rguilib.utils")
local view = require("rguilib.view")
local draw = require("rguilib.draw")

local margin_x, margin_y = 10, 10
local base_distance = 10

local view_state = {
    selected_track = nil,
    width = gfx.w,
    hight = gfx.h,
    clean = true,
}

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


view_state.events = {
    function()
        local selected_track = reaper.GetSelectedTrack(0, 0)
        if view_state.selected_track ~= selected_track then
            view_state.selected_track = selected_track
            view_state.clean = false
        end
    end,
    function()
        if gfx.w ~= view_state.width or gfx.h ~= view_state.hight then
            view_state.width = gfx.w
            view_state.hight = gfx.h
            view_state.clean = false
        end
    end,
}

function view_state.render()

    for _, event in pairs(view_state.events) do
        event()
    end

    if not view_state.clean then
        update_selected_track(view_state.selected_track)
        view_state.clean = true
        utils.print("update")
        gfx.update()
    end
end


local vstack = view.VStack.new({
    view.HStack.new({
        view.Text.new("Hello"),
        view.Text.new("World"),
        view.Text.new("!")
    }):set_spacing(10):set_margin(30, 10),
    view.HStack.new({
        view.Text.new("Hello"),
        view.Text.new("Mom"),
        view.Text.new("!")
    }):set_spacing(20),
    view.Button.new("Hello", function()
        utils.print("Hello")
    end):set_padding(20, 10),
    view.Knob.new()
}):set_spacing(0)




local function main()
    -- view_state.render()
    vstack:render()
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
