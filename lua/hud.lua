local KART_FONTSTART = "\""
local KART_FONTEND = "Z"
local KART_FONTSIZE = (KART_FONTEND:byte()-KART_FONTSTART:byte()+1)

local BASEVIDWIDTH = 320 // NEVER CHANGE THIS! This is the original
local BASEVIDHEIGHT = 200 // resolution of the graphics.
local kart_font

local kp_itembg = {}
local kp_itemtimer = {}
local kp_itemmulsticker = {}
local kp_positionnum = {}
local kp_winnernum = {}
local kp_itemx

local kp_superring = {}
local kp_sneaker = {}
local kp_rocketsneaker = {}
local kp_invincibility = {}
local kp_banana = {}
local kp_eggman = {}
local kp_orbinaut = {}
local kp_jawz = {}
local kp_mine = {}
local kp_ballhog = {}
local kp_selfpropelledbomb = {}
local kp_grow = {}
local kp_shrink = {}
local kp_thundershield = {}
local kp_hyudoro = {}
local kp_pogospring = {}
local kp_kitchensink = {}
local kp_sadface = {}
rawset(_G,"kart_speedometer", CV_RegisterVar{name = "kart_speedometer", defaultvalue = "Off", PossibleValue = {Off = 0, Kilometers = 1, Miles = 2, Fracunits = 3, Percent = 4}})

local kart_debugdistr = CV_RegisterVar{name = "kart_debugdistr", defaultvalue = "Off", PossibleValue = CV_OnOff}
local kart_debugcheck = CV_RegisterVar{name = "kart_debugcheck", defaultvalue = "Off", PossibleValue = CV_OnOff}

// Gets string colormap, used for 0x80 color codes
//
local function V_GetStringColormap(colorflags)
	local purplemap = 0x81
	// optimised
	colorflags = ((colorflags & V_CHARCOLORMASK) >> V_CHARCOLORSHIFT);
	if (not colorflags or colorflags > 15) // INT32 is signed, but V_CHARCOLORMASK is a very restrictive mask.
		return nil;
	end
	return (purplemap+((colorflags-1)<<8));
end


// SRB2kart
local function V_DrawKartString(v, x, y, option, ch)
	ch = tostring($)
	local w, c, cx, cy, dupx, dupy, scrwidth, center, left = nil, nil, x, y, nil, nil, nil, 0, 0
-- 	local ch = string;
	local charflags = 0;
	local colormap = nil;
	local spacewidth, charwidth = 12, 0;

	local lowercase = (option & V_ALLOWLOWERCASE);
	option = $ & ~V_FLIP; // which is also shared with V_ALLOWLOWERCASE...

	if (option & V_NOSCALESTART)
		dupx = v.dupx();
		dupy = v.dupy();
		scrwidth = v.width();
	else
		dupx, dupy = 1,1;
		scrwidth = v.width()/v.dupx();
		left = (scrwidth - BASEVIDWIDTH)/2;
	end

	charflags = (option & V_CHARCOLORMASK);
	colormap = V_GetStringColormap(charflags);

	if (option & V_SPACINGMASK) == V_MONOSPACE
		spacewidth = 12;
		/* FALLTHRU */
	elseif (option & V_SPACINGMASK) == V_OLDSPACING
		charwidth = 12;
	elseif (option & V_SPACINGMASK) == V_6WIDTHSPACE
		spacewidth = 6;
	end
	
	local stt = {} ch:gsub(".",function(b)table.insert(stt,b)end)
	for i,ch in pairs(stt)
		if (not ch:byte())
			break;
		end
		if (ch:byte() & 0x80) //color parsing -x 2.16.09
			// manually set flags override color codes
			if (not(option & V_CHARCOLORMASK))
				charflags = ((ch:byte() & 0x7f) << V_CHARCOLORSHIFT) & V_CHARCOLORMASK;
				colormap = V_GetStringColormap(charflags);
			end
			continue;
		end
		if (ch == '\n')
			cx = x;

			if (option & V_RETURN8)
				cy = $ + 8*dupy;
			else
				cy = $ + 12*dupy;
			end
			continue;
		end
		
		local c = ch;
		if (not lowercase)
			c = c:upper();
		end
		c = $:byte()-KART_FONTSTART:byte();

		// character does not exist or is a space
		if (c < 0 or c >= KART_FONTSIZE or not kart_font[c])
			cx = $ + spacewidth * dupx;
			continue;
		end

		if (charwidth)
			w = charwidth * dupx;
			center = w/2 - (kart_font[c].width)*dupx/2;
		else
			w = (kart_font[c].width) * dupx;
		end
		
		if (cx > scrwidth)
			break;
		end
		if (cx+left + w < 0) //left boundary check
			cx = $ + w;
			continue;
		end
		v.drawScaled((cx + center)<<FRACBITS+1*FU, cy<<FRACBITS+1*FU, FRACUNIT, kart_font[c], (option&~V_HUDTRANS)|V_50TRANS, v.getColormap(nil,nil,"AllBlack"));
		v.drawScaled((cx + center)<<FRACBITS, cy<<FRACBITS, FRACUNIT, kart_font[c], option, colormap);
		
		cx = $ + w;
	end
end

local function K_DrawKartPositionNum(v,stplyr,num)
	// POSI_X = BASEVIDWIDTH - 51;	// 269
	// POSI_Y = BASEVIDHEIGHT- 64;	// 136

	local win = (stplyr.exiting and num == 1);
	//INT32 X = POSI_X;
	local W = kp_positionnum[0][0].width;
	local scale = FRACUNIT;
	local localpatch = kp_positionnum[0][0];
	//INT32 splitflags = K_calcSplitFlags(V_SNAPTOBOTTOM|V_SNAPTORIGHT);
	local fx, fy, fflags = 0,0,0;
	local flipdraw = false;	// flip the order we draw it in for MORE splitscreen bs. fun.
	local flipvdraw = false;	// used only for 2p splitscreen so overtaking doesn't make 1P's position fly off the screen.
	local overtake = false;

	if (stplyr.kartstuff[k_positiondelay] or stplyr.exiting)
		scale = $ * 2;
		overtake = true;	// this is used for splitscreen stuff in conjunction with flipdraw.
	end
	if (splitscreen)
		scale = $ / 2;
	end

	W = FixedMul(W<<FRACBITS, scale)>>FRACBITS;

	// pain and suffering defined below
	if (not splitscreen)
		fx = POSI_X;
		fy = BASEVIDHEIGHT - 8;
		fflags = V_SNAPTOBOTTOM|V_SNAPTORIGHT;
	elseif (splitscreen)-- == 1)	// for this splitscreen, we'll use case by case because it's a bit different.
		fx = POSI_X;
		if (stplyr == displayplayer)	// for player 1: display this at the top right, above the minimap.
			fy = 30;
			fflags = V_SNAPTOTOP|V_SNAPTORIGHT;
			if (overtake)
				flipvdraw = true;	// make sure overtaking doesn't explode us
			end
		else	// if we're not p1, that means we're p2. display this at the bottom right, below the minimap.
			fy = BASEVIDHEIGHT - 8;
			fflags = V_SNAPTOBOTTOM|V_SNAPTORIGHT;
		end
	end

	// Special case for 0
	if (not num)
		v.drawScaled(fx<<FRACBITS, fy<<FRACBITS, scale, kp_positionnum[0][0], V_HUDTRANSHALF|fflags, NULL);
		return;
	end

	assert(num >= 0); // This function does not draw negative numbers

	// Draw the number
	while (num)
		if (win) // 1st place winner? You get rainbows!!
			localpatch = kp_winnernum[(leveltime % (6--[[NUMWINFRAMES]]*3)) / 3];
		elseif (stplyr.laps+1 >= cv_numlaps.value or stplyr.exiting) // Check for the final lap, or won
			// Alternate frame every three frames
			local a = leveltime % 9
			if a >= 1 and a <= 3
				if (K_IsPlayerLosing(stplyr))
					localpatch = kp_positionnum[num % 10][4];
				else
					localpatch = kp_positionnum[num % 10][1];
				end
			elseif a >= 4 and a <= 6
				if (K_IsPlayerLosing(stplyr))
					localpatch = kp_positionnum[num % 10][5];
				else
					localpatch = kp_positionnum[num % 10][2];
				end
			elseif a >= 7 and a <= 9
				if (K_IsPlayerLosing(stplyr))
					localpatch = kp_positionnum[num % 10][6];
				else
					localpatch = kp_positionnum[num % 10][3];
				end
			else
				localpatch = kp_positionnum[num % 10][0];
			end
		else
			localpatch = kp_positionnum[num % 10][0];
		end

		v.drawScaled((fx<<FRACBITS) + ((overtake and flipdraw) and ((localpatch.width)*scale/2) or 0), (fy<<FRACBITS) + ((overtake and flipvdraw) and ((localpatch.height)*scale/2) or 0), scale, localpatch, V_HUDTRANSHALF|fflags, NULL);
		// ^ if we overtake as p1 or p3 in splitscren, we shift it so that it doesn't go off screen.
		// ^ if we overtake as p1 in 2p splits, shift vertically so that this doesn't happen either.

		fx = $ - W;
		num = $ / 10;
	end
end

local function K_drawDistributionDebugger(stplyr,v)
	local items = {
		kp_sadface[0],--[1],
		kp_sneaker[0],--[1],
		kp_rocketsneaker[0],--[1],
		kp_invincibility[0],--[7],
		kp_banana[0],--[1],
		kp_eggman[0],--[1],
		kp_orbinaut[1],--[4],
		kp_jawz[0],--[1],
		kp_mine[0],--[1],
		kp_ballhog[0],--[1],
		kp_selfpropelledbomb[0],--[1],
		kp_grow[0],--[1],
		kp_shrink[0],--[1],
		kp_thundershield[0],--[1],
		kp_hyudoro[0],--[1],
		kp_pogospring[0],--[1],
		kp_kitchensink[0],--[1],

		kp_sneaker[0],--[1],
		kp_banana[0],--[1],
		kp_banana[0],--[1],
		kp_orbinaut[3],--[4],
		kp_orbinaut[4],--[4],
		kp_jawz[0],--[1]
	};
	local useodds = 0;
	local pingame, bestbumper = 0, 0;
	local x, y = -9, -9;
	local dontforcespb = false;
	local spbrush = false;

	if (stplyr != displayplayer)--&players[displayplayers[0]]) // only for p1
		return;
	end

	// The only code duplication from the Kart, just to avoid the actual item function from calculating pingame twice
	for p in players.iterate
		if (not p.valid or p.spectator or not p.kart)
			continue;
		end
		pingame = $ + 1;
		if (p.exiting)
			dontforcespb = true;
		end
		if (p.kartstuff[k_bumper] > bestbumper)
			bestbumper = p.kartstuff[k_bumper];
		end
	end

-- 	if (G_RaceGametype())
-- 		spbrush = (spbplace != -1 && stplyr->kartstuff[k_position] == spbplace+1);

	useodds = K_FindUseodds(stplyr, 0, pingame, bestbumper, spbrush, dontforcespb);

	for i = 1, NUMKARTRESULTS-1
		local itemodds = K_KartGetItemOdds(useodds, i, 0, spbrush);
		if (itemodds <= 0)
			continue;
		end

		v.drawScaled(x*FU+9*FU, y*FU+9*FU, FU*2/3, items[i+1], V_HUDTRANS|V_SNAPTOTOP);
		v.drawString(x+11, y+31, string.format("%d", itemodds), V_HUDTRANS|V_SNAPTOTOP, "thin");

		// Display amount for multi-items
		if (i >= NUMKARTITEMS)
			local amount;
			if i == KRITEM_TENFOLDBANANA
				amount = 10;
			elseif i == KRITEM_QUADORBINAUT
				amount = 4;
			elseif i == KRITEM_DUALJAWZ
				amount = 2;
			else
				amount = 3;
			end
			v.drawString(x+24, y+31, string.format("x%d", amount), V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOTOP);
		end

		x = $ + 32;
		if (x >= 297)
			x = -9;
			y = $ + 32;
		end
	end

	v.drawString(0, 0, string.format("USEODDS %d", useodds), V_HUDTRANS|V_SNAPTOTOP);
end

local function K_drawCheckpointDebugger(player,v)
	if player ~= displayplayer return end
	
	if player.starpostnum >= (numstarposts - (numstarposts/2))
		v.drawString(8,184,string.format("Checkpoint: %d / %d (Can finish)", player.starpostnum, numstarposts),V_ALLOWLOWERCASE)
	else
		v.drawString(8,184,string.format("Checkpoint: %d / %d (Skip: %d)", player.starpostnum, numstarposts, (numstarposts/2) + player.starpostnum),V_ALLOWLOWERCASE)
	end
	
	v.drawString(8,192,string.format("Waypoint dist: Prev %d, Next %d", player.kartstuff[k_prevcheck], player.kartstuff[k_nextcheck]),V_ALLOWLOWERCASE)
end

local function K_drawKartTimestamp(v,drawtime,TX,TY,emblemmap,mode,pcol)
	local worktime
	
	local splitflags = 0
	if not mode
		splitflags = V_HUDTRANS|V_PERPLAYER|V_SNAPTOTOP|V_SNAPTOLEFT--RIGHT
-- 		if drawtime >= (timelimitintics or 0) --port from orbit
-- 			drawtime = 0
-- 		else
-- 			drawtime = (timelimitintics or 0)-$
-- 		end
	end
	
	v.draw(TX+1,TY+1,(mode==2 and v.cachePatch("K_STLAPW") or v.cachePatch("K_STTIMW")),(splitflags&~V_HUDTRANS)|V_50TRANS,v.getColormap(nil,nil,"AllBlack"))
	v.draw(TX,TY,(mode==2 and v.cachePatch("K_STLAPW") or v.cachePatch("K_STTIMW")),splitflags,pcol)
	
	TX = $ + 33
	worktime = drawtime/(60*TICRATE)
	
	if mode and not drawtime
		V_DrawKartString(v,TX,TY+3,splitflags,"--:--.--")
	elseif worktime < 100
		if worktime < 10
			V_DrawKartString(v,TX,TY+3,splitflags,"0")
			V_DrawKartString(v,TX+12,TY+3,splitflags,worktime)
		else
			V_DrawKartString(v,TX,TY+3,splitflags,worktime)
		end
		
		V_DrawKartString(v,TX+24,TY+3,splitflags,":")
		worktime = (drawtime/TICRATE % 60)
		
		if worktime < 10
			V_DrawKartString(v,TX+36,TY+3,splitflags,"0")
			V_DrawKartString(v,TX+48,TY+3,splitflags,worktime)
		else
			V_DrawKartString(v,TX+36,TY+3,splitflags,worktime)
		end
		
		V_DrawKartString(v,TX+60,TY+3,splitflags,".")
		worktime = G_TicsToCentiseconds(drawtime)
		
		if worktime < 10
			V_DrawKartString(v,TX+72,TY+3,splitflags,"0")
			V_DrawKartString(v,TX+84,TY+3,splitflags,worktime)
		else
			V_DrawKartString(v,TX+72,TY+3,splitflags,worktime)
		end
	elseif (drawtime/TICRATE) & 1
		V_DrawKartString(v,TX,TY+3,splitflags,"99:59.99")
	end
	
	if emblemmap and (modeattacking or mode == 1) and not demoplayback
		--emblems
	end
end

local function K_drawKartLaps(v,player,pcol)
	local splitflags = V_PERPLAYER|V_SNAPTOBOTTOM|V_SNAPTOLEFT
	local fx,fy,fflags = 0,0,0
	local flipstring = false
	local stringw = 0
	
	if splitscreen
		if true --2 player
			fx = LAPS_X
			fy = LAPS_Y
			fflags = splitflags
		else
			--..
		end
		
		if player.exiting
-- 			v.draw(fx,fy,v.cachePatch("K_SPTLAP"),V_HUDTRANS|fflags)
			v.drawString(fx+13,fy+1,"FIN",V_HUDTRANS|fflags)
		else
			if flipstring
				--..
			else
-- 				v.draw(fx,fy,v.cachePatch("K_SPTLAP"),V_HUDTRANS|fflags)
				v.drawString(fx+13,fy+1,(player.laps+1).."/"..cv_numlaps.value,V_HUDTRANS|fflags)
			end
		end
	else
		v.draw(LAPS_X+1,LAPS_Y+1,v.cachePatch("K_STLAPS"),(splitflags&~V_HUDTRANS)|V_50TRANS,v.getColormap(nil,nil,"AllBlack"))
		v.draw(LAPS_X,LAPS_Y,v.cachePatch("K_STLAPS"),V_HUDTRANS|splitflags,pcol)
		if player.exiting
			V_DrawKartString(v,LAPS_X+33,LAPS_Y+3,V_HUDTRANS|splitflags,"FIN")
		else
			V_DrawKartString(v,LAPS_X+33,LAPS_Y+3,V_HUDTRANS|splitflags,(player.laps+1).."/"..cv_numlaps.value)
		end
	end
end

local function K_drawKartFreePlay(v,flashtime)
	if (flashtime%TICRATE) < TICRATE/2
		return
	end
	
	V_DrawKartString(v,BASEVIDWIDTH-(LAPS_X+1)-(12*9),LAPS_Y+3,V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_HUDTRANS, "FREE PLAY")
end

local function drawTrueCrop(v,x,y,scw,sch,patch,flags,col,ll,lr,lu,ld)
-- 	print(ll/FU,lr/FU,lu/FU,ld/FU)
-- 	sch = $*2/3
	local w = patch.width*FU
	local h = patch.height*FU
	ll = $+fixmul(patch.leftoffset*FU,scw)
	lr = $+fixmul(patch.leftoffset*FU,scw)
	lu = $+fixmul(patch.topoffset*FU,sch)
	ld = $+fixmul(patch.topoffset*FU,sch)
	local l = min(max(fixdiv(ll-x,scw),0),w)
	local u = min(max(fixdiv(lu-y,sch),0),h)
	local r = max(fixdiv(lr-x-l,scw),0)
	local d = max(fixdiv(ld-y-u,sch),0)
	v.drawCropped(x+fixmul(l,scw),y+fixmul(u,sch),scw,sch,patch,flags,col,l,u,r,d)
end

local SPDM_X = 9
local SPDM_Y = BASEVIDHEIGHT - 45 --155

hud.add(function(v,player)
	if not player.kart or not player.kartstuff return end
	
	if not kart_font
		kart_font = {}
		for i = 0,KART_FONTSIZE
			// cache the heads-up font for entire game execution
		-- 	sprintf(buffer, "MKFNT%.3d", j);
			local fnt = string.format("MKFNT%.3d",i+KART_FONTSTART:byte())
		 	if (not v.patchExists(fnt))
		 		kart_font[i] = nil;
		 	else
				kart_font[i] = v.cachePatch(fnt)--(patch_t *)W_CachePatchName(buffer, PU_HUDGFX);
		 	end
		end
		
		// Kart Item Windows
		kp_itembg[0] = 				v.cachePatch("K_ITBG", PU_HUDGFX);
		kp_itembg[1] = 				v.cachePatch("K_ITBGD", PU_HUDGFX);
		kp_itemtimer[0] = 			v.cachePatch("K_ITIMER", PU_HUDGFX);
		kp_itemmulsticker[0] = 		v.cachePatch("K_ITMUL", PU_HUDGFX);
		kp_itemx = 					v.cachePatch("K_ITX", PU_HUDGFX);

		kp_superring[0] =				"K_ITRING";
		kp_sneaker[0] =				"K_ITSHOE";
		kp_rocketsneaker[0] =		"K_ITRSHE";

		for i=0,6
			kp_invincibility[i] = "K_ITINV"..i+1;
		end
		kp_banana[0] =				"K_ITBANA";
		kp_eggman[0] =				"K_ITEGGM";
		for i=1,4
			kp_orbinaut[i] = "K_ITORB"..i;
		end
		kp_jawz[0] =				"K_ITJAWZ";
		kp_mine[0] =				"K_ITMINE";
		kp_ballhog[0] =				"K_ITBHOG";
		kp_selfpropelledbomb[0] =	"K_ITSPB";
		kp_grow[0] =				"K_ITGROW";
		kp_shrink[0] =				"K_ITSHRK";
		kp_thundershield[0] =		"K_ITTHNS";
		kp_hyudoro[0] = 			"K_ITHYUD";
		kp_pogospring[0] = 			"K_ITPOGO";
		kp_kitchensink[0] = 		"K_ITSINK";
		kp_sadface[0] = 			"K_ITSAD";
		
		for i=0,9
			kp_positionnum[i] = {}
			for ii = 0,6
				kp_positionnum[i][ii] = v.cachePatch("K_POSN"..i..ii, PU_HUDGFX);
			end
		end
		
		for i=0,5
			kp_winnernum[i] = v.cachePatch("K_POSNW"..i, PU_HUDGFX);
		end
	end
	
	local pcol = v.getColormap(nil,player.skincolor)
	if kart_speedometer.value
		local splitflags = (V_SNAPTOBOTTOM|V_SNAPTOLEFT)|V_PERPLAYER;
		
		if kart_speedometer.value == 1 --k is a kilometer
			local convSpeed = FixedDiv(FixedMul(player.speed, 142371), mapobjectscale)/FRACUNIT; // 2.172409058
			V_DrawKartString(v, SPDM_X, SPDM_Y, V_HUDTRANS|splitflags, string.format("%3d km/h", convSpeed));
		elseif kart_speedometer.value == 2 --mph
			local convSpeed = FixedDiv(FixedMul(player.speed, 88465), mapobjectscale)/FRACUNIT; // 1.349868774
			V_DrawKartString(v, SPDM_X, SPDM_Y, V_HUDTRANS|splitflags, string.format("%3d mph", convSpeed));
		elseif kart_speedometer.value == 3 --fracunits
			local convSpeed = FixedDiv(player.speed, mapobjectscale)/FRACUNIT; // 1.349868774
			V_DrawKartString(v, SPDM_X, SPDM_Y, V_HUDTRANS|splitflags, string.format("%3d fu/t", convSpeed));
		elseif kart_speedometer.value == 4 --percent
			local convSpeed = player.speed*100/K_GetKartSpeed(player); // 1.349868774
			V_DrawKartString(v, SPDM_X, SPDM_Y, V_HUDTRANS|splitflags, string.format("%3d", convSpeed).." %");
		end
	end
	
	local ps = 0
	for player in players.iterate
		if player and player.kart
			ps = $ + 1
		end
	end
	
	if ps == 1
		K_drawKartFreePlay(v,leveltime)
	else
		K_DrawKartPositionNum(v,player,player.kartstuff[k_position])--1)
	end
	
	if player == consoleplayer
		hud.disable("score")
		hud.disable("time")
		hud.disable("rings")
		hud.disable("lives")
		hud.disable("textspectator")
	end
	
	K_drawKartTimestamp(v,player.realtime,TIME_X,TIME_Y,gamemap,0,pcol)
	K_drawKartLaps(v,player,pcol)
	
	if kart_debugdistr.value
		K_drawDistributionDebugger(player,v)
	end
	
	if kart_debugcheck.value
		K_drawCheckpointDebugger(player,v)
	end
	
	// ITEM_X = BASEVIDWIDTH-50;	// 270
	// ITEM_Y = 24;					//  24

	// Why write V_DrawScaledPatch calls over and over when they're all the same?
	// Set to 'no item' just in case.
	local offset = 0;--((splitscreen > 1) ? 1 : 0);
	local localpatch = kp_nodraw;
	local localbg = ((offset) and kp_itembg[2] or kp_itembg[0]);
	local localinv = ((offset) and kp_invincibility[((leveltime % (6*3)) / 3) + 7] or kp_invincibility[(leveltime % (7*3)) / 3]);
	local fx,fy,fflags = 0,0,0;	// final coords for hud and flags...
	//INT32 splitflags = K_calcSplitFlags(V_SNAPTOTOP|V_SNAPTOLEFT);
	local numberdisplaymin = ((not offset and player.kartstuff[k_itemtype] == KITEM_ORBINAUT) and 5 or 2);
	local itembar = 0;
	local maxl = 0; // itembar's normal highest value
	local barlength = 26--(splitscreen > 1 ? 12 : 26);
	local localcolor = SKINCOLOR_NONE;
	local colormode = TC_RAINBOW;
	local colmap = nil;
	local flipamount = false;	// Used for 3P/4P splitscreen to flip item amount stuff

	local r = (player.kartstuff[k_itemroulette] % (15*3)) / 3
	if (player.kartstuff[k_itemroulette])
		if (player.skincolor)
			localcolor = player.skincolor;
		end

		// Each case is handled in threes, to give three frames of in-game time to see the item on the roulette
		if r == 0 // Sneaker
			localpatch = kp_sneaker[offset];
			//localcolor = SKINCOLOR_RASPBERRY;
		elseif r == 1 // Banana
			localpatch = kp_banana[offset];
			//localcolor = SKINCOLOR_YELLOW;
		elseif r == 2 // Orbinaut
			localpatch = kp_orbinaut[3+offset-2];
			//localcolor = SKINCOLOR_STEEL;
		elseif r == 3 // Mine
			localpatch = kp_mine[offset];
			//localcolor = SKINCOLOR_JET;
		elseif r == 4 // Grow
			localpatch = kp_grow[offset];
			//localcolor = SKINCOLOR_TEAL;
		elseif r == 5 // Hyudoro
			localpatch = kp_hyudoro[offset];
			//localcolor = SKINCOLOR_STEEL;
		elseif r == 6 // Rocket Sneaker
			localpatch = kp_rocketsneaker[offset];
			//localcolor = SKINCOLOR_TANGERINE;
		elseif r == 7 // Jawz
			localpatch = kp_jawz[offset];
			//localcolor = SKINCOLOR_JAWZ;
		elseif r == 8 // Self-Propelled Bomb
			localpatch = kp_selfpropelledbomb[offset];
			//localcolor = SKINCOLOR_JET;
		elseif r == 9 // Shrink
			localpatch = kp_shrink[offset];
			//localcolor = SKINCOLOR_ORANGE;
		elseif r == 10 // Invincibility
			localpatch = localinv;
			//localcolor = SKINCOLOR_GREY;
		elseif r == 11 // Eggman Monitor
			localpatch = kp_eggman[offset];
			//localcolor = SKINCOLOR_ROSE;
		elseif r == 12 // Ballhog
			localpatch = kp_ballhog[offset];
			//localcolor = SKINCOLOR_LILAC;
		elseif r == 13 // Thunder Shield
			localpatch = kp_thundershield[offset];
			//localcolor = SKINCOLOR_CYAN;
		elseif r == 14 // Super Ring
			localpatch = kp_superring[offset];
			//localcolor = SKINCOLOR_GOLD;
		/*elseif r == 15 // Pogo Spring
			localpatch = kp_pogospring[offset];
			localcolor = SKINCOLOR_TANGERINE;
		elseif r == 16 // Kitchen Sink
			localpatch = kp_kitchensink[offset];
			localcolor = SKINCOLOR_STEEL;*/
		end
	else
		// I'm doing this a little weird and drawing mostly in reverse order
		// The only actual reason is to make sneakers line up this way in the code below
		// This shouldn't have any actual baring over how it functions
		// Hyudoro is first, because we're drawing it on top of the player's current item
		if (player.kartstuff[k_stolentimer] > 0)
			if (leveltime & 2)
				localpatch = kp_hyudoro[offset];
			else
				localpatch = kp_nodraw;
			end
		elseif ((player.kartstuff[k_stealingtimer] > 0) and (leveltime & 2))
			localpatch = kp_hyudoro[offset];
		elseif (player.kartstuff[k_eggmanexplode] > 1)
			if (leveltime & 1)
				localpatch = kp_eggman[offset];
			else
				localpatch = kp_nodraw;
			end
		elseif (player.kartstuff[k_rocketsneakertimer] > 1)
			itembar = player.kartstuff[k_rocketsneakertimer];
			maxl = (itemtime*3) - barlength;

			if (leveltime & 1)
				localpatch = kp_rocketsneaker[offset];
			else
				localpatch = kp_nodraw;
			end
		elseif (player.kartstuff[k_growshrinktimer] > 0) and not kart_rrpoweritems.value
			if (player.kartstuff[k_growcancel] > 0)
				itembar = player.kartstuff[k_growcancel];
				maxl = 26;
			end

			if (leveltime & 1)
				localpatch = kp_grow[offset];
			else
				localpatch = kp_nodraw;
			end
		elseif (player.kartstuff[k_sadtimer] > 0)
			if (leveltime & 2)
				localpatch = kp_sadface[offset];
			else
				localpatch = kp_nodraw;
			end
		else
			if (player.kartstuff[k_itemamount] == 0)--<= 0)
				return;
			end

			local r = player.kartstuff[k_itemtype]
			if r == KITEM_SUPERRING
				localpatch = kp_superring[offset];
			elseif r == KITEM_SNEAKER
				localpatch = kp_sneaker[offset];
			elseif r == KITEM_ROCKETSNEAKER
				localpatch = kp_rocketsneaker[offset];
			elseif r == KITEM_INVINCIBILITY
				localpatch = localinv;
-- 				localbg = kp_itembg[offset+1];
			elseif r == KITEM_BANANA
				localpatch = kp_banana[offset];
			elseif r == KITEM_EGGMAN
				localpatch = kp_eggman[offset];
			elseif r == KITEM_ORBINAUT
				localpatch = kp_orbinaut[(offset and 4 or min(player.kartstuff[k_itemamount]-1+1, 3-2))];
			elseif r == KITEM_JAWZ
				localpatch = kp_jawz[offset];
			elseif r == KITEM_MINE
				localpatch = kp_mine[offset];
			elseif r == KITEM_BALLHOG
				localpatch = kp_ballhog[offset];
			elseif r == KITEM_SPB
				localpatch = kp_selfpropelledbomb[offset];
-- 				localbg = kp_itembg[offset+1];
			elseif r == KITEM_GROW
				localpatch = kp_grow[offset];
			elseif r == KITEM_SHRINK
				localpatch = kp_shrink[offset];
			elseif r == KITEM_THUNDERSHIELD
				localpatch = kp_thundershield[offset];
-- 				localbg = kp_itembg[offset+1];
			elseif r == KITEM_HYUDORO
				localpatch = kp_hyudoro[offset];
			elseif r == KITEM_POGOSPRING
				localpatch = kp_pogospring[offset];
			elseif r == KITEM_KITCHENSINK
				localpatch = kp_kitchensink[offset];
			elseif r == KITEM_SAD
				localpatch = kp_sadface[offset];
			else
				return
			end

			if (player.kartstuff[k_itemheld] and not (leveltime & 1))
				localpatch = kp_nodraw;
			end
		end

		if (player.kartstuff[k_itemblink] and (leveltime & 1))
			colormode = TC_BLINK;

			local r = player.kartstuff[k_itemblinkmode]
			if r == 2
				localcolor = (1 + (leveltime % (#skincolors-1)));
			elseif r == 1
				localcolor = SKINCOLOR_RED;
			else
				localcolor = SKINCOLOR_WHITE;
			end
		end
	end

	// pain and suffering defined below
-- 	if (splitscreen < 2) // don't change shit for THIS splitscreen.
-- 	{
		fx = ITEM_X;
		fy = ITEM_Y*FU;
		fflags = V_SNAPTOTOP|V_SNAPTORIGHT|V_PERPLAYER--K_calcSplitFlags(V_SNAPTOTOP|V_SNAPTOLEFT);
-- 	}
-- 	else // now we're having a fun game.
-- 	{
-- 		if (player == &players[displayplayers[0]] || player == &players[displayplayers[2]]) // If we are P1 or P3...
-- 		{
-- 			fx = ITEM_X;
-- 			fy = ITEM_Y;
-- 			fflags = V_SNAPTOLEFT|((player == &players[displayplayers[2]]) ? V_SPLITSCREEN : V_SNAPTOTOP); // flip P3 to the bottom.
-- 		}
-- 		else // else, that means we're P2 or P4.
-- 		{
-- 			fx = ITEM2_X;
-- 			fy = ITEM2_Y;
-- 			fflags = V_SNAPTORIGHT|((player == &players[displayplayers[3]]) ? V_SPLITSCREEN : V_SNAPTOTOP); // flip P4 to the bottom
-- 			flipamount = true;
-- 		}
-- 	}

	if (localcolor != SKINCOLOR_NONE)
		colmap = v.getColormap(colormode, localcolor, GTC_CACHE);
	end

	v.draw(fx+1,fy/FU+1,localbg,(fflags&~V_HUDTRANS)|V_50TRANS,v.getColormap(nil,nil,"AllBlack"))
	v.draw(fx, fy/FU, localbg, V_HUDTRANS|fflags, pcol);

	if kart_rrroulette.value and player.kartstuff[k_itemroulette] and not player.kartdead
		local fancystep = offset and 6 or 10
		local fancyoffset = ((player.kartstuff[k_itemroulette]*FU)%(3*FU))-1*FU
		if fancyoffset
			fflags = $ & ~V_HUDTRANS
			fflags = $ | V_HUDTRANSHALF
		end
		fy = $ + (fancystep*fancyoffset) + fixmul(fancystep*FU,FU)-fancystep/2*FU
	end

	// Then, the numbers:
	if localpatch
		if kart_rrroulette.value and player.kartstuff[k_itemroulette]
-- 			print(fy/FU)
			if v.interpolate
				v.interpolate(67+r)
			end
			drawTrueCrop(v,fx*FU,fy,FU,FU,v.cachePatch(localpatch),V_HUDTRANS|fflags,colmap,(ITEM_X+7)*FU,(ITEM_X+42)*FU,(ITEM_Y+7)*FU,(ITEM_Y+42)*FU)
			if v.interpolate
				v.interpolate(false)
			end
-- 			v.drawFill(0,(ITEM_Y+9),320,1,0)v.drawFill(0,(ITEM_Y+40),320,1,0)
-- 			v.drawFill((ITEM_X+9),0,1,200,0)v.drawFill((ITEM_X+40),0,1,200,0)
		else
			v.drawScaled(fx<<FRACBITS, fy, FRACUNIT, v.cachePatch(localpatch), V_HUDTRANS|fflags, colmap);
		end
	end
	if ((player.kartstuff[k_itemamount] >= numberdisplaymin or player.kartstuff[k_itemamount] < 0) and not player.kartstuff[k_itemroulette])
		v.draw(fx + (flipamount and 48 or 0), fy/FU, kp_itemmulsticker[offset], V_HUDTRANS|fflags|(flipamount and V_FLIP or 0)); // flip this graphic for p2 and p4 in split and shift it.
		if (offset)
			if (flipamount) // reminder that this is for 3/4p's right end of the screen.
				v.drawString(fx+2, fy/FU+31, string.format("x%d", player.kartstuff[k_itemamount]), V_ALLOWLOWERCASE|V_HUDTRANS|fflags);
			else
				v.drawString(fx+24, fy/FU+31, string.format("x%d", player.kartstuff[k_itemamount]), V_ALLOWLOWERCASE|V_HUDTRANS|fflags);
			end
		else
			v.draw(fx+28 --[[kart]], fy+41, kp_itemx, V_HUDTRANS|fflags);
			V_DrawKartString(v,fx+38, fy/FU+36, V_HUDTRANS|fflags, string.format("%d", player.kartstuff[k_itemamount]));
		end
	end

	// Extensible meter, currently only used for rocket sneaker...
	if (itembar)-- and hudtrans)
		local fill = ((itembar*barlength)/maxl);
		local length = min(barlength, fill);
		local height = (offset and 1 or 2);
		local x = (offset and 17 or 11);
		local y = (offset and 27 or 35);

		v.draw(fx+x, fy+y, kp_itemtimer[offset], V_HUDTRANS|fflags);
		// The left dark "AA" edge
		v.drawFill(fx+x+1, fy+y+1, (length == 2 and 2 or 1), height, 12|fflags);
		// The bar itself
		if (length > 2)
			v.drawFill(fx+x+length, fy+y+1, 1, height, 12|fflags); // the right one
			if (height == 2)
				v.drawFill(fx+x+2, fy+y+2, length-2, 1, 8|fflags); // the dulled underside
			end
			v.drawFill(fx+x+2, fy+y+1, length-2, 1, 0|fflags);--120|fflags); // the shine
		end
	end

	// Quick Eggman numbers
	if (player.kartstuff[k_eggmanexplode] > 1 /*&& player.kartstuff[k_eggmanexplode] <= 3*TICRATE*/)
		v.draw(fx+17, fy+13-offset, kp_eggnum[min(3, G_TicsToSeconds(player.kartstuff[k_eggmanexplode]))], V_HUDTRANS|fflags);
	end
end,"game")