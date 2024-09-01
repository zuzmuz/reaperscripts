local path = ({reaper.get_action_context()})[2]:match('^.+[\\//]')
reaper.ShowConsoleMsg(path .. "\n")
reaper.ShowConsoleMsg(package.path .. "\n")
-- require "Basics"

grid_size = {30, 20}
UP = 30064
DOWN = 1685026670
LEFT = 1818584692
RIGHT = 1919379572
direction = RIGHT
-- direction_queue = Queue.new()
speed = 5

arrows = {
	[UP] = 'up',
	[DOWN] = 'down',
	[LEFT] = 'left',
	[RIGHT] = 'right'
}

snake_size = 5

snake_cursor = 5

snake_coord = {
	{12, 10},
	{13, 10},
	{14, 10},
	{15, 10},
	{16, 10},
}



local function get_grid_element_size()
	local fit_width = gfx.w <= gfx.h*3/2 and gfx.w or gfx.h*3/2
	return fit_width/grid_size[1]
end

local function get_border_frame()
	local grid_element_size = get_grid_element_size()
	local width_for_height = gfx.w <= gfx.h*3/2
	local x =  (width_for_height and 0 or (gfx.w - gfx.h*3/2)/2) + 0.15*grid_element_size
	local y = (width_for_height and (gfx.h - gfx.w*2/3)/2 or 0) + 0.15*grid_element_size
	local w = (width_for_height and gfx.w or gfx.h*3/2) - 0.3*grid_element_size
	local h = (width_for_height and gfx.w*2/3 or gfx.h) - 0.3*grid_element_size
	return x, y, w, h
end

local function draw_border(x, y, w, h)
	gfx.rect(x, y, w, h, false)
end

local function draw_snake()
	local x, y = get_border_frame()
	local grid_element_size = get_grid_element_size()
	for i, coord in ipairs(snake_coord) do
		if i == snake_cursor then
			gfx.rect(coord[1]*grid_element_size + x, coord[2]*grid_element_size + y, grid_element_size - 2*x, grid_element_size - 2*y)
		elseif i == snake_cursor%snake_size + 1 then
			
		else
			gfx.rect(coord[1]*grid_element_size + x, coord[2]*grid_element_size + y, grid_element_size - 2*x, grid_element_size - 2*y)
		end
	end 
end

local function get_snake_size()
	local count = 0
	for i in pairs(snake_coord) do
		count = count + 1
	end
	return count
end

local function update_snake()
	
	local old_snake_cursor = snake_cursor
	snake_cursor = snake_cursor%snake_size + 1
	
	local new_direction = Queue.popleft(direction_queue)
	if new_direction then
		if (direction == RIGHT or direction == LEFT) 
				and (new_direction == UP or new_direction == DOWN) 
				or (direction == UP or direction == DOWN) 
				and (new_direction == LEFT or new_direction == RIGHT) then 
			direction = new_direction
		end
	end

	if direction == RIGHT then
		snake_coord[snake_cursor][1] = (snake_coord[old_snake_cursor][1] + 1) % grid_size[1]
		snake_coord[snake_cursor][2] = snake_coord[old_snake_cursor][2]
	elseif direction == LEFT then
		snake_coord[snake_cursor][1] = (snake_coord[old_snake_cursor][1] - 1) % grid_size[1]
		snake_coord[snake_cursor][2] = snake_coord[old_snake_cursor][2]
	elseif direction == UP then 
		snake_coord[snake_cursor][2] = (snake_coord[old_snake_cursor][2] - 1) % grid_size[2]
		snake_coord[snake_cursor][1] = snake_coord[old_snake_cursor][1]
	elseif direction == DOWN then 
		snake_coord[snake_cursor][2] = (snake_coord[old_snake_cursor][2] + 1) % grid_size[2]
		snake_coord[snake_cursor][1] = snake_coord[old_snake_cursor][1]
	end
end

frame = 0

local function main()
	local char = gfx.getchar()
	-- reaper.ShowConsoleMsg(char .. "\n")
	if arrows[char] then
		Queue.pushright(direction_queue, char)
	end
	if char ~= 27 and char ~= -1 then
		reaper.defer(main)
	end

	local x, y, w, h = get_border_frame()
	draw_border(x, y, w, h)
	draw_snake()
	if frame % speed == 0 then 
		update_snake()
	end
	frame = frame + 1
	-- gfx.update()
end


gfx.init("Snake", 600, 400, 0)
reaper.defer(main)
