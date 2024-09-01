local utils = require("rguilib.utils")
local draw = require("rguilib.draw")
local View = {}

local view_num = 0

function View.new()
    utils.print("View.new")
    view_num = view_num + 1
    return setmetatable({
        x = 0,
        y = 0,
        w = 0,
        h = 0,
        margin_x = 0,
        margin_y = 0,
        view_num = view_num,
    }, {__index = View})
end

function View:set_position(x, y)
    self.x = x
    self.y = y
    return self
end

function View:set_size(w, h)
    self.w = w
    self.h = h
    return self
end

function View:set_margin(margin_x, margin_y)
    self.margin_x = margin_x
    self.margin_y = margin_y
    return self
end





local Stack = setmetatable(View.new(), {__index = View})

function Stack.new(direction, content)
    utils.print("Stack.new")
    local new = View.new()
    new.spacing = 0
    new.direction = direction
    new.content = content
    return setmetatable(new, {__index = Stack})
end

function Stack:set_spacing(spacing)
    self.spacing = spacing
    return self
end
local HStack = {}
function HStack.new(content)
    utils.print("HStack.new")
    local new = Stack.new(0, content)
    return setmetatable(new, {__index = Stack})
end
local VStack = {}
function VStack.new(content)
    utils.print("VStack.new ")
    local new = Stack.new(1, content)
    return setmetatable(new, {__index = Stack})
end

function Stack:measure(drawables)
    local position = 0
    self.w, self.h = 0, 0
    for _, item in ipairs(self.content) do
        item:set_position(self.x + (1-self.direction) * position + self.margin_x,
                          self.y + self.direction * position + self.margin_y)
        item:measure(drawables)

        position = position + item.w * (1-self.direction) + item.h * self.direction + self.spacing
        self.w = math.max(self.w, item.w, self.w + (item.w + self.spacing)*(1 - self.direction))
        self.h = math.max(self.h, item.h, self.h + (item.h + self.spacing)*self.direction)
    end
    self.w = self.w + 2*self.margin_x
    self.h = self.h + 2*self.margin_y
end

local Text = setmetatable(View.new(), {__index = View})

function Text.new(text)
    utils.print("Text.new")
    local new = View.new()
    new.text = text
    return setmetatable(new, {__index = Text})
end

function Text:measure(drawables)
    self.w, self.h = gfx.measurestr(self.text)
    self.w = self.w + 2*self.margin_x
    self.h = self.h + 2*self.margin_y
    drawables[#drawables+1] = self
end

function Text:render()
    draw.message(self.text, self.x, self.y)
end

local Button = setmetatable(Text.new(), {__index = View})

function Button.new(text, action)
    local new = View.new()
    new.text = Text.new(text)
    new.action = action
    return setmetatable(new, {__index = Button})
end

function Button:set_padding(padding_x, padding_y)
    self.padding_x = padding_x
    self.padding_y = padding_y
    return self
end


function Button:measure(drawables)
    self.text:set_position(self.x + self.padding_x, self.y + self.padding_y)
    self.text:measure(drawables)
    self.w = self.text.w + 2 * self.padding_x + 2*self.margin_x
    self.h = self.text.h + 2 * self.padding_y + 2*self.margin_y
    -- if gfx.mouse_x > self.x and
    --    gfx.mouse_x < self.x + self.w and
    --    gfx.mouse_y > self.y and
    --    gfx.mouse_y < self.y + self.h then
    --     draw.rect(self.x, self.y, self.w, self.h, false)
    --     -- TODO: click once
    --     if gfx.mouse_cap == 1 then
    --         self.action()
    --     end
    -- end
end


local Knob = setmetatable(View.new(), {__index = View})


---Create a new knob
---@param radius number radius of knob
---@return table
function Knob.new(radius)
    local new = View.new()
    new.value = 0
    new.radius = radius or 20
    return setmetatable(new, {__index = Knob})
end


---@param get fun(): number callback to get binded value
---@param set fun(value: number) callback to set binded value
function Knob:set_binding_value(get, set)
    self.get_binded_value = get
    self.set_binded_value = set
end

function Knob:measure(drawables)
    local value_str = tostring(math.floor(self.value*100))
    local value_str_w, value_str_h = gfx.measurestr(value_str)
    self.value_str_h = value_str_h

    self.w = math.max(2*self.radius, value_str_w)
    self.h = 2*self.radius + value_str_h

    drawables[#drawables+1] = self
end


function Knob:render()
    draw.circle(self.x + 0.5*self.w, self.y + self.radius, self.radius, false)

    local angle = 2 * math.pi * (2/3 - (self.value*5)/6)

    draw.line(self.x + 0.5*self.w * (1 + math.cos(angle)),
              self.y + self.radius * (1 - math.sin(angle)),
              self.x + 0.5*self.w,
              self.y + self.radius)


    draw.message(math.floor(self.value*100),
                 self.x + 0.5*self.w,
                 self.y + 2*self.radius + 0.5*self.value_str_h,
                 true)
end


return {
    View = View,
    HStack = HStack,
    VStack = VStack,
    Text = Text,
    Button = Button,
    Knob = Knob,
}
