-- wondernoti
-- Author: dawei
-- DateCreated: 11/16/2017 6:58:44 PM
--------------------------------------------------------------

print("loaded")

local hid=nil

function onsequencegameinitcomplete()
	for k,v in pairs(Players) do
		if v:IsHuman() then
			hid=k
			return
		end
	end
end

function onplayerdoturn(pid)
	-- Skips on the human player's turn.
	if hid==nil or hid==pid then
		return
	end

	-- Inspects only AI players of major civilisations.
	local p=Players[pid]
	if not p or p:IsMinorCiv() or p:IsBarbarian() then
		return
	end

	local b
	local bname

	for c in p:Cities() do
		b=GameInfo.Buildings[c:GetProductionBuilding()]
		if b and GameInfo.BuildingClasses[b.BuildingClass].MaxGlobalInstances==1 then

			if c:GetProduction()==0 then
				bname=Locale.ConvertTextKey(b.Description)
				local text=table.concat{
					"[COLOR_YELLOW]",
					bname,
					"[ENDCOLOR] construction started"}
				local tooltip=table.concat{
					"The rumor goes around that [COLOR_YELLOW]",
					bname,
					"[ENDCOLOR] construction has been started by another civilisation!"}
				Players[hid]:AddNotification(
					NotificationTypes.NOTIFICATION_WONDER_BEATEN,
					tooltip,
					text,
					-1,
					-1,
					b.ID)
			end
		end
	end
end

Events.SequenceGameInitComplete.Add(onsequencegameinitcomplete)
GameEvents.PlayerDoTurn.Add(onplayerdoturn)

function oncitycanconstruct(pid,cid,bid)
    -- do not let ai build stonehenge
    if pid~=hid and bid==GameInfo.Buildings["BUILDING_STONEHENGE"].ID then
        return false
    end
    return "t"
    -- $ GameInfo.Buildings[159]
    -- > table: 7334D5B0
    -- $ GameInfo.Buildings["BUILDING_STONEHENGE"]
    -- > table: 7334D5B0
end
GameEvents.CityCanConstruct.Add(oncitycanconstruct)