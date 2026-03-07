

function A_SPBChase(actor)
	indirectitemcooldown = 20*TICRATE
	local player
	local i
	local bestrank = UINT8_MAX
	local dist
	local hang,vang
	local wspeed,xyspeed,zspeed
	
	wspeed = actor.movefactor
	if actor.threshold
		actor.lastlook = -1
		spbplace = -1
		P_InstaThrust(actor,actor.angle,wspeed)
		actor.flags = $ & ~MF_NOCLIPTHING
		actor.threshold = $ - 1
		return
	end
	
	for p in players.iterate
		if p and p.mo and not p.exiting and p.kart
			if p.kartstuff[k_position] < bestrank
				bestrank = p.kartstuff[k_position]
				player = p
			end
		end
	end
	
	if actor.extravalue1 == 1
		if actor.tracer and actor.tracer.health and not (actor.tracer.player and actor.tracer.player.spectator)
			local defspeed = wspeed
			local range = 160*actor.tracer.scale
			local cx,cy = 0,0
			
			actor.flags = $ & ~MF_NOCLIPTHING
			if not S_SoundPlaying(actor,actor.info.activesound)
				S_StartSound(actor,actor.info.activesound)
			end
			
			if actor.tracer.player
				local fracmax = 32
				local spark = ((10-actor.tracer.player.kartspeed)+actor.tracer.player.kartweight)/2
				local easiness = ((actor.tracer.player.kartspeed+(10+spark))*FU)/2
				
				actor.lastlook = #actor.tracer.player
				
				if not P_IsObjectOnGround(actor.tracer)
					defspeed = 7*actor.tracer.player.speed/8
				else
					defspeed = fixmul(((fracmax+1)*FU)-easiness,K_GetKartSpeed(actor.tracer.player))/fracmax
				end
				
				cx = actor.tracer.player.cmomx
				cy = actor.tracer.player.cmomy
				
				if actor.tracer.player.kartstuff[k_position] <= bestrank
					actor.extravalue2 = 7*TICRATE
				else
					actor.extravalue2 = $ - 1
					if actor.extravalue2 <= 0
						actor.extravalue1 = 0
					end
				end
				
				spbplace = actor.tracer.player.kartstuff[k_position]
			end
			
			dist = P_AproxDistance(P_AproxDistance(actor.x-actor.tracer.x,actor.y-actor.tracer.y),actor.z-actor.tracer.z)
			wspeed = fixmul(defspeed,FU+fixdiv(dist-range,range))
			
			wspeed = max($,defspeed)
			wspeed = min($,defspeed*3/2)
			wspeed = max($,actor.tracer.scale*20)
			if actor.tracer.player.pflags & PF_SLIDING
				wspeed = actor.tracer.player.speed/2
			end
			
			hang = R_PointToAngle2(actor.x,actor.y,actor.tracer.x,actor.tracer.y)
			vang = R_PointToAngle2(0,actor.z,dist,actor.tracer.z)
			
			if wspeed > actor.cvmem
				actor.cvmem = $ + (wspeed-actor.cvmem)/TICRATE
			else
				actor.cvmem = wspeed
			end
			
			local input = anglefix(hang - actor.angle)
			if (input > FU*180)
				input = $ - FU*360;
			elseif (input < FU*-180)
				input = $ + FU*360;
			end
			
			xyspeed = fixmul(actor.cvmem,max(0,(((180*FU)-input)/90)-FU))
			input = fixangle($/4)
-- 			if invert input = InvAngle($) end
			actor.angle = $ + input
			
			input = anglefix(vang - actor.movedir)
			if (input > FU*180)
				input = $ - FU*360;
			elseif (input < FU*-180)
				input = $ + FU*360;
			end
-- 			local invert = input>ANGLE_180
-- 			if invert input = InvAngle($) end
			zspeed = fixmul(actor.cvmem,max(0,(((180*FU)-input)/90)-FU))
			input = fixangle($/4)
-- 			if invert input = InvAngle($) end
			actor.movedir = $ + input
			
			actor.momx = cx + fixmul(fixmul(xyspeed,cos(actor.angle)),cos(actor.movedir))
			actor.momy = cy + fixmul(fixmul(xyspeed,sin(actor.angle)),cos(actor.movedir))
			actor.momz = fixmul(zspeed,sin(actor.movedir))
			
			if R_PointToDist2(0,0,actor.momx,actor.momy) > (actor.tracer.player and actor.tracer.player.speed/15*16 or R_PointToDist2(0,0,actor.tracer.momx,actor.tracer.momy)/15*16)
			and xyspeed > K_GetKartSpeed(actor.tracer.player)/4
				local fast = P_SpawnMobj(actor.x + (P_RandomRange(-24,24) * actor.scale),
					actor.y + (P_RandomRange(-24,24) * actor.scale),
					actor.z + (actor.height/2) + (P_RandomRange(-24,24) * actor.scale),
					MT_THOK);--FASTLINE);
				fast.state = S_FASTLINE1
				fast.scale = mapobjectscale
				fast.angle = R_PointToAngle2(0, 0, actor.momx, actor.momy);
-- 				fast.momx = 3*mo.momx/4;
-- 				fast.momy = 3*mo.momy/4;
-- 				fast.momz = 3*mo.momz/4;
				fast.color = SKINCOLOR_RED
				fast.colorized = true
				fast.target = actor; // easier lua access
				K_MatchGenericExtraFlags(fast, actor);
			end
			
			return
		else
			actor.tracer = nil
			actor.extravalue1 = 2
			actor.extravalue2 = 52
			return
		end
	elseif actor.extravalue1 == 2
		actor.momx,actor.momy,actor.momz = 0,0,0
		actor.flags = $ | MF_NOCLIPTHING
		
		if actor.lastlook ~= -1 and players[actor.lastlook] and players[actor.lastlook].mo
		and players[actor.lastlook].kart and not players[actor.lastlook].exiting
			spbplace = players[actor.lastlook].kartstuff[k_position]
			actor.extravalue2 = $ - 1
			if actor.extravalue2 <= 0 and players[actor.lastlook].mo
				actor.tracer = players[actor.lastlook].mo
				actor.extravalue1 = 1
				actor.extravalue2 = TICRATE*7
				actor.cvmem = wspeed
			end
		else
			actor.extravalue1 = 0
			actor.extravalue2 = 0
			spbplace = -1
		end
	else
		actor.lastlook = -1
		if not player or not player.mo or not player.kart or not player.mo.health or player.kartstuff[k_respawn]
			actor.momx,actor.momy,actor.momz = 0,0,0
			if not player
				spbplace = -1
				return
			end
		end
		
		actor.flags = $ | MF_NOCLIPTHING
		actor.tracer = player.mo
		spbplace = bestrank
		dist = P_AproxDistance(P_AproxDistance(actor.x-actor.tracer.x,actor.y-actor.tracer.y),actor.z-actor.tracer.z)
		
		hang = R_PointToAngle2(actor.x,actor.y,actor.tracer.x,actor.tracer.y)
		vang = R_PointToAngle2(0,actor.z,dist,actor.tracer.z)
		
		local input = anglefix(hang - actor.angle)
		if (input > FU*180)
			input = $ - FU*360;
		elseif (input < FU*-180)
			input = $ + FU*360;
		end
-- 		local invert = input>ANGLE_180
		xyspeed = fixmul(actor.cvmem,max(0,(((180*FU)-input)/90)-FU))
		input = fixangle($/4)
		actor.angle = $ + input
		
		input = anglefix(vang - actor.movedir)
		if (input > FU*180)
			input = $ - FU*360;
		elseif (input < FU*-180)
			input = $ + FU*360;
		end
		zspeed = fixmul(actor.cvmem,max(0,(((180*FU)-input)/90)-FU))
		input = fixangle($/4)
		actor.movedir = $ + input
		
		actor.momx = fixmul(fixmul(xyspeed,cos(actor.angle)),cos(actor.movedir))
		actor.momy = fixmul(fixmul(xyspeed,sin(actor.angle)),cos(actor.movedir))
		actor.momz = fixmul(zspeed,sin(actor.movedir))
		
		if dist <= actor.tracer.scale*3072
			S_StartSound(actor,actor.info.attacksound)
			actor.extravalue1 = 1
			actor.extravalue2 = TICRATE*7
			actor.cvmem = wspeed
		end
	end
end