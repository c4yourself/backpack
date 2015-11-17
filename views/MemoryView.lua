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
local Profile = require("lib.profile.Profile")


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
    self.profile = Profile("Lisa", "lisa@lisa.se", "04-08-1992", "female", "paris")
    self:_set_pairs()
    print(self.pairs)
    self.memory = MemoryGame(self.pairs, profile, false)
    self.button_grid = button_grid()
    self.columns = math.ceil((self.pairs*2)^(1/2))

-- Adjust the board so that rows*columns = 2*pairs
    for i=1, self.pairs * 2 do
      if ((2 * self.pairs) % self.columns) == 0 then
        break
      else
        self.columns = self.columns + 1
      end
    end



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

---This function is called everytime the user presses submit/ok. It's
-- purpose is to connect the GUI with the backend logic (i.e. check win conditions,
-- increment turn counter, check if two cards are identical or not) and make
-- sure the data modell is changed when the game progresses

-- Uses the last_selection variable as an index of the state in memory. checks if
-- the game is finished when opening the second card.
function MemoryView:_determine_new_state()
    --[[ pseudo-code:
    Assume you have the index of the card the user pressed submit/ok and that
    it can be found in this variable: self.last_selection

    if self.memory.first_card == nil then
        self.memory:open
    else if self.memory.second_card == nil then
        open
        check for win condition (?)
    else
        etc...
    end
    ]]
    -- last_selection is an index (?)
    --State where no first and second card is nil
    local card, is_open = self.memory:look(self.last_selection)

    if self.memory.first_card == nil then
      if is_open ~= true then
        self.memory:open(self.last_selection)
      end
    elseif self.memory.second_card ==nil then
      if is_open ~= true then
        self.memory:open(self.last_selection)
        self.memory:is_finished()
      end
    end
end


-- Used to check match between two open cards. Should be used to call match if
-- two cards are opened and the player has moved to another card.
function MemoryView:check_match()
  if self.memory.second_card ~= nil then
      self.memory:match()
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
--At this point, we should check the memory states and keep the card that are true in memory.states open
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
    self:trigger("exit_view")
end

-- Function to set pairs accoriding to profile experience
function MemoryView:_set_pairs()
	local exp = self.profile:get_experience() + 350
	if exp <= 100 then
		self.pairs = 4
	elseif exp <=200 then
		self.pairs = 6
	elseif exp <= 300 then
		self.pairs = 8
	elseif exp >300 then
		self.pairs = 10
	end
end


return MemoryView
