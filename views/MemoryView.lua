--- Base class for MemoryView
-- @classmod MemoryView

local class = require("lib.classy")
local View = require("lib.view.View")
local view = require("lib.view")
local event = require("lib.event")
local MemoryGame = require("lib.memory.Memory")
local Surface = require("emulator.surface")
local utils = require("lib.utils")
local MemoryView = class("MemoryView", View)
local card= require("lib.components.MemoryCardComponent")
local button_grid	=	require("lib.components.ButtonGrid")
local color = require("lib.draw.Color")
local serpent = require("lib.serpent")
local button = require("lib.components.Button")


function MemoryView:__init()
    View.__init(self)
	event.remote_control:off("button_release") -- TODO remove this once the ViewManager is fully implemented

    -- Flags to determine whether a player has moved or pressed submit
	self.player_moved = false
	self.player_ok = false
	self.listening_initiated = false

    -- Logic
    self.cards = {}
    self.positions = {}
    self.pairs = 10
    self.memory = MemoryGame(self.pairs, false)
    self.button_grid = button_grid()
    self.columns = math.ceil((self.pairs*2)^(1/2))

    -- Graphics
    self.font = sys.new_freetype(
        {r = 255, g = 255, b = 255, a = 255},
        32,
        {x = 100, y = 300},
    utils.absolute_path("data/fonts/DroidSans.ttf"))

    self.button_color = color(0, 128, 225, 255)
    self.color_selected = color(33, 99, 111, 255)
    self.color_disabled = color(111,222,111,255)
    self.text_color = color(255, 255, 255, 255)

    -- Components
    local button_size_big = {width = 300, height = 100}
    self.button_1 = button(self.button_color, self.color_selected,
        self.color_disabled, true, false)
    self.positions["exit"] = {x = 100, y = 450}
    self.button_1:set_textdata("Back to City", self.text_color,
        {x = 100, y = 450}, 30,
        utils.absolute_path("data/fonts/DroidSans.ttf"))

    -- Create the button grid
    local button_color = color(0, 128, 225, 255)
    local color_disabled = color(111,222,111,255)
    local color_selected = color(33, 99, 111, 255)
    self.button_size = {width = 100, height = 100}
    local x_gap = self.button_size.width + 50
    local y_gap = self.button_size.height + 50

    self.button_grid:add_button(self.positions["exit"], button_size_big,
                                self.button_1)
    self.pos_x = 450
    self.pos_y = 50

    for i = 1, self.pairs*2 do
        self.cards[i]  = button(button_color, color_selected,
                                color_disabled, true, false)
        if i == 1 then
            self.pos_x = self.pos_x
        elseif ((i-1) % self.columns == 0) then
            self.pos_y = self.pos_y + y_gap
            self.pos_x = self.pos_x - (self.columns - 1) * x_gap
        else
            self.pos_x = self.pos_x + x_gap
        end

        self.positions[i] = {x = self.pos_x, y = self.pos_y}
        self.button_grid:add_button(self.positions[i],
                                    self.button_size,
                                    self.cards[i])
    end

    -- Listeners and callbacks
    self:listen_to(
        event.remote_control,
        "button_release",
        utils.partial(self.press, self)
    )
end


function MemoryView:press(key)
    if key == "back" then
		self:back_to_city()
    end
end


-- Renders MemoryView and all of its child views
function MemoryView:render(surface)
    if not self.listening_initiated then
        local grid_callback = utils.partial(self.button_grid.render,
            self.button_grid, surface)
        self:listen_to(
            self.button_grid,
            "dirty",
            grid_callback)
        self.listening_initiated = true
    end

    if self:is_dirty() then
        surface:clear(color)

        -- Add the number of turns
        local turns_text =sys.new_freetype(self.text_color:to_table(), 30,
            {x = 100, y = 110}, utils.absolute_path("data/fonts/DroidSans.ttf"))
        local turns = sys.new_freetype(self.text_color:to_table(), 30,
            {x = 100, y = 150}, utils.absolute_path("data/fonts/DroidSans.ttf"))
        turns_text:draw_over_surface(surface, "Turns")

        if self.memory.moves == nil then
            turns:draw_over_surface(surface, "No turns...")
        else
            turns:draw_over_surface(surface, self.memory.moves)
        end
        gfx.update()
    end
    self:dirty(false)
    -- Render child components
    self.button_grid:render(surface)
    --self.button_1:render(surface)

end

function MemoryView:back_to_city()
    self:destroy()
    -- TODO Implement/connect pop-up for quit game
    -- Appendix 2 in UX design document
    -- Trigger exit event
    self:trigger("exit")
end


return MemoryView
