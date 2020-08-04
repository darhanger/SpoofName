local CharacterEvents = CreateFrame("frame");

local defaults = {
	ENABLED = false,
	CUSTOM_PLAYER_NAME = "Streaming"
}

CharacterEvents:RegisterEvent("PLAYER_ENTERING_WORLD");
CharacterEvents:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		if SPOOFNAME_CONFIG == nil then
			SPOOFNAME_CONFIG = defaults
		end
	end
end);

local LAST_CUSTOM_NAME = "";
local _, _, _, build = GetBuildInfo();
local PLAYER_NAME = UnitName("player");
local PLAYER_FULL_NAME;
if build > 50000 then
	local name, realm = UnitFullName("player")
	PLAYER_FULL_NAME = realm and name.."-"..realm or name;
else
	PLAYER_FULL_NAME = PLAYER_NAME;
end

local function InRaid()
	if build > 50000 then
		return IsInRaid()
	else
		return GetNumRaidMembers() > 0
	end
end

local function InGroup()
	if build > 50000 then
		return IsInGroup()
	else
		return GetNumPartyMembers() > 0
	end
end

local function SetCustomName(unit, fontString)
	if UnitIsUnit(unit, "player") then
		local text;
		if SPOOFNAME_CONFIG.ENABLED then
			text = SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME;
		else
			text = PLAYER_NAME;
		end
		fontString:SetText(text);
	end
end

local function Trigger_Frame_Updates()
	UnitFrame_Update(PlayerFrame, false);
	if UnitExists("target") then
		UnitFrame_Update(TargetFrame, false);
		if UnitExists("targettarget") then
			UnitFrame_Update(TargetFrameToT, false);		
		end
	end
	if UnitExists("focus") then
		UnitFrame_Update(FocusFrame, false);
		if UnitExists("focustarget") then
			UnitFrame_Update(FocusFrameToT, false);
		end
	end
	if build > 40000 then
		if (InRaid()) then
			for i = 1, 8 do
				local frame = _G["CompactRaidGroup"..i];
				if frame then
					local changed = false;
					for i2 = 1, 5 do
						local unit = _G[frame:GetName().."Member"..i2].unit;
						if unit and UnitIsUnit(unit, "player") then
							local name = _G[frame:GetName().."Member"..i2.."Name"];
							if name then
								local text = name:GetText();
								if SPOOFNAME_CONFIG.ENABLED then
									if text then
										name:SetText(SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME);
										changed = true;
										break;
									end
								else
									if text then
										name:SetText(PLAYER_NAME);
										changed = true;
										break;
									end
								end							
							end
						end
					end
					if changed then
						break;
					end
				end
			end
		else
			if InGroup() then
				for i = 1, 5 do
					local unit = _G["CompactPartyFrameMember"..i].unit;
					if unit and UnitIsUnit(unit, "player") then
						local name = _G["CompactPartyFrameMember"..i.."Name"];
						if name then
							local text = name:GetText();
							if SPOOFNAME_CONFIG.ENABLED then
								if text then
									name:SetText(SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME);
									break;
								end
							else
								if text then
									name:SetText(PLAYER_NAME);
									break;
								end
							end
						end
					end
				end
			end
		end
	end
end

if build > 50000 then
	hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
		SetCustomName(frame.unit, frame.name);
	end);
end

hooksecurefunc("UnitFrame_Update", function(frame, isParty)
	if frame.name then
		local unit = frame.overrideName or frame.unit;
		if UnitPlayerControlled(unit) and UnitIsFriend(unit, "player") then
			SetCustomName(unit, frame.name);
		end
	end
end);

hooksecurefunc("UnitFrame_OnEvent", function(frame, event, unit)
	if frame.name and event == "UNIT_NAME_UPDATE" and unit == frame.unit then
		if UnitPlayerControlled(unit) and UnitIsFriend(unit, "player") then
			SetCustomName(unit, frame.name);
		end
	end
end);

hooksecurefunc("GameTooltip_OnUpdate", function(self, elapsed)
	print("Tooltip udpate")
end);

CharacterEvents:SetScript("OnUpdate", function(self, elapsed)
	if SPOOFNAME_CONFIG.ENABLED then
		if CharacterFrame and not CharacterFrame.name_spoofed then
			local frame = build > 40000 and CharacterFrame.TitleText or CharacterNameText;
			if frame:GetText() ~= SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME then
				frame:SetText(SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME);
			end
			CharacterFrame:HookScript("OnUpdate", function(self, ...)
				local name = build > 40000 and self.TitleText or CharacterNameText;
				if SPOOFNAME_CONFIG.ENABLED then
					if name:GetText() ~= SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME then
						name:SetText(SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME);
					end
				else
					if name:GetText() ~= PLAYER_NAME then
						name:SetText(PLAYER_NAME);
					end
				end
			end);
			CharacterFrame.name_spoofed = true;
		end
		if GameTooltip and not GameTooltip.name_spoofed then
			GameTooltip:HookScript("OnUpdate", function(self, ...)
				if SPOOFNAME_CONFIG.ENABLED then
					if self:IsShown() then
						for i = 1, GameTooltip:NumLines() do
							local left = _G["GameTooltipTextLeft"..i]
							local left_text = left:GetText();
							if left_text and left_text:find(PLAYER_NAME) then
								left:SetText(gsub(left_text, PLAYER_NAME, SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME));
							end
							local right = _G["GameTooltipTextRight"..i]
							local right_text = right:GetText();
							if right_text and right_text:find(PLAYER_NAME) then
								right:SetText(gsub(right_text, PLAYER_NAME, SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME));
							end
						end
					end
				end
			end);
			GameTooltip.name_spoofed = true;
		end
		if WorldStateScoreFrame and not WorldStateScoreFrame.name_spoofed then
			WorldStateScoreFrame:HookScript("OnUpdate", function(self, ...)
				if SPOOFNAME_CONFIG.ENABLED then
					for i = 1, GetNumBattlefieldScores() do
						local name = _G["WorldStateScoreButton"..i.."NameText"];
						if name then
							text = name:GetText();
							if text and ((LAST_CUSTOM_NAME ~= "" and text:find(LAST_CUSTOM_NAME)) or text:find(PLAYER_NAME)) then
								name:SetText(SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME);
							end
						end
					end
				end
			end);
			WorldStateScoreFrame.name_spoofed = true;
		end
		if build > 40000 then
			if GuildRosterContainer and not GuildRosterContainer.name_spoofed then
				GuildRosterContainer:HookScript("OnUpdate", function(self, ...)
					local buttons = _G["GuildRosterContainer"].buttons
					for i = 1, #buttons do
						local name = _G["GuildRosterContainerButton"..i.."String2"];
						if name then
							local text = name:GetText()
							if text then
								if SPOOFNAME_CONFIG.ENABLED then
									if text:find(PLAYER_NAME) or (LAST_CUSTOM_NAME ~= "" and text:find(LAST_CUSTOM_NAME)) then
										name:SetText(SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME);
									end
								else
									if text:find(SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME) or (LAST_CUSTOM_NAME ~= "" and text:find(LAST_CUSTOM_NAME)) then
										name:SetText(PLAYER_NAME);
									end
								end
							end
						end
					end
				end);
				GuildRosterContainer.name_spoofed = true;
			end
		else
			if GuildFrame and not GuildFrame.name_spoofed then
				GuildFrame:HookScript("OnUpdate", function(self, ...)
					for i = 1, GUILDMEMBERS_TO_DISPLAY do
						local name = _G["GuildFrameButton"..i.."Name"];
						if name then
							local text = name:GetText();
							if text then
								if SPOOFNAME_CONFIG.ENABLED then
									if text:find(PLAYER_NAME) or (LAST_CUSTOM_NAME ~= "" and text:find(LAST_CUSTOM_NAME)) then
										name:SetText(SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME);
									end
								else
									if text:find(SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME) or (LAST_CUSTOM_NAME ~= "" and text:find(LAST_CUSTOM_NAME)) then
										name:SetText(PLAYER_NAME);
									end
								end
							end
						end
					end
				end);
				GuildFrame.name_spoofed = true;
			end
			if RaidFrame and not RaidFrame.name_spoofed then
				RaidFrame:HookScript("OnUpdate", function(self, ...)
					for i = 1, MAX_RAID_MEMBERS do
						local button = _G["RaidGroupButton"..i];
						if button and button.unit and UnitIsUnit(button.unit, "player") then
							local name = button.subframes and button.subframes.name or nil;
							if name then
								if SPOOFNAME_CONFIG.ENABLED then
									if name:GetText() ~= SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME then
										name:SetText(SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME);
									end
								else
									if name:GetText() ~= PLAYER_NAME then
										name:SetText(PLAYER_NAME);
									end
								end
							end
						end
					end
				end);
				RaidFrame.name_spoofed = true;
			end
			for BTN_INDEX = 1, 8 do
				local pullout = _G["RaidPullout"..BTN_INDEX];
				if pullout and not pullout.name_spoofed then
					pullout:HookScript("OnUpdate", function(self, ...)
						for i = 1, 5 do
							local button = _G[pullout:GetName().."Button"..i];
							if button and UnitIsUnit(button.unit, "player") then
								local name = button.nameLabel;
								if name then
									if SPOOFNAME_CONFIG.ENABLED then
										if name:GetText() ~= SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME then
											name:SetText(SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME);
										end
									else
										if name:GetText() ~= PLAYER_NAME then
											name:SetText(PLAYER_NAME);
										end
									end
								end
							end
						end
					end);
					pullout.name_spoofed = true;
				end
			end
		end
		if GuildMemberDetailFrame and not GuildMemberDetailFrame.name_spoofed then
			GuildMemberDetailFrame:HookScript("OnUpdate", function(self, ...)
				local member_name = GuildMemberDetailName:GetText();
				if member_name then
					if SPOOFNAME_CONFIG.ENABLED then
						if member_name:find(PLAYER_NAME) then
							GuildMemberDetailName:SetText(gsub(member_name, PLAYER_NAME, SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME));
						elseif LAST_CUSTOM_NAME ~= "" and member_name:find(LAST_CUSTOM_NAME) then
							GuildMemberDetailName:SetText(gsub(member_name, LAST_CUSTOM_NAME, SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME));
						end
					else
						if member_name:find(SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME) then
							GuildMemberDetailName:SetText(gsub(member_name,SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME, PLAYER_NAME));
						elseif LAST_CUSTOM_NAME ~= "" and member_name:find(LAST_CUSTOM_NAME) then
							GuildMemberDetailName:SetText(gsub(member_name,LAST_CUSTOM_NAME, PLAYER_NAME));
						end
					end
				end
			end);
			GuildMemberDetailFrame.name_spoofed = true;
		end
	end
end);

local function ChatFilter(self, event, msg, author, ...)
	if SPOOFNAME_CONFIG.ENABLED then
		if event == "CHAT_MSG_SYSTEM" then
			if msg:find(PLAYER_NAME) then
				return false, gsub(msg, PLAYER_NAME, SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME), author, ...
			end
		elseif event == "CHAT_MSG_AFK" then
			if msg:find(PLAYER_NAME) then
				if author ~= PLAYER_FULL_NAME then
					return false, gsub(msg, PLAYER_NAME, SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME), author, ...
				elseif author == PLAYER_FULL_NAME then
					return false, gsub(msg, PLAYER_NAME, SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME), SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME, ...
				end
			end
		else
			if author == PLAYER_FULL_NAME then
				return false, msg, SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME, ...
			end
		end
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_ACHIEVEMENT", ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND_LEADER", ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ACHIEVEMENT", ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", ChatFilter);

SLASH_SPOOFNAME1 = "/spoofname"
SLASH_SPOOFNAME2 = "/sn"
SlashCmdList["SPOOFNAME"] = function(msg)
	if msg == "on" then
		SPOOFNAME_CONFIG.ENABLED = true;
		SetCVar("UnitNameOwn",0);
		SetCVar("UnitNameFriendlyPlayerName",0);
		print("|cFFFFE133SpoofName: |cFF00FF00Enabled");
		Trigger_Frame_Updates();
	elseif msg == "off" then
		SPOOFNAME_CONFIG.ENABLED = false;
		SetCVar("UnitNameOwn",1);
		SetCVar("UnitNameFriendlyPlayerName",1);
		print("|cFFFFE133SpoofName: |cFFFF0000Disabled");
		Trigger_Frame_Updates();
	elseif msg ~= "" then
		LAST_CUSTOM_NAME = SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME;
		SPOOFNAME_CONFIG.CUSTOM_PLAYER_NAME = msg;
		print("|cFFFFE133SpoofName set to the name: |cFF33FFFC"..msg);
		if SPOOFNAME_CONFIG.ENABLED then
			Trigger_Frame_Updates();
		end
	elseif msg == "" or msg == "help" then
		print("|cFFFFE133The commands for SpoofName are as follows:");
		print("|cFFFFFFFF\"|cFF33FFFC/spoofname on|cFFFFFFFF\"|cFFFFE133 - this enables the addon");
		print("|cFFFFFFFF\"|cFF33FFFC/spoofname off|cFFFFFFFF\"|cFFFFE133 - this disables the addon");
		print("|cFFFFFFFF\"|cFF33FFFC/spoofname <string>|cFFFFFFFF\"|cFFFFE133 -replace <string> with the name you want to display");
		print("|cFFFFE133SpoofName can be ran with |cFF33FFFC/spoofname |cFFFFE133or |cFF33FFFC/sn");
	end
end