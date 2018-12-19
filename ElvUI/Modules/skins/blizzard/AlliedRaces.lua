local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

--Cache global variables
local _G = _G
local select, unpack = select, unpack
--Lua functions
--WoW API / Variables

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.AlliedRaces ~= true then return end

	local AlliedRacesFrame = _G.AlliedRacesFrame
	S:HandlePortraitFrame(AlliedRacesFrame, true)
	select(2, AlliedRacesFrame.ModelFrame:GetRegions()):Hide()

	local scrollFrame = AlliedRacesFrame.RaceInfoFrame.ScrollFrame
	scrollFrame.ScrollBar.Border:Hide()
	scrollFrame.ScrollBar.ScrollUpBorder:Hide()
	scrollFrame.ScrollBar.ScrollDownBorder:Hide()
	S:HandleScrollSlider(scrollFrame.ScrollBar)

	scrollFrame.Child.ObjectivesFrame:StripTextures()
	scrollFrame.Child.ObjectivesFrame:CreateBackdrop("Transparent")

	AlliedRacesFrame.RaceInfoFrame.AlliedRacesRaceName:SetTextColor(1, .8, 0)
	scrollFrame.Child.RaceDescriptionText:SetTextColor(1, 1, 1)
	scrollFrame.Child.RacialTraitsLabel:SetTextColor(1, .8, 0)

	AlliedRacesFrame:HookScript("OnShow", function(self)
		local parent = scrollFrame.Child
		for i = 1, parent:GetNumChildren() do
			local bu = select(i, parent:GetChildren())

			if bu.Icon and not bu.IsSkinned then
				select(3, bu:GetRegions()):Hide()
				S:HandleTexture(bu.Icon, bu)
				bu.Text:SetTextColor(1, 1, 1)

				bu.IsSkinned = true
			end
		end
	end)
end

S:AddCallbackForAddon("Blizzard_AlliedRacesUI", "AlliedRaces", LoadSkin)
