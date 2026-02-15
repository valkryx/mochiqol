local eventHandlerFrame = CreateFrame("Frame")

local junkItemsSoldMsg = "Sold %d junk items."
local itemsRepairedMsg = "Repaired all items for %s."
local itemsRepairedGuildMsg = "Repaired all items using guild funds (%s)."

local function AutoSellJunkItems()
--TODO: add on/off toggle
	local numJunkItems = C_MerchantFrame.GetNumJunkItems()
	if numJunkItems > 0 then
		C_MerchantFrame.SellAllJunkItems()
		print(string.format(junkItemsSoldMsg, numJunkItems))
	end
end

local function AutoRepairItems()
--TODO: add on/off toggles
	local repairAllCost, canRepair = GetRepairAllCost()
	
	if repairAllCost == 0 then
		return
	end
	
	if CanGuildBankRepair() and GetGuildBankWithdrawGoldLimit() >= repairAllCost then
		RepairAllItems(true)
		print(string.format(itemsRepairedGuildMsg, GetMoneyString(repairAllCost)))
		return
	end
	
	if GetMoney() >= repairAllCost then
		RepairAllItems(false)
		print((string.format(itemsRepairedMsg, GetMoneyString(repairAllCost))))
	end
end

local function MerchantShowHandler(self, event, ...)
	if event == "MERCHANT_SHOW" then
		if C_MerchantFrame.IsSellAllJunkEnabled() then
			AutoSellJunkItems()
		end
		
		if CanMerchantRepair() then
			AutoRepairItems()
		end
	end
end

eventHandlerFrame:SetScript("OnEvent", MerchantShowHandler)
eventHandlerFrame:RegisterEvent("MERCHANT_SHOW")