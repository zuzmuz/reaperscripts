local M = {}



---Draw a rectangle
---@param x number horizontal position
---@param y number vertical position
---@param w number width
---@param h number height
---@param fill boolean false for stroke, true for fill
function M.rect(x, y, w, h, fill)
    gfx.rect(x, y, w, h, fill)
end

---Draw a rounded rectangle
---@param x number horizontal position
---@param y number vertical position
---@param w number width
---@param h number height
---@param r number corner radius
---@param fill boolean false for stroke, true for fill
function M.roundrect(x, y, w, h, r, fill)
    if not fill then
        gfx.roundrect(x, y, w, h, r, true)
    elseif h >= 2 * r then
        -- Corners
        gfx.circle(x + r, y + r, r, fill, true) -- top-left
        gfx.circle(x + w - r, y + r, r, fill, true) -- top-right
        gfx.circle(x + w - r, y + h - r, r, fill, true) -- bottom-right
        gfx.circle(x + r, y + h - r, r, fill, true) -- bottom-left
        -- Ends
        gfx.rect(x, y + r, r, h - r * 2)
        gfx.rect(x + w - r, y + r, r + 1, h - r * 2)
        -- Body + sides
        gfx.rect(x + r, y, w - r * 2, h + 1)
    else
        r = h / 2 - 1
        -- Ends
        gfx.circle(x + r, y + r, r, true, true)
        gfx.circle(x + w - r, y + r, r, true, true)
        -- Body
        gfx.rect(x + r, y, w - r * 2, h)
    end
end

---Draw a circle
---@param x number horizontal position of center
---@param y number vertical position of center
---@param r number radius
---@param fill boolean false for stroke, tur for fill
function M.circle(x, y, r, fill)
    gfx.circle(x, y, r, fill, true)
end



function M.line(x1, y1, x2, y2)
    gfx.line(x1, y1, x2, y2)
end


---Draw text
function M.message(message, x, y, center, r, g, b)
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


function M.center_message(message)
	gfx.setfont(1)
	gfx.set(0.9, 0.9, 0.9, 1)
	local message_w, message_h = gfx.measurestr(message)
	local txt_x = (gfx.w - message_w) / 2
	local txt_y = (gfx.h - message_h) / 2
	gfx.x = txt_x
	gfx.y = txt_y
	gfx.drawstr(message)
end

return M
