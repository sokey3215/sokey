local zone = {
	["spawn"] = {x=-1915.4,y= 2043.05,z=140.74,radius = 300.0},
	["szpital"] = {x=-675.79,y=336.75,z=82.20,radius = 350.0},
	["mechanik"] = {x=817.9,y=-896.24,z=25.25,radius = 300.0},
	["cardealer"] = {x=133.59,y=-146.09,z=54.86,radius = 100.0}
}

local ez = {laba = false,x=nil,y=nil,z=nil,radius=nil}

function coliziune(entitate)
	for _, lr in ipairs(GetActivePlayers()) do
		if(Vdist(GetEntityCoords(GetPlayerPed(lr)),ez.x,ez.y,ez.z) <= ez.radius) then
			SetEntityNoCollisionEntity(GetPlayerPed(lr),entitate,true)
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local jucatorimuie = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(jucatorimuie, true))
		
		if(ez.laba == false) then
			for i,v in pairs(zone) do
				if(Vdist(x,y,z,v.x,v.y,v.z) <= v.radius) then
					ez.laba = true
					ez.x,ez.y,ez.z,ez.radius = v.x,v.y,v.z,v.radius
					SetCurrentPedWeapon(jucatorimuie,GetHashKey("WEAPON_UNARMED"),true)
					ClearPlayerWantedLevel(PlayerId())
					SetPlayerInvincible(jucatorimuie,true)
					SetEntityAlpha(PlayerPedId(), 170, false)
				end
			end
		end
		if ez.laba then
			NetworkSetFriendlyFireOption(false)
			DisableControlAction(2, 37, true)
			DisablePlayerFiring(jucatorimuie,true)
			DisableControlAction(0, 106, true)
			Draw3DText(x,y,z, "", 0.7)

			coliziune(player)
			if(Vdist(x,y,z,ez.x,ez.y,ez.z) > 50.0) then
				ez.laba = false
				ez.x,ez.y,ez.z,ez.radius = nil,nil,nil,nil
				NetworkSetFriendlyFireOption(true)
				DisableControlAction(2, 37, false)
				DisablePlayerFiring(jucatorimuie,false)
				DisableControlAction(0, 106, false)
				SetPlayerInvincible(jucatorimuie,false)
				SetEntityAlpha(PlayerPedId(), 255, false)
			end
		end
	end
end)

function drawtxt(text,font,centre,x,y,scale,r,g,b,a)
    y = y - 0.010
    scale = scale/2
    y = y + 0.002
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextFont(fontId)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end


function Draw3DText(x,y,z, text,scl) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString("~h~"..text)
        DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(5)
		if IsControlJustReleased(1 ,80) then
			SetPedToRagdoll(PlayerPedId(), 5000, 0, 0, true, true, false)
		end
	end
end)