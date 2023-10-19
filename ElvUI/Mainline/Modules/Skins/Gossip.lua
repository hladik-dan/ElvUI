local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule('Skins')

local _G = _G
local next = next
local gsub, strmatch = gsub, strmatch
local hooksecurefunc = hooksecurefunc

local function ReplaceTextColor(text, r, g, b)
	if r ~= 1 or g ~= 1 or b ~= 1 then
		text:SetTextColor(1, 1, 1)
	end
end

local function ReplaceGossipFormat(button, textFormat, text)
	local newFormat, count = gsub(textFormat, '000000', 'ffffff')
	if count > 0 then
		button:SetFormattedText(newFormat, text)
	end
end

local ReplacedGossipColor = {
	['000000'] = 'ffffff',
	['414141'] = '7b8489',
}

local function ReplaceGossipText(button, text)
	if text and text ~= '' then
		local newText, count = gsub(text, ':32:32:0:0', ':32:32:0:0:64:64:5:59:5:59')
		if count > 0 then
			text = newText
			button:SetFormattedText('%s', text)
		end

		local colorStr, rawText = strmatch(text, '|c[fF][fF](%x%x%x%x%x%x)(.-)|r')
		colorStr = ReplacedGossipColor[colorStr]
		if colorStr and rawText then
			button:SetFormattedText('|cff%s%s|r', colorStr, rawText)
		end
	end
end

local function ItemTextPage_SetTextColor(pageText, headerType, r, g, b)
	if r ~= 1 or g ~= 1 or b ~= 1 then
		pageText:SetTextColor(headerType, 1, 1, 1)
	end
end

local function GreetingPanel_Update(frame)
	for _, button in next, { frame.ScrollTarget:GetChildren() } do
		if not button.IsSkinned then
			if button.GreetingText then
				button.GreetingText:SetTextColor(1, 1, 1)
				hooksecurefunc(button.GreetingText, 'SetTextColor', ReplaceTextColor)
			end

			if button.GetFontString and button:GetFontString() then
				ReplaceGossipText(button, button:GetText())
				hooksecurefunc(button, 'SetText', ReplaceGossipText)
				hooksecurefunc(button, 'SetFormattedText', ReplaceGossipFormat)
			end

			button.IsSkinned = true
		end
	end
end

local function GossipFrame_SetAtlas(frame)
	frame:Height(frame:GetHeight() - 2)
end

function S:GossipFrame()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.gossip) then return end

	local GossipFrame = _G.GossipFrame
	S:HandlePortraitFrame(GossipFrame, true)

	S:HandleTrimScrollBar(_G.ItemTextScrollFrame.ScrollBar)
	S:HandleTrimScrollBar(_G.GossipFrame.GreetingPanel.ScrollBar)
	S:HandleButton(_G.GossipFrame.GreetingPanel.GoodbyeButton, true)
	S:HandleCloseButton(_G.ItemTextFrameCloseButton)

	S:HandleNextPrevButton(_G.ItemTextNextPageButton)
	S:HandleNextPrevButton(_G.ItemTextPrevPageButton)

	for i = 1, 4 do
		local notch = GossipFrame.FriendshipStatusBar['Notch'..i]
		if notch then
			notch:SetColorTexture(0, 0, 0)
			notch:SetSize(E.mult, 16)
		end
	end

	if E.private.skins.parchmentRemoverEnable then
		_G.ItemTextFrame:StripTextures(true)
		_G.ItemTextFrame:SetTemplate('Transparent')
		_G.ItemTextScrollFrame:StripTextures()

		_G.GossipFrameInset:Hide()
		_G.QuestFont:SetTextColor(1, 1, 1)

		_G.ItemTextPageText:SetTextColor('P', 1, 1, 1)
		hooksecurefunc(_G.ItemTextPageText, 'SetTextColor', ItemTextPage_SetTextColor)
		hooksecurefunc(GossipFrame.GreetingPanel.ScrollBox, 'Update', GreetingPanel_Update)

		if GossipFrame.Background then
			GossipFrame.Background:Hide()
		end

	else
		local pageBG = _G.ItemTextFramePageBg:GetTexture()
		_G.ItemTextFrame:StripTextures()
		_G.ItemTextFrame:SetTemplate('Transparent')
		_G.ItemTextScrollFrame:StripTextures()
		_G.ItemTextScrollFrame:CreateBackdrop('Transparent')

		_G.ItemTextFramePageBg:SetTexture(pageBG)
		_G.ItemTextFramePageBg:SetDrawLayer('BACKGROUND', 1)
		_G.ItemTextFramePageBg:SetInside(_G.ItemTextScrollFrame.backdrop)

		if GossipFrame.Background then
			GossipFrame.Background:CreateBackdrop('Transparent')

			hooksecurefunc(GossipFrame.Background, 'SetAtlas', GossipFrame_SetAtlas)
		end
	end
end

S:AddCallback('GossipFrame')
