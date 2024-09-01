track = nil
margin_x, margin_y = 10, 10
base_distance = 10

-- Helpful functions



local function RoundRect(x, y, w, h, r, antialias, fill)
	
	if not fill then
		gfx.roundrect(x, y, w, h, r, antialias)
	elseif h >= 2 * r then
		
		-- Corners
		gfx.circle(x + r, y + r, r, fill, antialias)		-- top-left
		gfx.circle(x + w - r, y + r, r, fill, antialias)		-- top-right
		gfx.circle(x + w - r, y + h - r, r , fill, antialias)	-- bottom-right
		gfx.circle(x + r, y + h - r, r, fill, antialias)		-- bottom-left
		
		-- Ends
		gfx.rect(x, y + r, r, h - r * 2)
		gfx.rect(x + w - r, y + r, r + 1, h - r * 2)
			
		-- Body + sides
		gfx.rect(x + r, y, w - r * 2, h + 1)
		
	else
	
		r = h / 2 - 1
	
		-- Ends
		gfx.circle(x + r, y + r, r, true, antialias)
		gfx.circle(x + w - r, y + r, r, true, antialias)
		
		-- Body
		gfx.rect(x + r, y, w - r * 2, h)
		
	end	
	
end

-- Basic titles
local function ShowDefaultMessage(message)
	gfx.setfont(1)
	gfx.set(0.9, 0.9, 0.9, 1)
	local message_w, message_h = gfx.measurestr(message)
	local txt_x = (gfx.w - message_w) / 2
	local txt_y = (gfx.h - message_h) / 2
	gfx.x = txt_x
	gfx.y = txt_y
	gfx.drawstr(message)
end

local function DrawMessage(message, x, y, center, r, g, b)
	gfx.setfont(2)
	if r and g and b then
		gfx.set(r, g, b, 1)
	else 
		gfx.set(0.9, 0.9, 0.9, 1)
	end
	if center then
		local message_w, message_h = gfx.measurestr(message)
		x = x - message_w/2
		y = y - message_h/2
	end
	gfx.x, gfx.y = x, y
	gfx.drawstr(message)
end


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
		RoundRect(fx_x, fx_y,
				  fx_width - base_distance, gfx.h - base_y - base_distance - margin_y, base_distance, true, true)
		
		local r, g, b = 0.9, 0.9, 0.9

		if not enabled then
			r, g, b = 0.3, 0.3, 0.3
		end

		if ret_value then
			DrawMessage(fx_name, 
				fx_x + (fx_width - base_distance)/2, 
				fx_y + (gfx.h - base_y - base_distance - margin_y)/2, true, r, g, b)
		end



	end
end

local function UpdateSelectedTrack(track)
	if not track then
		ShowDefaultMessage("no selected track")
		return
	end

	local ret_value, track_name = reaper.GetTrackName(track)
	if not ret_value then
		ShowDefaultMessage("something wrong")
		return
	end
	
	DrawMessage(track_name, margin_x, margin_y)
	number_of_fx = reaper.TrackFX_GetCount(track)
	local track_name_w, track_name_h = gfx.measurestr(track_name)
	DrawMessage(number_of_fx, margin_x + track_name_w + base_distance, margin_y)


	UpdateTrackFXChain(track, number_of_fx, margin_y + track_name_h)
end




local function Main()
	local char = gfx.getchar()
	local selected_track = reaper.GetSelectedTrack(0, 0)
	-- if selected_track ~= track then
		-- track = selected_track
		UpdateSelectedTrack(selected_track)
	-- end
	if char ~= 27 and char ~= -1 then
		reaper.defer(Main)
	end
	gfx.update()
	-- reaper.ShowConsoleMsg("track name :" .. track_name .. "\n")
end

gfx.clear = 0x202020
gfx.init("Channel Strip", 1000, 400, 1)
gfx.setfont(1, "Arial", 24)
gfx.setfont(2, "Arial", 16)
UpdateSelectedTrack(selected_track)
reaper.defer(Main)