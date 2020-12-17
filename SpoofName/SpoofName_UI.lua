local Spoof_UI_Obj = 0
local Spoof_Frame, Spoof_Frame_x_size = CreateFrame("Frame"), 13
local Spoof_Frame_x = CreateFrame("Button", nil, Spoof_Frame)
Spoof_Frame:SetHeight(1)
Spoof_Frame_x:SetHeight(Spoof_Frame_x_size)
Spoof_Frame:SetWidth(1)
Spoof_Frame_x:SetWidth(Spoof_Frame_x_size)
Spoof_Frame:Hide()
Spoof_Frame:SetPoint("CENTER", 0, 0);
Spoof_Frame_x:SetPoint("TOPRIGHT", -3, -4);
Spoof_Frame_x:SetBackdrop({bgFile = "Interface/Buttons/UI-SliderBar-Background",
insets = { left = 1, right = 1, top = 1, bottom = 1 }})
Spoof_Frame_x.closeFrame = Spoof_Frame_x:CreateFontString(nil,"ARTWORK") 
Spoof_Frame_x.closeFrame:SetFont("Fonts\\ARIALN.ttf", 11, "OUTLINE")
Spoof_Frame_x.closeFrame:SetPoint("CENTER", 1.1, 1.5) 
Spoof_Frame_x.closeFrame:SetText("x")
Spoof_Frame_x:RegisterForClicks("LeftButtonUp")
Spoof_Frame_x:SetScript("OnClick", function()
	Spoof_Frame:Hide()
end)
Spoof_Frame:SetBackdrop({bgFile = "Interface/Buttons/UI-SliderBar-Background",
edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
tile = true, tileSize = 4, edgeSize = 4,
insets = { left = 1, right = 1, top = 1, bottom = 1 }})
Spoof_Frame:EnableMouse(true)
Spoof_Frame:SetMovable(true)
Spoof_Frame:RegisterForDrag("LeftButton")
Spoof_Frame:SetScript("OnDragStart", function(self)
	self:StartMoving()
end)
Spoof_Frame:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
end) 

function Open_Spoof_Menu()
	Spoof_Frame:Show()
end

function Spoof_Add_CheckBox(text, tooltip, arg)
	local checkBox = CreateFrame("CheckButton", nil, Spoof_Frame, "ChatConfigSmallCheckButtonTemplate")
	checkBox:SetWidth(25)
	checkBox:SetHeight(25) 
	checkBox:SetPoint("TOPLEFT", 3, Spoof_UI_Obj * (-19) - 3 ) 
	checkBox:RegisterForClicks("AnyUp") 
	checkBox.tooltip = tooltip
	checkBox:SetChecked(arg)
	checkBox:SetScript("OnClick", function()
		Spoof_Blocks[arg] = checkBox:GetChecked()
	end )
	checkBox.text = checkBox:CreateFontString(nil,"ARTWORK") 
	checkBox.text:SetFont("Fonts\\ARIALN.ttf", 11, "OUTLINE")
	checkBox.text:SetPoint("LEFT", 21, 0) 
	checkBox.text:SetText(text)
	Spoof_UI_Obj = Spoof_UI_Obj + 1
	Spoof_Frame:SetHeight(Spoof_UI_Obj * (19) + 10.5)
	if (#text * 3 + 34) > Spoof_Frame:GetWidth() then
		Spoof_Frame:SetWidth(#text * 3 + 34)
	end
end

function Spoof_Add_Caption(text)
	local caption = CreateFrame("Frame", nil, Spoof_Frame)
	caption:SetWidth(1)
	caption:SetHeight(1) 
	caption:SetPoint("TOPLEFT", 3, Spoof_UI_Obj * (-19) - 3 ) 
	caption.text = caption:CreateFontString(nil,"ARTWORK") 
	caption.text:SetFont("Fonts\\ARIALN.ttf", 13.5, "OUTLINE")
	caption.text:SetPoint("LEFT", 0, -11) 
	caption.text:SetText("|cFFf4a341"..text.."|r")
	Spoof_UI_Obj = Spoof_UI_Obj + 1
	Spoof_Frame:SetHeight(Spoof_UI_Obj * (19) + 10.5)
	if ((#text + 2) * 3) > Spoof_Frame:GetWidth() then
		Spoof_Frame:SetWidth((#text + 2) * 3)
	end
end