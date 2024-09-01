local view = require("rguilib.view")
local utils = require("rguilib.utils")
local M = {}


M.selected_track = nil
M.width = 0
M.hight = 0


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

M.view = nil


function M.render()

    local rerender = false
    for _, event in pairs(M.events) do
        rerender = rerender or event()
    end

    if rerender then
        M.view = view.VStack.new({
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
            view.Knob.new(20)
        }):set_spacing(0)

        if M.view then
            local drawables = {}
            M.view:measure(drawables)

            for _, drawable in ipairs(drawables) do
                drawable:render()
            end

        end
        gfx.update()
    end
end


return M
