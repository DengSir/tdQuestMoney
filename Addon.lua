
local Addon = CreateFrame('Frame', nil, QuestRewardScrollChildFrame) do
    Addon:Hide()
    Addon:SetSize(18, 18)

    local icon = Addon:CreateTexture(nil, 'OVERLAY')
    icon:SetAllPoints(Addon)
    icon:SetTexture([[Interface\BUTTONS\UI-GroupLoot-Coin-Up]])
end

local function OnEvent()
    Addon:Hide()

    local choice = GetNumQuestChoices()
    if choice <= 1 then
        return
    end

    local maxPrice, maxIndex = 0
    for i = 1, choice do
        local link, name, _, qty = GetQuestItemLink('choice', i), GetQuestItemInfo('choice', i)
        if not link then
            return C_Timer.After(1, OnEvent)
        end
        local price = (link and select(11, GetItemInfo(link)) or 0) * (qty or 1)
        if price > maxPrice then
            maxPrice, maxIndex = price, i
        end
    end

    if maxIndex then
        local button = QuestInfo_GetRewardButton(QuestInfoFrame.rewardsFrame, maxIndex)
        Addon:ClearAllPoints()
        Addon:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -5, 0)
        Addon:SetFrameLevel(button:GetFrameLevel() + 10)
        Addon:Show()
    end
end

Addon:RegisterEvent('QUEST_COMPLETE')
Addon:RegisterEvent('QUEST_ITEM_UPDATE')
Addon:RegisterEvent('GET_ITEM_INFO_RECEIVED')
Addon:SetScript('OnEvent', OnEvent)
