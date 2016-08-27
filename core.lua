local E, M = unpack(_G.yaCore)
local numChildren = -1

local frame = CreateFrame('Frame')
frame.lastupdate = -2 -- wait 2 seconds before hooking frames

frame:SetScript('OnUpdate', function(self, elapsed)
	self.lastupdate = self.lastupdate + elapsed
	if (self.lastupdate < .1) then return end
	self.lastupdate = 0

	local count = WorldFrame:GetNumChildren()
	if(count ~= numChildren) then
		numChildren = count
		HookBubbles(WorldFrame:GetChildren())
	end
end)

function UpdateBubbleBorder(frame)
	if not frame.text then return end -- if there is no text then we cant do anything

	frame.text:SetText(("\124cFF000000%s\124r"):format(frame.text:GetText()))
end

function HookBubbles(...)
	for index = 1, select('#', ...) do
		local frame = select(index, ...)
		if IsChatBubble(frame) and not frame.isBubblePowered then SkinBubble(frame) end
	end
end

function IsChatBubble(frame)
	for i = 1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())

		if (region.GetTexture and region:GetTexture() and type(region:GetTexture() == "string") and strlower(region:GetTexture()) == "interface\\tooltips\\chatbubble-background") then return true end;
	end
	return false
end

function SkinBubble(frame)

	for i=1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
		elseif region:GetObjectType() == "FontString" then
			frame.text = region
		end
	end

	frame.text:SetFont(M:Fetch("font", "Roboto"), M:Fetch("font", "size"))
	frame.text:SetText(("\124cFF000000%s\124r"):format(frame.text:GetText()))

	frame:SetBackdrop({
		bgFile = M:Fetch("gw2", "background"),	-- path to the background texture
		edgeFile = M:Fetch("gw2", "backdrop"),	-- path to the border texture
		tile = true,									-- true to repeat the background texture to fill the frame, false to scale it
		tileSize = 32,									-- size (width or height) of the square repeating background tiles (in pixels)
		edgeSize = 32,									-- thickness of edge segments and square size of edge corners (in pixels)
		insets = {										-- distance from the edges of the frame to those of the background texture (in pixels)
			left = 11,
			right = 12,
			top = 12,
			bottom = 11
		}
	})

	UpdateBubbleBorder(frame)

	frame:HookScript('OnShow', UpdateBubbleBorder)
	frame:SetFrameStrata("DIALOG") --Doesn't work currently in Legion due to a bug on Blizzards end
	frame.isBubblePowered = true

end