local view = require("rguilib.view")
local utils = require("rguilib.utils")
local M = {}


M.selected_track = nil
M.width = 0
M.hight = 0


M.last_mouse_x = nil
M.last_mouse_y = nil
M.last_mouse_state = 0
M.press_mouse_x = nil
M.press_mouse_y = nil

M.events = {
    function()
        local selected_track = reaper.GetSelectedTrack(0, 0)
        if M.selected_track ~= selected_track then
            M.selected_track = selected_track
            return true
        end
        return false
    end,
    function()
        if gfx.w ~= M.width or gfx.h ~= M.hight then
            M.width = gfx.w
            M.hight = gfx.h
            return true
        end
        return false
    end,
}



function M.handle_mouse_event()
    if M.last_mouse_state == 0 and gfx.mouse_cap == 1 then
        M.press_mouse_x = gfx.mouse_x
        M.press_mouse_y = gfx.mouse_y
        M.last_mouse_x = gfx.mouse_x
        M.last_mouse_y = gfx.mouse_y
        M.last_mouse_state = 1
        return { type = 'press', x = gfx.mouse_x, y = gfx.mouse_y }
    elseif M.last_mouse_state == 1 and gfx.mouse_cap == 1 then
        local dx = gfx.mouse_x - M.last_mouse_x
        local dy = gfx.mouse_y - M.last_mouse_y

        M.last_mouse_x = gfx.mouse_x
        M.last_mouse_y = gfx.mouse_y
        return {
            type = 'drag',
            x = M.press_mouse_x,
            y = M.press_mouse_y,
            dx = dx,
            dy = dy,
        }
    elseif gfx.mouse_cap == 0 then
        M.last_mouse_state = 0
    end
end

M.drawables = {}

M.view = view.VStack {
    view.HStack {
        view.Text("Hello"),
        view.Text("World"),
        view.Text("!")
    }:set_spacing(10):set_margin(30, 10),
    view.HStack {
        view.Text("Hello"),
        view.Text("Mom"),
        view.Text("!")
    }:set_spacing(20),
    view.Button("Hello", function()
        utils.print("Hello")
    end):set_padding(20, 10),
    view.Knob(20)
}:set_spacing(0)


function M.render()

    local rerender = false
    for _, event in pairs(M.events) do
        rerender = event()
    end

    local mouse_event = M.handle_mouse_event()

    if mouse_event then
        for _, drawable in ipairs(M.drawables) do
            if drawable.handle and
                mouse_event.x >= drawable.x and mouse_event.x <= drawable.x + drawable.w and
                mouse_event.y >= drawable.y and mouse_event.y <= drawable.y + drawable.h then

                drawable:handle(mouse_event)
                rerender = true
            end
        end
    end


    if rerender then
        if M.view then
            M.drawables = {}
            M.view:measure(M.drawables)

            for _, drawable in ipairs(M.drawables) do
                drawable:render()
            end

        end
        gfx.update()
    end
end


return M
