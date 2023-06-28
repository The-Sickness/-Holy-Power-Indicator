if select(2, UnitClass("player")) ~= "PALADIN" and select(2, UnitClass("player")) ~= "ROGUE" and select(2, UnitClass("player")) ~= "DRUID" then
	print("You are not playing a supported class.")
	print("Holy Power Indicator disabled.")
	return DisableAddOn("HolyPowerIndicator")
end

HolyPowerIndicator = LibStub("AceAddon-3.0"):NewAddon("HolyPowerIndicator", "AceEvent-3.0")

local textures = {
		["number"] = {
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\number_1",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\number_2",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\number_3",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\number_4",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\number_5",			
		},
		["alliance"] = {
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\alliance_1",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\alliance_2",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\alliance_3",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\alliance_4",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\alliance_5",
			},
		["blizzard"] = {
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\blizzard_1",			
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\blizzard_2",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\blizzard_3",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\blizzard_4",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\blizzard_5",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\blizzard_0",
			},			
		["horde"] = {
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\horde_1",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\horde_2",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\horde_3",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\horde_4",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\horde_5",
		},
		["dot"] = {
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\dot_1",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\dot_2",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\dot_3",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\dot_4",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\dot_5",
		},
		["bar"] = {
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\bar_1",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\bar_2",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\bar_3",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\bar_4",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\bar_5",
		},
		["pvprank"] = {
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\pvprank_1",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\pvprank_2",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\pvprank_3",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\pvprank_4",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\pvprank_5",
		},
		["tukbar"] = {
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\tukbar_1",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\tukbar_2",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\tukbar_3",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\tukbar_4",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\tukbar_5",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\tukbar_0",
		},
		["roguecombopoints"] = {
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\roguecombopoints_1",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\roguecombopoints_2",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\roguecombopoints_3",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\roguecombopoints_4",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\roguecombopoints_5",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\roguecombopoints_6",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\roguecombopoints_7",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\roguecombopoints_8",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\roguecombopoints_9",			
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\roguecombopoints_10",
			"Interface\\AddOns\\HolyPowerIndicator\\Images\\roguecombopoints_0",
		},
}

do
	local frame = CreateFrame("Frame", "HolyPowerIndicatorFrame", UIParent)
	frame:SetMovable(true)
	frame:SetUserPlaced(true)
	frame:SetPoint("CENTER")
	frame:SetWidth(128)
	frame:SetHeight(128)

	local texture = frame:CreateTexture(nil, "ARTWORK")
	texture:SetAllPoints(frame)

	HolyPowerIndicator.frame = frame

	frame.texture = texture
	local combopoints
	if 	select(2, UnitClass("player")) == "PALADIN" then
		hpimode = "power"
		--print("hpimode = power")
	elseif  select(2, UnitClass("player")) ~= "ROGUE" then
		hpimode = "combo"
		--print("hpimode = combo")
	elseif  select(2, UnitClass("player")) ~= "DRUID" then
		hpimode = "combo"
		--print("hpimode = combo")
	else
		hpimode = "failed"
		--print("hpimode failed")
	end
end

function HolyPowerIndicator:OnInitialize()
	local defaults = {
		profile = {
			locked = true,
			alpha = 1,
			scale = 1,
			showonlyincombat = false,
			showwhenzero = false,
			textureSelect = "tukbar",
		},
	}

	self.db = LibStub("AceDB-3.0"):New("HolyPowerIndicatorDB", defaults, "Default")

	local options = {
		name = "HolyPowerIndicator",
		type ="group",
		args = {
			descr = {
				type = "description",
				order = 1,
				name = " Simple Holy Power monitor that shows you how many charges you have. \n\n Rogue and Duid Combo Points ONLY in default texture.\n\n /hpi to open options frame. \n /hpi lock to lock/unlock frame \n",

			},
			locked = {
				type = "toggle",
				name = "Lock frame",
				desc = "Locks the Holy Power frame in place.",
				width = "full",
				order = 2,
				get = function() return HolyPowerIndicator.db.profile.locked end,
				set = function(_, value)
						HolyPowerIndicator.db.profile.locked = value
						HolyPowerIndicator:ToggleFrameLock(value)
					end,
			},
			--[[showonlyincombat = {
				type = "toggle",
				name = "Only show during combat",
				desc = "When enabled: Only shows the frame when in combat", --Hides the frame while not in combat.
				width = "full",
				order = 3,
				get = function() return HolyPowerIndicator.db.profile.showonlyincombat end,
				set = function(_, value)
						HolyPowerIndicator.db.profile.showonlyincombat = value
					end,
			},		
			showwhenzero = {
				type = "toggle",
				name = "Show with 0 Holy-Power or [Combat-Points",
				desc = "When enabled: Als shows the frame with 0 Holy Power or Combat Points", --Hides the frame while not in combat.
				width = "full",
				order = 4,
				get = function() return HolyPowerIndicator.db.profile.showwhenzero end,
				set = function(_, value)
						HolyPowerIndicator.db.profile.showwhenzero = value
					end,--
			},				]]	
			alpha = {
				type = "range",
				name = "Frame opacity",
				desc = "Set the frame's opacity.",
				width = "normal",
				min = 0.1,
				max = 1,
				step = 0.1,
				order = 6,
				get = function() return HolyPowerIndicator.db.profile.alpha end,
				set = function(_, value) 
						HolyPowerIndicator.db.profile.alpha = value
						HolyPowerIndicator.frame:SetAlpha(value)
					end,
			},
			scale = {
				type = "range",
				name = "Frame scale",
				desc = "Set the frame's scale.",
				width = "normal",
				min = 0.2,
				max = 5,
				step = 0.2,
				order = 7,
				get = function() return HolyPowerIndicator.db.profile.scale end,
				set = function(_, value) 
						HolyPowerIndicator.db.profile.scale = value
						HolyPowerIndicator.frame:SetScale(value) 
					end,
			},
			textureSelect = {
				type = "select",
				name = "Texture",
				desc = "Select the texture.",
				order = 8,
				width = "normal",
				values = {
					["blizzard"] = "Blizzard",
					["alliance"] = "Alliance",
					["horde"] = "Horde",					
					["bar"] = "Bar",
					["dot"] = "Dot",
					["number"] = "Number",
					["pvprank"] = "PvP Rank",
					["tukbar"] = "TukBar",
					["roguecombopoints"] = "CombatPoints",
				},
				get = function() return HolyPowerIndicator.db.profile.textureSelect end,
				set= function(_, value) 
						HolyPowerIndicator.db.profile.textureSelect = value
						ReloadUI();
					end,
			},
			descr2 = {
				type = "description",
				order = 9,
				name = " \n IMPORTANT: Changing textures will reload your User Interface.\n",
			},
			descr3 = {
				type = "description",
				order = 5,
				name = " \n Only works with textures Blizzard, Tukbar, Number and ComboPoints",
			},
		},
	}

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("HolyPowerIndicator", options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("HolyPowerIndicator", "HolyPowerIndicator")

	PaladinPowerBarFrame:SetAlpha(0)
	
	self.frame:SetAlpha(self.db.profile.alpha)
	self.frame:SetScale(self.db.profile.scale)
	self:ToggleFrameLock(self.db.profile.locked)
	
	SLASH_HOLYPOWERINDICATOR1 = "/hpi"
	SlashCmdList["HOLYPOWERINDICATOR"] = function(msg)
		if msg == "lock" then
			self:ToggleFrameLock()
		else
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
		end
	end

	self:RegisterEvent("UNIT_POWER_UPDATE")
	
	if select(2, UnitClass("player")) == "ROGUE" or  select(2, UnitClass("player")) == "DRUID" then
	self:RegisterEvent("UNIT_COMBO_POINTS")
	self:RegisterEvent("UNIT_AURA")
	end

	--self:RegisterEvent("PLAYER_REGEN_ENABLED")
	--self:RegisterEvent("PLAYER_REGEN_DISABLED")
	--self.PLAYER_ENTERING_WORLD = self.PLAYER_REGEN_ENABLED -- Update on looading screen to clear after battlegrounds

end

function HolyPowerIndicator:ToggleFrameLock(value)
	if value == nil then
		value = self.db.profile.locked
		-- #p rint("function success")
			if value then
				value = false
			else 
				value = true
			end
	end
		-- # print(value)
		
	local frame = self.frame

	if value then
		
		frame:EnableMouse(false)
		frame:RegisterForDrag(nil)
		frame:SetScript("OnDragStart", nil)
		frame:SetScript("OnDragStop", nil)
		
		-- # Hide the frame at power = 0 
		if UnitPower("player", 9) == 0 then
			frame:Hide()
			print("HolyPowerIndicator locked")
		end

	else

		frame:EnableMouse(true)
		frame:RegisterForDrag("LeftButton")
		frame:SetScript("OnDragStart", frame.StartMoving)
		frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
		if UnitPower("player", 9) == 0 then
			frame.texture:SetTexture(textures[self.db.profile.textureSelect][5])
			frame:Show()
			print("HolyPowerIndicator unlocked")
		end
	end

	self.db.profile.locked = value
end

function HolyPowerIndicator:UNIT_POWER_UPDATE(event, unit, powerType)
		local power = UnitPower("player", 9)
	if unit == "player" and powerType == "HOLY_POWER" then
		if power > 0 then
			self.frame.texture:SetTexture(textures[self.db.profile.textureSelect][power])
			self.frame:Show()
		else
			self.frame:Hide()
		end
	end
end

function HolyPowerIndicator:UNIT_AURA(event,unit)
	if unit == "player" then
		local anticipation = 0
		_,_,_,anticipation = UnitBuff("player", GetSpellInfo(114015), nil)
		if anticipation then
			--print("Combo Point added - Anticipation - now at: ",anticipation)
		else
			anticipation = 0
		end
		if not combopoints then combopoints = 0 end
		if anticipation > 0 then
			self.frame.texture:SetTexture(textures["roguecombopoints"][5+anticipation])
			self.frame:Show()
		elseif anticipation == 0 and combopoints > 0 then
			self.frame.texture:SetTexture(textures["roguecombopoints"][combopoints])
			self.frame:Show()		
		else
			--print("hidde by unitaura")
			self.frame:Hide()
		end
	end
end

function HolyPowerIndicator:UNIT_COMBO_POINTS(event, unit)
	if unit == "player" then
		if not combopoints then combopoints = 0 end
		if UnitCanAttack("player","target") then
			combopoints = GetComboPoints("player","target")
		elseif combopoints >0 then
			combopoints = combopoints-1
		end
		
		--print("Combo Point added - Combo - now at: ",combopoints, " hpimode: ",hpimode)
		if combopoints > 0 then
			if hpimode == "combo" then
				self.frame.texture:SetTexture(textures["roguecombopoints"][combopoints])
			else
				self.frame.texture:SetTexture(textures[self.db.profile.textureSelect][combopoints])
			end
			self.frame:Show()
		else
			--print("hidde by combopoints")
			self.frame:Hide()
		end
	end
end
--[[
function HolyPowerIndicator:PLAYER_REGEN_ENABLED(self, value)
	if value ~= nil then
		value = self.db.profile.showonlyincombat
	end
		print(value)
	
end

function HolyPowerIndicator:PLAYER_REGEN_DISABLED(self, value)
	if value ~= nil then
		value = self.db.profile.showonlyincombat
	end
		print(value)
	
end --]]