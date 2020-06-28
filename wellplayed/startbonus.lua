-- startbonus
-- Author: dawei
-- DateCreated: 11/17/2017 4:30:28 AM
--------------------------------------------------------------
print("loaded")

function bonusfaith(p,amount)
		p:ChangeFaith(amount)
		local text=table.concat{
			"Received ",
			amount,
			" [ICON_PEACE] Faith"}
		local tooltip=table.concat{
			"Some ancient memory stirs. ",
			"Your civilisation is blessed by the revelation of an endless time. ",
			"You have received ",
			amount,
			" [ICON_PEACE] Faith."}
		p:AddNotification(-1,tooltip,text)
end

function onactiveplayerturnstart()
	local t=Game.GetElapsedGameTurns()
	local p=Players[Game.GetActivePlayer()]
	
	if not p or not p:IsHuman() then
		return
	end

	if t==30 then
		bonusfaith(p,500)
	end
end

Events.ActivePlayerTurnStart.Add(onactiveplayerturnstart)