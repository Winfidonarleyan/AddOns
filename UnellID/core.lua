local select, UnitBuff, UnitDebuff, UnitAura, UnitGUID, tonumber, strfind, hooksecurefunc =
	select, UnitBuff, UnitDebuff, UnitAura, UnitGUID, tonumber, strfind, hooksecurefunc

local function addLine(self,id,isItem)
	if isItem then
		self:AddDoubleLine("|cffff0000Номер предмета:","|cffff0000"..id)
	else
		self:AddDoubleLine("|cffff0000Номер заклинания:","|cffff0000"..id)
	end
	self:Show()
end

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
    if C_PetBattles.IsInBattle() then return end
    local unit = select(2, self:GetUnit())
    if unit then
        local guid = UnitGUID(unit) or ""
        local id = tonumber(guid:match("-(%d+)-%x+$"), 10)
        if id and guid:match("%a+") ~= "Player" then addLine(GameTooltip, id, types.unit) end
    end
end)

hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
	local id = select(11,UnitBuff(...))
	if id then addLine(self,id) end
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
	local id = select(11,UnitDebuff(...))
	if id then addLine(self,id) end
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
	local id = select(11,UnitAura(...))
	if id then addLine(self,id) end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local id = select(3,self:GetSpell())
	if id then addLine(self,id) end
end)

hooksecurefunc("SetItemRef", function(link, ...)
	local id = tonumber(link:match("spell:(%d+)"))
	if id then addLine(ItemRefTooltip,id) end
end)

hooksecurefunc("SetItemRef", function(link, ...) 
      local id = tonumber(link:match("quest:(%d+)")) 
      if (id) then   
    ItemRefTooltip:AddDoubleLine("|cffff0000Номер задания:","|cffff0000"..id)
    ItemRefTooltip:Show();
   end 
end)

hooksecurefunc("SetItemRef", function(link, ...) 
      local id = tonumber(link:match("achievement:(%d+)")) 
      if (id) then   
    ItemRefTooltip:AddDoubleLine("|cffff0000Номер достижения:","|cffff0000"..id)
    ItemRefTooltip:Show();
   end 
end)


local function attachItemTooltip(self)
	local link = select(2,self:GetItem())
	if not link then return end
	local id = select(3,strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
	if id then addLine(self,id,true) end
end



GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip3:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip3:HookScript("OnTooltipSetItem", attachItemTooltip)
