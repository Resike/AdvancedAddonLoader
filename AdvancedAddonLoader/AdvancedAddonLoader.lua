local AddonName, AdvancedAddonLoader = ...

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")

frame:SetScript("OnEvent", function(self, event, ...)
	AdvancedAddonLoader[event](AdvancedAddonLoader, ...)
end)

function AdvancedAddonLoader:ADDON_LOADED(addon)
	if addon == AddonName then
		self:AddonLoaded()
		frame:UnregisterEvent("ADDON_LOADED")
	end
end

function AdvancedAddonLoader:AddonLoaded()
	local addonNum = 19
	local ACPLoaded = false
	local loaded = true
	local prefix = ""

	if IsAddOnLoaded("ACP") then
		addonNum = 20
		ACPLoaded = true
		prefix = "ACP_"
	end

	for i = 1, addonNum do
		if _G[prefix.."AddonListEntry"..i.."Enabled"] then
			_G[prefix.."AddonListEntry"..i.."Enabled"]:RegisterForClicks("LeftButtonUp", "RightButtonDown")
			_G[prefix.."AddonListEntry"..i.."Enabled"]:HookScript("OnEnter", function(self)
				if IsMouseButtonDown("RightButton") then
					if self:GetChecked() then
						self:SetChecked(false)
					else
						self:SetChecked(true)
					end
					if ACPLoaded then
						ACP:AddonList_Enable(self:GetParent().addon, self:GetChecked(), IsShiftKeyDown(), IsControlKeyDown(), self:GetParent().category)
					else
						AddonList_Enable(self:GetParent():GetID(), self:GetChecked())
					end
				end
			end)
			_G[prefix.."AddonListEntry"..i]:HookScript("OnClick", function(self)
				if ACPLoaded then
					local name = GetAddOnInfo(self.addon)
					if name == "ACP" then
						loaded = not loaded
						ACP:AddonList_Enable(self.addon, loaded, IsShiftKeyDown(), IsControlKeyDown(), self.category)
						if loaded then
							_G[prefix.."AddonListEntry"..i.."Title"]:SetTextColor(1, 0.78, 0)
						else
							_G[prefix.."AddonListEntry"..i.."Title"]:SetTextColor(0.5, 0.5, 0.5)
						end
					end
				end
			end)
		end
	end
end