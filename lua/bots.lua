--homemade bots
local KART_FULLTURN = 800

COM_AddCommand("kart_addbot",function(player,skin)
	if not skin or not skins[skin]
		CONS_Printf(player, "kart_addbot <skin>: Add a bot with a specified skin.")
		return
	end
	
	local sk = skins[skin]
	local bot = G_AddPlayer(sk.name,sk.prefcolor,sk.realname,BOT_MPAI)
	
	if bot
		bot.kart = true
-- 		kartinit(bot,bot.realmo)
		CONS_Printf(player, "Added bot "..#bot)
	else
		CONS_Printf(player, "Could not add bot.")
	end
end)

COM_AddCommand("kart_delbot",function(player,node)
	if not node or tonumber(node) == nil
		CONS_Printf(player, "kart_addbot <node>: Remove a bot from the game.")
		return
	end
	
	local node = tonumber(node)
	
	if node ~= nil and players[node] and players[node].bot
		G_RemovePlayer(node)
		CONS_Printf(player, "Removed bot "..node)
	else
		CONS_Printf(player, "Could not remove bot.")
	end
end)

local function sthok(x,y,z,fl)
	local thok = P_SpawnMobj(x,y,z,MT_THOK)
	thok.state = S_INVISIBLE
	thok.sprite = SPR_THOK
	thok.frame = A
	thok.tics = -1--2+2
	
	if fl
		thok.z = thok.floorz+z
	end
	
	return thok
end

addHook("MapLoad",do
	if true return end
	local spawn
	for mo in mapthings.iterate
		if mo.type == 1
			spawn = mo
			break
		end
	end
	
	if spawn --great, a spawnpoint was found
		local found = true
		local h = 1
		while found
			found = false
			local thok
			if h <= 1
				thok = sthok(spawn.x*FU,spawn.y*FU,spawn.z*FU)
			else
				thok = sthok(spawn.x,spawn.y,spawn.z)
			end
			
			local dists = {}
			local angs = {}
			local vangs = {}
			local dist,ang,vang = 0,0,0
			
			local mo = waypointcap
			while mo and mo.valid
				if mo.health == h-- + 1
					found = true
					local dist = P_AproxDistance(mo.x-thok.x,mo.y-thok.y)
					table.insert(dists,P_AproxDistance(dist,mo.z-thok.z))
					table.insert(angs,R_PointToAngle2(thok.x,thok.y,mo.x,mo.y))
					table.insert(vangs,R_PointToAngle2(0,thok.z,dist,mo.z))
				end
				mo = $.tracer
			end
			
			if not found break end
			for i,v in ipairs(dists) dist = $ + (v / #dists) end
			for i,v in ipairs(angs) ang = $ + (v / #angs) end
			for i,v in ipairs(vangs) vang = $ + (v / #vangs) end
			
			local x,y,z = thok.x+fixmul(fixmul(cos(ang),cos(vang)),dist),thok.y+fixmul(fixmul(sin(ang),cos(vang)),dist),thok.z+fixmul(sin(vang),dist)
			
	-- 		print(dist/FU,ang/ANG1,vang/ANG1)
	-- 		print(x/FU,y/FU,z/FU)
			local amount = 48
			for i=1,amount
				local pr = i*FU/amount
				
				local thokk = sthok(ease.linear(pr,thok.x,x),ease.linear(pr,thok.y,y),ease.linear(pr,thok.z,z))
				spawn = thokk
			end
			
			h = $ + 1
		end
	end
end)

local function botoffroad(mo)
	return (mo.subsector.sector.damagetype <= 5 and mo.subsector.sector.damagetype >= 2) or mo.subsector.sector.friction < FU*29/32
end

local function botsneaker(bot) --sneakertimer is above itemtype on purpose so the bot doesn't try mashing sneakers
	if bot.kartstuff[k_sneakertimer] return 2
	
	elseif bot.kartstuff[k_itemtype] == KITEM_SNEAKER or bot.kartstuff[k_itemtype] == KITEM_ROCKETSNEAKER
	or bot.kartstuff[k_rocketsneakertimer] return 1 end
end

local function botpoweritem(bot)
	if bot.kartstuff[k_itemtype] == KITEM_INVINCIBILITY or bot.kartstuff[k_itemtype] == KITEM_GROW
	or bot.kartstuff[k_itemtype] == KITEM_SHRINK return 1 end
end

addHook("BotTiccmd",function(bot,cmd)
	if paused return end
	if bot and bot.kart and bot.kartstuff
		local mo = bot.mo
		if mo.lasttic == leveltime return end
		mo.lasttic = leveltime
-- 		local ch = sphealth[bot.starpostnum+1]
-- 		local ch = waypointcap
-- 		local ch
-- 		local chxt,chyt = {},{}
-- 		local chx,chy = 0,0
-- 		local chs = 0
-- 		while ch and ch.valid
-- 			if ch.health == bot.starpostnum+1
-- 				--ch = ch2
-- 				table.insert(chxt,ch.x)
-- 				table.insert(chyt,ch.y)
-- 				chs = $ + 1
-- 				break
-- 			end
-- 			ch = $.tracer
-- 		end
		
-- 		for i,v in pairs(chxt) chx = $ + v/FU end
-- 		for i,v in pairs(chyt) chy = $ + v/FU end
-- 		chx,chy = $1/chs,$2/chs
		if not (leveltime%3)
			local dist = 200*FU
			local extent = 14
			local lnc = INT32_MAX
			local lang = 0
			local _,rpos = calculateposition(bot,nil,mo.x,mo.y,mo.z)
			for i=1,extent--ang = 0+mo.angle,ANGLE_180+mo.angle,ANG1*5
				local ang = mo.angle/ANG1/extent*extent*ANG1 + fixangle((i-extent/2)*200*FU/extent)
				local ax = fixmul(cos(ang),dist)
				local ay = fixmul(sin(ang),dist)
				local x,y,z = mo.x+ax,mo.y+ay,mo.z
				local pc,nc = calculateposition(bot,nil,x,y,z)
				local thok = P_SpawnMobjFromMobj(mo,0,0,10*FU,MT_GHOST)
				thok.radius = mo.radius/3*6
				thok.flags = 0
				if not P_TryMove(thok,mo.x+ax*4,mo.y+ay*4)
	-- 				P_RemoveMobj(thok)
	-- 				continue
					nc = $ + 300
				end
				
				thok.flags = thok.info.flags
				if nc < lnc
					lnc = min($,nc)
					lang = ang
				end
				if botoffroad(thok) --offroad discouragement
					if botsneaker(bot)
						nc = $ - 300
					else
						nc = $ + 400
					end
				end
				
				if thok.subsector.sector.damagetype == 7 or thok.subsector.sector.damagetype == 8
					nc = $ + 500
				end
				P_MoveOrigin(thok,x,y,thok.z)
				thok.state = S_INVISIBLE
				thok.sprite = SPR_THOK
				thok.frame = A
				thok.tics = 2+2
				thok.momx,thok.momy,thok.momz = mo.momx,mo.momy,mo.momz
				thok.alpha = max(((rpos-nc)*(dist/FU*2)),0)
				thok.spritexscale = FU/2
			end
			
			mo.botdestang = lang--R_PointToAngle2(mo.x,mo.y,chx*FU,chy*FU)
		end
		
		if mo.botdestang == nil
			mo.botdestang = mo.kartangle
		end
-- 		cmd.angleturn = ang/FU
		local ad = anglefix(mo.botdestang-mo.kartangle)
-- 		print(fixangle(ad)/ANG1)
		if (ad > FU*180)
			ad = $ - FU*360;
		elseif (ad < FU*-180)
			ad = $ + FU*360;
		end
		if ad<-FU
			cmd.sidemove = 50
		elseif ad>FU
			cmd.sidemove = -50
		end
		cmd.forwardmove = 50
		
		--just use the sneaker already!!
		if botsneaker(bot) == 1
			if ((botoffroad(mo) and not (leveltime%8)) or (abs(ad) < FU and not (leveltime%TICRATE)))
				cmd.buttons = $ | BT_CUSTOM3
			end
		elseif botpoweritem(bot)
			if not (leveltime%TICRATE)
				cmd.buttons = $ | BT_CUSTOM3
			end
		elseif (bot.kartstuff[k_itemtype] or bot.kartstuff[k_itemheld])
			if not (leveltime%TICRATE)
				--they don't know what is is, just use it since all the items do "something" now
				cmd.buttons = $ | BT_CUSTOM3
			end
		end
		
		local sm = cmd.sidemove
		cmd.angleturn = (mo.kartangle/FU) - K_GetKartTurnValue(bot, sm*KART_FULLTURN/50*2, false)--*FU
-- 		print(- K_GetKartTurnValue(bot, sm*KART_FULLTURN/50, false))
		
		return true
	end
end)