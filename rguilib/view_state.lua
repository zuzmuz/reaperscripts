local utils = require("utils")
local M = {}


M.selected_track = nil
M.width = gfx.w
M.hight = gfx.h
M.clean = true


M.events = {
    function()
        local selected_track = reaper.GetSelectedTrack(0, 0)
        if M.selected_track ~= selected_track then
            M.selected_track = selected_track
            M.clean = false
        end
    end,
    function()
        if gfx.w ~= M.width or gfx.h ~= M.hight then
            M.width = gfx.w
            M.hight = gfx.h
            M.clean = false
        end
    end,
}


function M.render()

    for _, event in pairs(M.events) do
        event()
    end

    if not M.clean then
        update_selected_track(M.selected_track)
        M.clean = true
        utils.print("update")
        gfx.update()
    end
end






return M
