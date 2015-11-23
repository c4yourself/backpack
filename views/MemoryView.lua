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
local MemoryGrid = require("lib.components.MemoryGrid")
local CardComponent = require("components.CardComponent")
local Profile = require("lib.profile.Profile")
local Font = require("lib.draw.Font")

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
    self.button_grid = MemoryGrid()
    self.profile = Profile("Lisa", "lisa@lisa.se", "04-08-1992", "female", "paris")
    self:_set_pairs()
    --self.pairs = 3 -- TODO For quicker manual testing, remove once done coding
    self.memory = MemoryGame(self.pairs, profile, false)
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
    self.font = Font("data/fonts/DroidSans.ttf", 32, color(255, 255, 255, 255))
    self.button_color = color(250, 105, 0, 255)
    self.color_selected = color(250, 169, 0, 255)
    self.color_disabled = color(111,222,111,255)
    self.text_color = color(255, 255, 255, 255)

    -- Components
    local width = screen:get_width()
    local height = screen:get_height()
    local button_size_big = {width = 300, height = 100}
    self.button_1 = button(self.button_color, self.color_selected,
        self.color_disabled, true, false)
    self.positions["exit"] = {x = 100, y = 450}
    self.button_1:set_textdata("Back to City", self.text_color,
        {x = 100 + 65, y = 450 + 50 - 16}, 30,
        utils.absolute_path("data/fonts/DroidSans.ttf"))

    -- Create the button grid
    local card_color = color(250, 105, 0, 255)--color.from_html("fa6900ff")
    --color(0, 128, 225, 255)
    local card_color_disabled = color(111,222,111,255)
    local card_color_selected = color(33, 99, 111, 255)
    self.button_size = {width = 100, height = 100}
    local x_gap = self.button_size.width + 50
    local y_gap = self.button_size.height + 50

    self.pos_x = 450
    self.pos_y = 50

    for i = 1, self.pairs*2 do
        self.cards[i]  = CardComponent(card_color, card_color_selected,
                                card_color, true, false)
        --Temporary code snippet to be able to differentiate cards from eachother
        -- TODO write text or add pictures instead (?)
        -- local cc = (self.memory.cards[i] * 50) % 255
        -- local front_color = color(cc, cc, cc, cc)
        local cc1 = 255
        local cc2 = 255
        local cc3 = 255
        local cc4 = 255
        if self.memory.cards[i] % 4 == 0 then
          print("4")
          cc4 = (self.memory.cards[i] * 50) % 255
        elseif self.memory.cards[i] % 3 == 0 then
          print("3")
          cc3 = (self.memory.cards[i] * 50) % 255
        elseif self.memory.cards[i] % 2 == 0 then
          print("2")
          cc2 = (self.memory.cards[i] * 50) % 255
        else
          print("1")
          cc1 = (self.memory.cards[i] * 50) % 255
        end

        local front_color = color(cc1, cc2, cc3, cc4)
        self.cards[i].front_color = front_color

        -- Temporary code ends
        if i == 1 then
            self.pos_x = self.pos_x
        elseif ((i-1) % self.columns == 0) then
            self.pos_y = self.pos_y + y_gap
            self.pos_x = self.pos_x - (self.columns - 1) * x_gap
        else
            self.pos_x = self.pos_x + x_gap
        end

        self.positions[i] = {x = self.pos_x, y = self.pos_y}
        --local card_text = tostring(self.memory.cards[i])
        --local text_position =
        --self.cards[i]:set_textdata(card_text, self.text_color, text_position,
        --                            font_size, font_path)

        self.button_grid:add_button(self.positions[i],
                                    self.button_size,
                                    self.cards[i])
    end

    -- Add other buttons to the grid
    -- (has to be done after the memory cards has been added)
    self.button_grid:add_button(self.positions["exit"], button_size_big,
                                   self.button_1)

    -- Listeners and callbacks
    self:listen_to(
        event.remote_control,
        "button_release",
        utils.partial(self.press, self)
    )

    self:listen_to(
        self.button_grid,
        "submit",
        utils.partial(self._determine_new_state, self)
    )

    self:listen_to(
        self.button_grid,
        "navigation",
        utils.partial(self._check_match, self)
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
--  local card_index = self.button_grid.last_selection
--  self.button_grid:set_card_status(card_index, "FACING_UP")
-- Uses the last_selection variable as an index of the state in memory. checks if
-- the game is finished when opening the second card.
function MemoryView:_determine_new_state()
    local card_index = self.button_grid.last_selection
    if self.button_grid.button_list[card_index].button.status == nil
    or card_index > self.pairs * 2 then
        self:back_to_city()
        return
    end

    local card, is_open = self.memory:look(card_index)
    if self.memory.first_card == nil then
        if is_open ~= true then
            self.memory:open(card_index)
            self.button_grid:set_card_status(card_index, "FACING_UP")
        end
    elseif self.memory.second_card == nil then
        if is_open ~= true then
            self.memory:open(card_index)
            self.button_grid:set_card_status(card_index, "FACING_UP")
            self.memory:is_finished()
            self:dirty(true)
        end
    end
end


-- Used to check match between two open cards. Should be used to call match if
-- two cards are opened and the player has moved to another card.
function MemoryView:_check_match()
    if self.memory.second_card ~= nil then
        --self.memory:match()
        local is_matching = self.memory:match()
        if not is_matching then
            local state_map = self.memory.state
            self.button_grid:set_multiple_status(state_map)
        else
        end
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
        local turns_text = Font("data/fonts/DroidSans.ttf", 30, self.text_color)
        local turns = Font("data/fonts/DroidSans.ttf", 30, self.text_color)
        turns_text:draw(surface, {x = 100, y = 150}, "Turns")
        if self.memory.moves == nil then
            turns:draw(surface, {x = 100, y = 150}, "No turns...")
        else
            turns:draw(surface, {x = 100, y = 200}, tostring(self.memory.moves))
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
	local exp = self.profile:get_experience()
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

function MemoryView:destroy()
  print("in destroy")
  view.View.destroy(self)
  print("in destroy 2")
  -- for k,v in pairs(self.images) do
  --    self.images[k]:destroy()
  -- end
end

return MemoryView
