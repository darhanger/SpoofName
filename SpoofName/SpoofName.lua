local NewName, OldName = UnitName("player")
local Fake_Frame
local Spoof_Enabled, Spoof_ModulesIsEnabled, Spoof_TimeForOffModules = false, false, GetTime()
Spoof_Blocks = {}

function CheckLocalization()
	if GetLocale() == "ruRU" then
		print("|cffFFFF00Имя персонажа изменено на: |c0000CED1"..NewName.."|r.")
	else
		print("|cffFFFF00Character name changed to: |c0000CED1"..NewName.."|r.")
	end
end

function EnableAddon(arg)
	if arg == "DevMenu" then
		Open_Spoof_Menu()
		return nil
	end
	OldName = NewName
	NewName = UnitName("player")
	if arg ~= "" then
		NewName = arg
		Spoof_Enabled = true
	end
	CheckLocalization()
	if NewName == UnitName("player") then
		Spoof_TimeForOffModules = GetTime() + 2
	end
	if not ModulesIsEnabled then
		Spoof_ModulesIsEnabled()
	end
end
SlashCmdList["EnableAddon"] = EnableAddon
SLASH_EnableAddon1 = "/spoof"

function Spoof_ModulesIsEnabled()
	ModulesIsEnabled = true
	Spoof_Add_Caption("Основные фреймы")
	Spoof_Blocks["os"] = 1 			Spoof_Add_CheckBox("Основные фреймы", "Ник в нашем таргете/таргеттаргете/фокусе + наш в углу экрана", "os")
	Spoof_Blocks["guild"] = 1		Spoof_Add_CheckBox("Гильдия", "Наш ник в гильдии", "guild")
	Spoof_Blocks["raid"] = 1		Spoof_Add_CheckBox("Фрейм рейда", "Ник в разделе рейд", "raid")
	Spoof_Blocks["blizz"] = 1 		Spoof_Add_CheckBox("Фреймы близов", "Ник в дэфолтных фреймах близов", "blizz")
	Spoof_Blocks["tooltip"] = 1		Spoof_Add_CheckBox("Игровой тултип", "Все игровые тултипы дэфолтные", "tooltip")
	Spoof_Blocks["drdwnmn"] = 1		Spoof_Add_CheckBox("ДропДаун меню", "Менюшки от пкмов по портретам", "drdwnmn")
	Spoof_Add_Caption("Рейдовые аддоны")
	Spoof_Blocks["Recount"] = 1  	Spoof_Add_CheckBox("Рекаунт", "Рекаунт", "Recount")
	Spoof_Blocks["Skada"] = 1 		Spoof_Add_CheckBox("Скада", "Скада", "Skada")
	Spoof_Blocks["HealBot"] = 1 	Spoof_Add_CheckBox("Хилбот", "Хилбот", "HealBot")
	Spoof_Blocks["Greed"] = 1		Spoof_Add_CheckBox("Грид", "Грид", "Greed")
	Spoof_Blocks["VuhDo"] = 1 		Spoof_Add_CheckBox("Вуду", "Вуду", "VuhDo")
	Spoof_Blocks["Omen"] = 1		Spoof_Add_CheckBox("Омен", "Омен", "Omen")
	Spoof_Blocks["DBM"] = 1 		Spoof_Add_CheckBox("дбм(полоски)", "Те что сбоку типо кто-то геру нажал, или обосрался, пишется там таймер, те полоски короч", "DBM")
	Spoof_Blocks["RCA"] = 1  		Spoof_Add_CheckBox("Рейдкулдаунаддон", "Рейдкулдаунаддон", "RCA")
	Spoof_Add_Caption("Костыли")
	Spoof_Blocks["ann"] = 1 		Spoof_Add_CheckBox("Анонсы посреди экрана", "Всякие анонсы от боссов/дбмов и прочего(может снижать фпсы кста)", "ann")
	Spoof_Blocks["ch"] = 1			Spoof_Add_CheckBox("Весь чат", "Весь чат где есть наш ник, меняем на фейк, кроме того где мы отправляем чёто, там по дэфолту фейковый летит(кста тоже может фпсы резать)", "ch")
	Spoof_Add_Caption("Фреймы других аддонов")
	Spoof_Blocks["ElvUI"] = 1 		Spoof_Add_CheckBox("ElvUI", "Целиком этот аддон и полная работа с ним", "ElvUI")
	
	NameOnHead() -- Ник над башкой
	SearchAllMyNames() -- Ник в нашем таргете/таргеттаргете/фокусе + наш в углу экрана
	GuildFrameAllRename() -- Наш ник в гильдии
	RenameHideRaidFrameOverviewName() -- Ник в разделе "рейд"
	FakeFrameInHero() -- Ник в меню осмотра персонажа
	RenameDefoultRaidFrameBlizz() -- Ник в дэфолтных фреймах близов
	RenameAllGameTooptip() -- Игровой тултип
	RenameAllDropDown() -- ДропДаунМенюшки
	ChangeNickOnRecount() -- Ник в рекаунте
	SkadaAddonDlyaDaunov() -- Ник в скаде
	HealBotRename() --  Хилбот
	GridRename() -- Грид
	VuhDoRenameAllMyName() -- Вуду
	RenameOmenBlaBlaBla() -- Омен
	DBMStrings() -- Полосы дбма
	RaidCooldownAddonRename() -- Рейдкулдаунаддон
	DBMandAllAnnounceRename() -- Анонсы посреди экрана
	FindMyNickChatAndHide() -- перебираем наш чат и ищем наш ник
	ElvUINeOkAdonDlyaAnimeshnikov() -- хз как работает, но я старался(нет, не старался, сами делайте)
	UIParent:HookScript("OnUpdate", function()
		if Spoof_TimeForOffModules < GetTime() and NewName == UnitName("player") then
			Spoof_Enabled = false
		end
	end)
end

function FakeFrameInHero()
	if not Fake_Frame then
		Fake_Frame = CreateFrame("Frame", "CharacterNameFrameFakeNewName", CharacterFrame)
		Fake_Frame:SetHeight(CharacterNameFrame:GetHeight()); 
		Fake_Frame:SetWidth(CharacterNameFrame:GetWidth());
		Fake_Frame:SetPoint(CharacterNameFrame:GetPoint());
		Fake_Frame.text = Fake_Frame:CreateFontString(nil,"ARTWORK") 
		Fake_Frame.text:SetFont("Fonts\\ARIALN.ttf", 13.5, "OUTLINE")
		Fake_Frame.text:SetPoint("CENTER")
		Fake_Frame:Hide()
	end
	Fake_Frame.text:SetText(NewName)
	CharacterNameFrame:Show()
	Fake_Frame:Hide()
	if NewName ~= UnitName("player") then
		CharacterNameFrame:Hide()
		Fake_Frame:Show()
	end
end

function GuildFrameAllRename()
	if GuildFrame then	
		GuildFrame:HookScript("OnUpdate", function()
	if GuildFrame:IsShown() and Spoof_Enabled and Spoof_Blocks["guild"] then
			local Ch = {GuildFrame:GetChildren()} 
			for j = 1, #Ch do 
				local t = {Ch[j]:GetChildren()} 
				for k = 1, #t do
					local qr = {t[k]:GetRegions()}
					for i = 1, #qr do 
						if qr[i]:GetObjectType() == "FontString" and qr[i]:GetText() then 
							if qr[i]:GetText() 
							 and (string.find(qr[i]:GetText(), UnitName("player")) 
							 or string.find(qr[i]:GetText(), OldName)) then
								qr[i]:SetText(NewName)
							end
						end 
					end 
				end
			end
	end	
		end)
	end
	if GuildMemberDetailFrame then
		GuildMemberDetailFrame:HookScript("OnUpdate", function()
	if GuildMemberDetailFrame:IsShown() and Spoof_Enabled and Spoof_Blocks["guild"] then	
			local TT = {GuildMemberDetailFrame:GetRegions()} 
			for i = 1, #TT do 
				if TT[i]:GetObjectType() == "FontString" then 
					if TT[i]:GetText() 
					 and (string.find(TT[i]:GetText(), UnitName("player")) 
					 or string.find(TT[i]:GetText(), OldName)) then
						TT[i]:SetText(NewName)
					end
				end 
			end
	end
		end)
	end
end

function RenameHideRaidFrameOverviewName()
	if RaidFrame then
		RaidFrame:HookScript("OnUpdate", function()
	if RaidFrame:IsShown() and Spoof_Enabled and Spoof_Blocks["raid"] then	
			for i=1,40 do 
				local currentFrame = _G["RaidGroupButton"..i.."Name"] 
				if currentFrame then
					local currentName = currentFrame:GetText(); 
					if currentName == UnitName("player") then
						currentFrame:SetText(NewName)
					end
				end 
			end
	end
		end) 
		FriendsFrame:Hide()
	end
end

function SearchAllMyNames()
	if PlayerFrame then
		PlayerFrame.name:SetText(NewName)
		PlayerFrame:HookScript("OnUpdate", function()
			if PlayerFrame.name:GetText() == UnitName("player") 
			and Spoof_Enabled and Spoof_Blocks["os"] then
				PlayerFrame.name:SetText(NewName)
			end
		end)
	end
	if TargetFrame then
		TargetFrame.name:SetText(NewName)
		TargetFrame:HookScript("OnUpdate", function()
			if TargetFrame.name:GetText() == UnitName("player") 
			and Spoof_Enabled and Spoof_Blocks["os"] then
				TargetFrame.name:SetText(NewName)
			end
		end)
	end
	if FocusFrame then
		FocusFrame.name:SetText(NewName)
		FocusFrame:HookScript("OnUpdate", function()
			if FocusFrame.name:GetText() == UnitName("player") 
			and Spoof_Enabled and Spoof_Blocks["os"] then
				FocusFrame.name:SetText(NewName)
			end
		end)
	end
	if TargetFrameToT then
		TargetFrameToT.name:SetText(NewName)
		TargetFrameToT:HookScript("OnUpdate", function()
			if TargetFrameToT.name:GetText() == UnitName("player") 
			and Spoof_Enabled and Spoof_Blocks["os"] then
				TargetFrameToT.name:SetText(NewName)
			end
		end)
	end
end

function RenameDefoultRaidFrameBlizz() -- Need to test
	if UIParent then
		UIParent:HookScript("OnUpdate", function()
		if Spoof_Enabled and Spoof_Blocks["blizz"] then
			for i = 1, 8 do
				if _G["RaidPullout"..i] then
					if _G["RaidPullout"..i]:IsShown() then
						for j = 1, 5 do
							if _G["RaidPullout"..i.."Button"..j] then
								local TT = {_G["RaidPullout"..i.."Button"..j]:GetRegions()}
								if TT[1]:GetText() == UnitName("player") or TT[1]:GetText() == OldName then
									TT[1]:SetText(NewName)
								end
							end
						end
					end
				end
			end
		end	
		end)
	end
end

function ChangeNickOnRecount()
	if Recount_MainWindow then
		Recount_MainWindow:HookScript("OnUpdate", function()
		if Spoof_Enabled and Spoof_Blocks["Recount"] then
			for i = 1, 30 do
				if _G["Recount_MainWindow_Bar"..i] then
					if _G["Recount_MainWindow_Bar"..i].LeftText:GetText() == (i..". "..UnitName("player")) or _G["Recount_MainWindow_Bar"..i].LeftText:GetText() == (i..". "..OldName) then
						_G["Recount_MainWindow_Bar"..i].LeftText:SetText(i..". "..NewName)
					end
				end
			end
		end	
		end)
	end
	local frames = {"Recount_DetailWindow", "Recount_GraphWindow", }
	for i=1,#frames do
		if _G[frames[i]] then
			_G[frames[i]]:HookScript("OnUpdate", function ()
				if _G[frames[i]]:IsShown() and Spoof_Enabled and Spoof_Blocks["Recount"] then
					theTitle = _G[frames[i]].Title:GetText()
					_G[frames[i]].Title:SetText("")
					newTitle = string.gsub(theTitle, UnitName("player"), NewName)
					_G[frames[i]].Title:SetText(newTitle)
				end
			end)
		end
	end
end

function SkadaAddonDlyaDaunov()
	if SkadaBarWindowSkada then
		SkadaBarWindowSkada:HookScript("OnUpdate", function()
		if Spoof_Enabled and Spoof_Blocks["Skada"] then
			local Ch = {SkadaBarWindowSkada:GetChildren()}
			for j = 1, #Ch do
				local t = {Ch[j]:GetRegions()}
				for i = 1, #t do 
					if t[i]:GetObjectType() == "FontString" then 
						if t[i]:GetText() then
							local pos = string.find(t[i]:GetText(), UnitName("player"))
							if not pos then
								pos = string.find(t[i]:GetText(), OldName)
							end
							if pos then	
								if string.find(t[i]:GetText(), UnitName("player")) ~= 1 then
									local NewTextForSkada = string.sub(t[i]:GetText(), 1 , pos - 2).." "..NewName
									t[i]:SetText(NewTextForSkada)
								else
									local NewTextForSkada = NewName.." "..string.sub(t[i]:GetText(), string.find(t[i]:GetText(), "-"), #t[i]:GetText())
									t[i]:SetText(NewTextForSkada)
								end
							end
						end
					end 
				end
			end
		end	
		end)
	end
end

function RenameAllGameTooptip()
	if GameTooltip then
		GameTooltip:HookScript("OnUpdate", function()
	if GameTooltip:IsShown() and Spoof_Enabled and Spoof_Blocks["tooltip"] then
			local t = {GameTooltip:GetRegions()}
			for i = 1, #t do
				UniversalRenameTool_1(t[i])
			end
	end
		end)
	end
end

function RenameAllDropDown()
	if DropDownList1 then
		DropDownList1:HookScript("OnUpdate", function()
	if DropDownList1:IsShown() and Spoof_Enabled and Spoof_Blocks["drdwnmn"] then
			if DropDownList1Button1:GetText() == UnitName("player") or DropDownList1Button1:GetText() == OldName then
				DropDownList1Button1:SetText(NewName)
			end
	end
		end)
	end
end

function NameOnHead()
	InterfaceOptionsFrame:Show()
	if InterfaceOptionsNamesPanelMyName:GetChecked() then
		InterfaceOptionsNamesPanelMyName:Click()
	end
	if InterfaceOptionsFrame then
		InterfaceOptionsFrame:HookScript("OnUpdate", function()
			if PlayerFrame.name:GetText() ~= UnitName("player") then
				InterfaceOptionsNamesPanelMyName:Disable()
			else
				InterfaceOptionsNamesPanelMyName:Enable()
			end
		end)
	end
	InterfaceOptionsFrameOkay:Click()
end

function HealBotRename()
	if HealBot_Action then
		HealBot_Action:HookScript("OnUpdate", function()
		if Spoof_Enabled and Spoof_Blocks["HealBot"] then
			for i = 1, 100 do
				if _G["HealBot_Action_HealUnit"..i.."Bar"] then
					local t = {_G["HealBot_Action_HealUnit"..i.."Bar"]:GetRegions()}
					UniversalRenameTool_1(t[1])
				end
			end
		end
		end)
	end
	if HealBot_Tooltip then
		HealBot_Tooltip:HookScript("OnUpdate", function()
	if HealBot_Tooltip:IsShown() and Spoof_Enabled and Spoof_Blocks["HealBot"] then
			local TT = {HealBot_Tooltip:GetRegions()} 
			for i = 1, #TT do 
				if TT[i]:GetObjectType() == "FontString" and TT[i]:GetText() then 
					if TT[i]:GetText() == UnitName("player") or TT[i]:GetText() == OldName then
						TT[i]:SetText(NewName)
					end
				end 
			end
	end
		end)
	end
end

function GridRename()
	if GridLayoutFrame then
		GridLayoutFrame:HookScript("OnUpdate", function()
		if Spoof_Enabled and Spoof_Blocks["Greed"] then
			for qw = 1, 8 do
				if _G["GridLayoutHeader"..qw] then	
					local Ch = {_G["GridLayoutHeader"..qw]:GetChildren()} 
					for j = 1, #Ch do 
						local t = {Ch[j]:GetChildren()} 
						for k = 1, #t do
							local qr = {t[k]:GetRegions()}
							for i = 1, #qr do 
								if qr[i]:GetObjectType() == "FontString" and qr[i]:GetText() then 
									if string.sub(UnitName("player"), 1, #qr[i]:GetText()) == qr[i]:GetText() 
									or string.sub(OldName, 1, #qr[i]:GetText()) == qr[i]:GetText() then
										if GridLayoutFrame then
											local NewNameFromGrid = string.sub(NewName, 1, #qr[i]:GetText())
											qr[i]:SetText(NewNameFromGrid)
										end
									end
								end 
							end 
						end
					end
				end
			end
		end
		end)
	end
end

function VuhDoRenameAllMyName()
	for i = 1, 4 do
		if _G["VdAc"..i] then
			_G["VdAc"..i]:HookScript("OnUpdate", function()
			if Spoof_Enabled and Spoof_Blocks["VuhDo"] then
				for j = 1, 40 do
					if _G["VdAc"..i.."HlU"..j.."BgBarIcBarHlBarTxPnl"] then
						local t = {_G["VdAc"..i.."HlU"..j.."BgBarIcBarHlBarTxPnl"]:GetRegions()} 
						UniversalRenameTool_2(t[1])
					end
				end
				for j = 1, 5 do
					if _G["VdAc"..i.."HlU"..j.."BgBarIcBarHlBarTxPnl"] then
						local t = {_G["VdAc"..i.."HlU"..j.."TgBgBarHlBarTxPnl"]:GetRegions()} 
						UniversalRenameTool_2(t[1])
					end
				end
			end	
			end)
		end
	end
	if VuhDoTooltip then
		VuhDoTooltip:HookScript("OnUpdate", function()
		if Spoof_Enabled and Spoof_Blocks["VuhDo"] then
			local t = {VuhDoTooltip:GetRegions()}
			for i = 1, #t do 
				UniversalRenameTool_2(t[i])
			end
		end
		end)
	end
end

function RenameOmenBlaBlaBla()
	if OmenBarList then
		OmenBarList:HookScript("OnUpdate", function()
		if Spoof_Enabled and Spoof_Blocks["Omen"] then
			local Ch = {OmenBarList:GetChildren()} 
			for j = 1, #Ch do 
				local t = {Ch[j]:GetRegions()} 
				for i = 1, #t do 
					UniversalRenameTool_2(t[i])
				end 
			end
		end
		end)
	end
end

function ElvUINeOkAdonDlyaAnimeshnikov()
	if ElvUIParent then
		ElvUIParent:HookScript("OnUpdate", function()
		if Spoof_Enabled and Spoof_Blocks["ElvUI"] then
			if not FrameStackHighlight:IsShown() then
				FrameStackHighlight:Show()
				local t = {FrameStackHighlight:GetRegions()} 
				for i = 1, #t do 
					t[i]:SetTexture() 
				end
			end
			
			if _G["ElvUF_PartyGroup1"] then
				for j = 1, 5 do 
					if _G["ElvUF_PartyGroup1UnitButton"..j] then
						local t = {_G["ElvUF_PartyGroup1UnitButton"..j]:GetChildren()} 
						local F = {t[1]:GetRegions()} 
						UniversalRenameTool_1(F[3])
					end
				end
			end
			if ElvUF_Assist:IsShown() then
				local Ch = {ElvUF_AssistUnitButton1:GetChildren()}
				Ch = {Ch[2]:GetRegions()}
				UniversalRenameTool_1(Ch[1])
			end	
			if ElvUF_Tank:IsShown() then
				local Ch = {ElvUF_TankUnitButton1:GetChildren()}
				Ch = {Ch[2]:GetRegions()}
				UniversalRenameTool_1(Ch[1])
			end		
		end
		end)
		local SpisokFrameow = {"ElvUF_TargetTarget",
		"ElvUF_Focus",
		"ElvUF_FocusTarget",
		"ElvUF_Target",
		"ElvUF_Player",
		"ElvUF_TargetTargetTarget"}
		FrameStackHighlight:HookScript("OnUpdate", function()
			if Spoof_Enabled and Spoof_Blocks["ElvUI"] then
				for l = 1, #SpisokFrameow do
					if _G[SpisokFrameow[l]] and _G[SpisokFrameow[l]]:IsShown() then
						local Ch = {_G[SpisokFrameow[l]]:GetChildren()} 
						Ch = {Ch[1]:GetRegions()} 
						UniversalRenameTool_1(Ch[3])
					end
				end
				if ElvUF_AssistUnitButton1Target and ElvUF_AssistUnitButton1Target:IsShown() then
					local Ch = {ElvUF_AssistUnitButton1Target:GetChildren()} 
					Ch = {Ch[1]:GetRegions()} 
					UniversalRenameTool_1(Ch[1])
				end
				if ElvUF_TargetTargetTarget and ElvUF_TargetTargetTarget:IsShown() then
					local Ch = {ElvUF_TargetTargetTarget:GetChildren()} 
					Ch = {Ch[1]:GetRegions()} 
					UniversalRenameTool_1(Ch[1])
				end
			end
		end)
	end
	if ElvUIAFKFrame then
		ElvUIAFKFrame:HookScript("OnUpdate", function()
			if ElvUIAFKFrame:IsShown() and Spoof_Enabled and Spoof_Blocks["ElvUI"] then
				local Ch = {ElvUIAFKFrame:GetChildren()} 
				Ch = {Ch[2]:GetRegions()}
				UniversalRenameTool_1(Ch[2]) 
			end
		end)
	end
	if DatatextTooltip then
		DatatextTooltip:HookScript("OnUpdate", function()
			if DatatextTooltip:IsShown() and Spoof_Enabled and Spoof_Blocks["ElvUI"] then
				local t = {DatatextTooltip:GetRegions()} 
				for i = 1, #t do 
					UniversalRenameTool_1(t[i])
				end
			end
		end)
	end
end

function DBMandAllAnnounceRename()
	UIParent:HookScript("OnUpdate", function()
	if Spoof_Enabled and Spoof_Blocks["ann"] then
		local Ch = {UIParent:GetChildren()} 
		for j = 1, #Ch do 
			local t = {Ch[j]:GetRegions()} 
			for i = 1, #t do 
				UniversalRenameTool_1(t[i]) 
			end 
		end
	end
	end)
end

function DBMStrings()
	for hj = 1, 50 do
		UIParent:HookScript("OnUpdate", function()
		if Spoof_Enabled and Spoof_Blocks["DBM"] then
			if _G["DBT_Bar_"..hj.."Bar"] and _G["DBT_Bar_"..hj.."Bar"]:IsShown() then
				local t = {_G["DBT_Bar_"..hj.."Bar"]:GetRegions()} 
				for i = 1, #t do 
					UniversalRenameTool_1(t[i])
				end
			end
		end
		end)
	end
end

function FindMyNickChatAndHide() 
	local spisokFrameow = { "ChatFrame1",
	"ChatFrame2",
	"ChatFrame3",
	"ChatFrame4",
	"ChatFrame5",
	"ChatFrame6",
	"ChatFrame7",
	"ChatFrame1",
	"CopyChatFrameEditBox",
	"PratCCFrameScrollText"
	}
	UIParent:HookScript("OnUpdate", function()
	if Spoof_Enabled and Spoof_Blocks["ch"] then
		for as = 1, #spisokFrameow do
			if _G[spisokFrameow[as]] and _G[spisokFrameow[as]]:IsShown() then
				local t = {_G[spisokFrameow[as]]:GetRegions()} 
				for i = 1, #t do 
					UniversalRenameTool_1(t[i])
				end
			end
		end
	end
	end)
end

function RaidCooldownAddonRename()
	if RCDD_Anchor then
		RCDD_Anchor:HookScript("OnUpdate", function()
		if Spoof_Enabled and Spoof_Blocks["RCA"] then
			local Ch = {RCDD_Anchor:GetChildren()} 
			for j = 1, #Ch do 
				local t = {Ch[j]:GetRegions()} 
				for i = 1, #t do 
					UniversalRenameTool_1(t[i])
				end 
			end
		end	
		end)
	end
end

function UniversalRenameTool_1(arg)
	if arg and arg:GetObjectType() == "FontString" and arg:GetText() then 
		local pos, ln = string.find(arg:GetText(), UnitName("player")), #UnitName("player")
		if not pos then
			pos, ln = string.find(arg:GetText(), OldName), #OldName
		end
		if pos then
			local do_nicka, posle_nicka = string.sub(arg:GetText(), 1, pos - 1), string.sub(arg:GetText(), pos + ln, #arg:GetText())
			local NewTextTool = do_nicka..""..NewName..""..posle_nicka
			arg:SetText(NewTextTool)
		end
	end
end

function UniversalRenameTool_2(arg)
	if arg:GetObjectType() == "FontString" then 
		if arg:GetText() and (string.find(arg:GetText(), UnitName("player")) or string.find(arg:GetText(), OldName)) then
			arg:SetText(NewName)
		end
	end
end

----------------------------------
function nocase (s)
	s = string.gsub(s, "%a", function (c)
		return string.format("[%s%s]", string.lower(c), string.upper(c)) end)
	return s
end

function igsub(s, pat, repl, n)
    pat = gsub(pat, '(%a)', function (v) return '['..strupper(v)..strlower(v)..']' end)
    if n then
        return gsub(s, pat, repl, n)
    else
        return gsub(s, pat, repl)
    end
end

local function nameFilter(self, event, msg, sender, ...)
	local uname = UnitName("player")
	if msg:find(nocase(uname)) then
		return false, igsub(msg, uname, NewName), sender, ...
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND_LEADER", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE_USER", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_ACHIEVEMENT", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ACHIEVEMENT", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_EMOTE", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_PARTY", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_SAY", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_WHISPER", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_YELL", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_BOSS_EMOTE", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_BOSS_WHISPER", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", nameFilter)
ChatFrame_AddMessageEventFilter("ROLE_CHANGED_INFORM", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BG_SYSTEM_ALLIANCE", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BG_SYSTEM_HORDE", nameFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BG_SYSTEM_NEUTRAL", nameFilter)

local function senderFilter(self, event, msg, sender, ...)
	local name = sender:match(UnitName("player"))
	if name == UnitName("player") then
		return false, msg, NewName, ...
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_ACHIEVEMENT", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND_LEADER", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ACHIEVEMENT", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_EMOTE", senderFilter) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_YELL", senderFilter) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", senderFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", senderFilter)
ChatFrame_AddMessageEventFilter("ROLE_CHANGED_INFORM", senderFilter)