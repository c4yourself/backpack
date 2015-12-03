--- Base class for MemoryView
-- @classmod MemoryView

local class = require("lib.classy")
local View = require("lib.view.View")
local view = require("lib.view")
local event = require("lib.event")
local MemoryGame = require("lib.memory.Memory")
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
local PopUpView = require("views.PopUpView")
local SubSurface = require("lib.view.SubSurface")
local ExperienceCalculation = require("lib.scores.experiencecalculation")


--- Constructor for MemoryView
-- @param remote_control The remote control bound to the memory
-- @param surface The surface to draw the memory on
-- @param profile The current profile used in the application
function MemoryView:__init(remote_control, surface, profile)
    View.__init(self)
	event.remote_control:off("button_release") -- TODO remove this once the ViewManager is fully implemented
  self.surface = Surface

    -- Flags to determine whether a player has moved or pressed submit
	self.player_moved = false
	self.player_ok = false
	self.listening_initiated = false

    -- Logic
    self.cards = {}
    self.positions = {}

    self.button_grid = MemoryGrid(remote_control)
    self.profile = profile

    self:_set_pairs()
    --self.pairs = 6 -- TODO For quicker manual testing, remove once done coding
    self.memory = MemoryGame(self.pairs, self.profile)
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
        self.color_disabled, true, false, "views.PopUpView")
    self.positions["exit"] = {x = 100, y = 450}
    self.button_1:set_textdata("Back to City", self.text_color,
        {x = 100 + 65, y = 450 + 50 - 16}, 30,
        utils.absolute_path("data/fonts/DroidSans.ttf"))

    -- Create the button grid
    local card_color = color(250, 105, 0, 255)--color.from_html("fa6900ff")
    --color(0, 128, 225, 255)
    local card_color_disabled = color(111,222,111,255)
    local card_color_selected = color(250, 105, 0, 255)
    self.button_size = {width = 100, height = 100}
    local x_gap = self.button_size.width + 50
    local y_gap = self.button_size.height + 50

    self.pos_x = 450
    self.pos_y = 50

    for i = 1, self.pairs*2 do

        local current_city = self.profile.city
        self.cards[i]  = CardComponent(current_city, self.memory.cards[i], card_color,
        card_color_selected, card_color, true, false)

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
    self:focus()

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

    gfx.update()
    end



--- If user presses "back" key go back to CityView
-- @param key The key the user is pressing
function MemoryView:press(key)
    if key == "back" then
      local type = "confirmation"
      local message = {"Are you sure you want to exit?"}
      self:back_to_city(type, message)
    end
end

--- Connecting GUI with backend logic
function MemoryView:_determine_new_state()
    local card_index = self.button_grid.last_selection
    if self.button_grid.button_list[card_index].button.status == nil
    or card_index > self.pairs * 2 then
        local type = "confirmation"
        local message = {"Are you sure you want to exit?"}
        self:back_to_city(type, message)
        return
    end

    local card, is_open = self.memory:look(card_index)
    if self.memory.first_card == nil then
        if is_open ~= true then
            self.memory:open(card_index)
            self.button_grid:set_card_status(card_index, "FACING_UP")
            self:dirty(true)
        end
    elseif self.memory.second_card == nil then
        if is_open ~= true then
            self.memory:open(card_index)
            self.button_grid:set_card_status(card_index, "FACING_UP")
            self.memory:is_finished()
            self:dirty(true)
            if self.memory.finished == true then
              local counter  = {self.memory.moves, self.memory.pairs}
              local experience = ExperienceCalculation.Calculation(counter, "Memory")
              self.profile:modify_balance(experience)
              self.profile:modify_experience(experience)
              local message = {"You used " .. self.memory.moves .. " moves and received " .. experience .. " coins."}
              local type = "message"
              self:back_to_city(type, message)
            end

        end
    end
end


--- Checking match between two open cards.
function MemoryView:_check_match()
    if self.memory.second_card ~= nil then
        local is_matching = self.memory:match()
        if not is_matching then
            local state_map = self.memory.state
            self.button_grid:set_multiple_status(state_map)
        else
        end
    end
end


--- Renders MemoryView and all of its child views
-- @param surface The surface to render the MemoryView to
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
        surface:clear(color(0, 0, 0, 255):to_table())
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

--- Called when the user returns to the CityView
function MemoryView:back_to_city(type, message)

    local subsurface = SubSurface(screen,{width=screen:get_width()*0.5, height=(screen:get_height()-50)*0.5, x=screen:get_width()*0.25, y=screen:get_height()*0.25+50})
    local popup_view = PopUpView(remote_control,subsurface, type, message)
    self:add_view(popup_view)

    self.button_grid:blur()
    self:blur()

    local button_click_func = function(button)
      if button == "ok" then
      self:trigger("exit_view")
      else
      popup_view:destroy()
      self.button_grid:focus()
      self:focus()
      self:dirty(true)
      gfx.update()
    end
    end

    self:listen_to_once(popup_view, "button_click", button_click_func)
    popup_view:render(subsurface)
    gfx.update()
end

--- Function to set pairs accoriding to profile experience
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

--- Function to destroy MemoryView
function MemoryView:destroy()
    view.View.destroy(self)
end

function MemoryView:focus()
  self:listen_to(
      event.remote_control,
      "button_release",
      utils.partial(self.press, self)
  )
end

function MemoryView:blur()
  self:stop_listening(event.remote_control)
end

return MemoryView
