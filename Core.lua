--todo slash command for connfiguration, to change title
--todo fubar integration
--todo when a new title is gained update the list of available title
--todo make an option to enable/disable including no title
RandomTitle = LibStub("AceAddon-3.0"):NewAddon("RandomTitle", "AceConsole-3.0", "AceEvent-3.0")

local options = 
{
    name = "RandomTitle",
    handler = RandomTitle,
    type = 'group',
    args = 
    {
    },
}

local availableTitles = {}

function RandomTitle:OnInitialize()
    --called when the addon is loaded
	--self:Print("In OnInitialize")
end

--called when the addon is enabled
function RandomTitle:OnEnable()
    --self:Print("In OnEnable")
	--used this event instead of PLAYER_LOGIN to cause the title to change more frequently
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	--self:RegisterEvent("PLAYER_LOGIN")
	
	--title management events
	self:RegisterEvent("NEW_TITLE_EARNED")
    self:RegisterEvent("OLD_TITLE_LOST")

    self:LoadTitles()
end

--Fired when the player enters the world, enters/leaves an instance, or respawns at a graveyard.
--Also fires any other time the player sees a loading screen. 
function RandomTitle:PLAYER_ENTERING_WORLD()
	--self:Print("Caught PLAYER_ENTERING_WORLD")
	self:SetTitle(nil)
end

--Triggered immediately before PLAYER_ENTERING_WORLD on login and UI Reload, but NOT when entering/leaving instances. 
function RandomTitle:PLAYER_LOGIN()
	--self:Print("Caught PLAYER_LOGIN")
    self:SetTitle(nil)
end

--not sure when this is called but my hunch is that it is called when you... earn a new title.
function RandomTitle:NEW_TITLE_EARNED()
	--self:Print("Caught NEW_TITLE_EARNED")
	
	--self:LoadTitles()
end

--again, not sure when this is fire, but guessing it's when you lose a title
--like, when blizz assigns/removes the arena titles
function RandomTitle:OLD_TITLE_LOST()
	--self:Print("Caught OLD_TITLE_LOST")
	
	--self:LoadTitles()
end

function RandomTitle:OnDisable()
    --called when the addon is disabled
end

--loads the titles available to the player
function RandomTitle:LoadTitles()
	local index = 0
    for i = 1, GetNumTitles() do
		if IsTitleKnown(i) == 1 then 
	    	self:Print("Adding titleid "..i.." to available titles at index "..index)
	    	availableTitles[index] = i
	    	index = index + 1
		end
    end

    self:Print("Loaded "..#availableTitles.." titles")
end

--sets the players current title to a random title available
function RandomTitle:SetTitle(info)
    --get a random number
    local randOffset = math.random(-1, #availableTitles)

    --self:Print("Got random number "..randOffset)

    --set the new title
    if randOffset == -1 then
		-- -1 means that we blank out the title
		SetCurrentTitle(-1)
    else
		--self:Print("Changing title to "..GetTitleName(availableTitles[randOffset]))
		SetCurrentTitle(availableTitles[randOffset])
    end
end