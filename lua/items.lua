--ite

local ORIG_FRICTION = 62914
local kart_debugitem = CV_RegisterVar{name = "kart_debugitem", defaultvalue = 0, PossibleValue = CV_Unsigned, flags = CV_NETVAR}
local kart_debugamount = CV_RegisterVar{name = "kart_debugamount", defaultvalue = 1, PossibleValue = CV_Unsigned, flags = CV_NETVAR}
rawset(_G,"kart_rrroulette", CV_RegisterVar{name = "kart_rrroulette", defaultvalue = "On", PossibleValue = CV_OnOff, flags = CV_NETVAR})
rawset(_G,"kart_invinsfx", CV_RegisterVar{name = "kart_invinsfx", defaultvalue = "SFX", PossibleValue = {Music = 0, SFX = 1}, flags = CV_NETVAR*0})
rawset(_G,"indirectitemcooldown", 0)
rawset(_G,"hyubgone", 0)
rawset(_G,"spbplace",0)

addHook("NetVars",function(net)
	indirectitemcooldown = net($)
	hyubgone = net($)
	spbplace = net($)
end)

freeslot("SPR_BOST", "S_BOOSTFLAME", "S_BOOSTSMOKESPAWNER", "MT_BOOSTFLAME", "SPR_KFRE", "S_KARTFIRE1", "S_KARTFIRE2")
states[S_BOOSTFLAME] = {SPR_BOST, FF_FULLBRIGHT|FF_ANIMATE, TICRATE, nil, 6, 1, S_BOOSTSMOKESPAWNER}
states[S_BOOSTSMOKESPAWNER] = {SPR_NULL, 0, TICRATE/2, nil, 0, 0, S_NULL}

states[S_KARTFIRE1] = {SPR_NULL, 0, 10, nil, 0, 0, S_KARTFIRE2}
states[S_KARTFIRE2] = {SPR_KFRE, FF_FULLBRIGHT|FF_ANIMATE, 2*7, nil, 7-1, 2, S_NULL}

mobjinfo[MT_BOOSTFLAME] = {
	spawnstate = S_BOOSTFLAME,
	reactiontime = 8,
	speed = 8,
	radius = 32*FU,
	height = 64*FU,
	displayoffset = 1,
	mass = 100,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY,
}

freeslot("SPR_BOSM", "S_BOOSTSMOKE1", "MT_BOOSTSMOKE")
states[S_BOOSTSMOKE1] = {SPR_BOSM, FF_TRANS50|FF_ANIMATE, 3*6, nil, 6-1, 3, S_BOOSTSMOKESPAWNER}

mobjinfo[MT_BOOSTSMOKE] = {
	spawnstate = S_BOOSTSMOKE1,
	reactiontime = 8,
	speed = 8,
	radius = 8*FU,
	height = 8*FU,
	displayoffset = 1,
	mass = 100,
	flags = MF_NOBLOCKMAP|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_SCENERY,
}

freeslot("sfx_slip", "sfx_screec", "sfx_drift", "sfx_kpogos", "sfx_tossed")
freeslot("SPR_ORBN","S_ORBINAUT_SHIELD1","S_ORBINAUT_SHIELD2","S_ORBINAUT_SHIELD3",
"S_ORBINAUT_SHIELD4","S_ORBINAUT_SHIELD5","S_ORBINAUT_SHIELD6","S_ORBINAUT_SHIELDDEAD","MT_ORBINAUT_SHIELD",
"S_ORBINAUT1","S_ORBINAUT2","S_ORBINAUT3","S_ORBINAUT4","S_ORBINAUT5","S_ORBINAUT6","S_ORBINAUT_DEAD","MT_ORBINAUT")
states[S_ORBINAUT_SHIELD1] = {SPR_ORBN, 6, 3, nil, 0, 0, S_ORBINAUT_SHIELD2}
states[S_ORBINAUT_SHIELD2] = {SPR_ORBN, 7, 3, nil, 0, 0, S_ORBINAUT_SHIELD3}
states[S_ORBINAUT_SHIELD3] = {SPR_ORBN, 8, 3, nil, 0, 0, S_ORBINAUT_SHIELD4}
states[S_ORBINAUT_SHIELD4] = {SPR_ORBN, 9, 3, nil, 0, 0, S_ORBINAUT_SHIELD5}
states[S_ORBINAUT_SHIELD5] = {SPR_ORBN, 10, 3, nil, 0, 0, S_ORBINAUT_SHIELD6}
states[S_ORBINAUT_SHIELD6] = {SPR_ORBN, 11, 3, nil, 0, 0, S_ORBINAUT_SHIELD1}

states[S_ORBINAUT1] = {SPR_ORBN, 0, 1, nil, 0, 0, S_ORBINAUT2}
states[S_ORBINAUT2] = {SPR_ORBN, 1, 1, nil, 0, 0, S_ORBINAUT3}
states[S_ORBINAUT3] = {SPR_ORBN, 2, 1, nil, 0, 0, S_ORBINAUT4}
states[S_ORBINAUT4] = {SPR_ORBN, 3, 1, nil, 0, 0, S_ORBINAUT5}
states[S_ORBINAUT5] = {SPR_ORBN, 4, 1, nil, 0, 0, S_ORBINAUT6}
states[S_ORBINAUT6] = {SPR_ORBN, 5, 1, nil, 0, 0, S_ORBINAUT1}

states[S_ORBINAUT_DEAD] = {SPR_ORBN, 0, 175, nil, 0, 0, S_NULL}
states[S_ORBINAUT_SHIELDDEAD] = {SPR_ORBN, 6, 175, nil, 0, 0, S_NULL}

mobjinfo[MT_ORBINAUT_SHIELD] = {
	spawnstate = S_ORBINAUT_SHIELD1,		// spawnstate
	deathstate = S_ORBINAUT_SHIELDDEAD,
	spawnhealth = 1000,				// spawnhealth
	reactiontime = 8,				// reactiontime
	speed = 4*FU,
	radius = 16*FRACUNIT,			// radius
	height = 32*FRACUNIT,			// height
	damage = 1,
	flags = MF_SHOOTABLE|MF_NOGRAVITY|MF_SCENERY, // flags
}
mobjinfo[MT_ORBINAUT] = {
	spawnstate = S_ORBINAUT1,		// spawnstate
	deathstate = S_ORBINAUT_DEAD,
	spawnhealth = 7,				// spawnhealth
	reactiontime = 8,				// reactiontime
	speed = 64*FU,
	radius = 24*FRACUNIT,			// radius
	height = 32*FRACUNIT,			// height
	damage = 1,
	seesound = sfx_tossed,
	activesound = sfx_s3k96,
	deathsound = sfx_s3k5d,
	flags = MF_SHOOTABLE,--|MF_BOUNCE, // flags
}

freeslot("SPR_SPBM","S_SPB1","S_SPB2","S_SPB3","S_SPB4","S_SPB5","S_SPB6",
"S_SPB7","S_SPB8","S_SPB9","S_SPB10","S_SPB11","S_SPB12","S_SPB13","S_SPB14",
"S_SPB15","S_SPB16","S_SPB17","S_SPB18","S_SPB19","S_SPB20","S_SPB_DEAD",
"MT_SPB")
--man
states[S_SPB1] = {SPR_SPBM, 0, 1, A_SPBChase, 0, 0,  S_SPB2}
states[S_SPB2] = {SPR_SPBM, 1, 1, A_SPBChase, 0, 0,  S_SPB3}
states[S_SPB3] = {SPR_SPBM, 0, 1, A_SPBChase, 0, 0,  S_SPB4}
states[S_SPB4] = {SPR_SPBM, 2, 1, A_SPBChase, 0, 0,  S_SPB5}
states[S_SPB5] = {SPR_SPBM, 0, 1, A_SPBChase, 0, 0,  S_SPB6}
states[S_SPB6] = {SPR_SPBM, 3, 1, A_SPBChase, 0, 0,  S_SPB7}
states[S_SPB7] = {SPR_SPBM, 0, 1, A_SPBChase, 0, 0,  S_SPB8}
states[S_SPB8] = {SPR_SPBM, 4, 1, A_SPBChase, 0, 0,  S_SPB9}
states[S_SPB9] = {SPR_SPBM, 0, 1, A_SPBChase, 0, 0,  S_SPB10}
states[S_SPB10] = {SPR_SPBM, 5, 1, A_SPBChase, 0, 0,  S_SPB11}
states[S_SPB11] = {SPR_SPBM, 0, 1, A_SPBChase, 0, 0,  S_SPB12}
states[S_SPB12] = {SPR_SPBM, 6, 1, A_SPBChase, 0, 0,  S_SPB13}
states[S_SPB13] = {SPR_SPBM, 0, 1, A_SPBChase, 0, 0,  S_SPB14}
states[S_SPB14] = {SPR_SPBM, 7, 1, A_SPBChase, 0, 0,  S_SPB15}
states[S_SPB15] = {SPR_SPBM, 0, 1, A_SPBChase, 0, 0,  S_SPB16}
states[S_SPB16] = {SPR_SPBM, 8, 1, A_SPBChase, 0, 0,  S_SPB17}
states[S_SPB17] = {SPR_SPBM, 0, 1, A_SPBChase, 0, 0,  S_SPB18}
states[S_SPB18] = {SPR_SPBM, 8, 1, A_SPBChase, 0, 0,  S_SPB19}
states[S_SPB19] = {SPR_SPBM, 0, 1, A_SPBChase, 0, 0,  S_SPB20}
states[S_SPB20] = {SPR_SPBM, 8, 1, A_SPBChase, 0, 0,  S_SPB1}
states[S_SPB_DEAD] = {SPR_SPBM, 8, 175, nil, 0, 0,  S_NULL}
mobjinfo[MT_SPB] = {
	spawnstate = S_SPB1,
	seesound = sfx_tossed,
	reactiontime = 8,
	attacksound = sfx_kc57,
	deathstate = S_SPB_DEAD,
	deathsound = sfx_s3k5d,
	speed = 64*FU,
	radius = 24*FU,
	height = 48*FU,
	mass = 100,
	damage = 1,
	activesound = sfx_kc64,
	flags = (MF_SPECIAL)|MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT,
}


freeslot("SPR_BANA","S_BANANA","S_BANANA_DEAD","sfx_peel","MT_BANANA","MT_BANANA_SHIELD")
states[S_BANANA] = {SPR_BANA, 0,  -1, nil, 0, 0, S_NULL}
states[S_BANANA_DEAD] = {SPR_BANA, 0,  175, nil, 0, 0, S_NULL}

mobjinfo[MT_BANANA] = {
	spawnstate = S_BANANA,
	spawnhealth = 2,
	seesound = sfx_tossed,
	reactiontime = 8,
	deathstate = S_BANANA_DEAD,
	radius = 16*FU,
	height = 32*FU,
	mass = 100,
	damage = 1,
	activesound = sfx_peel,
	flags = MF_BOUNCE*0|MF_SHOOTABLE,
}

mobjinfo[MT_BANANA_SHIELD] = {
	spawnstate = S_BANANA,
	spawnhealth = 1000,
	reactiontime = 8,
	deathstate = S_BANANA_DEAD,
	radius = 10*FU,
	height = 24*FU,
	mass = 100,
	flags = MF_SHOOTABLE|MF_NOGRAVITY|MF_SCENERY,
}

freeslot("SPR_JAWZ","S_JAWZ1","S_JAWZ2","S_JAWZ3","S_JAWZ4","S_JAWZ5","S_JAWZ6","S_JAWZ7","S_JAWZ8","MT_JAWZ","MT_JAWZ_SHIELD","MT_JAWZ_DUD")
states[S_JAWZ1] = {SPR_JAWZ, 0, 1, A_JawzChase, 0, 0, S_JAWZ2}
states[S_JAWZ2] = {SPR_JAWZ, 4, 1, A_JawzChase, 0, 0, S_JAWZ3}
states[S_JAWZ3] = {SPR_JAWZ, 1, 1, A_JawzChase, 0, 0, S_JAWZ4}
states[S_JAWZ4] = {SPR_JAWZ, 4, 1, A_JawzChase, 0, 0, S_JAWZ5}
states[S_JAWZ5] = {SPR_JAWZ, 2, 1, A_JawzChase, 0, 0, S_JAWZ6}
states[S_JAWZ6] = {SPR_JAWZ, 4, 1, A_JawzChase, 0, 0, S_JAWZ7}
states[S_JAWZ7] = {SPR_JAWZ, 3, 1, A_JawzChase, 0, 0, S_JAWZ8}
states[S_JAWZ8] = {SPR_JAWZ, 4, 1, A_JawzChase, 0, 0, S_JAWZ1}

mobjinfo[MT_JAWZ] = {
	spawnstate = S_JAWZ1,
	spawnhealth = 1,
	seesound = sfx_tossed,
	reactiontime = 8,
	--deathstates
	deathsound = sfx_s3k5d,
	speed = 64*FU,
	radius = 16*FU,
	height = 32*FU,
	damage = 1,
	activesound = sfx_s3k0s,
	flags = MF_SHOOTABLE,
}

mobjinfo[MT_JAWZ_SHIELD] = {
	spawnstate = S_JAWZ1,
	spawnhealth = 1000,
	reactiontime = 8,
	--deathstates
	speed = 4*FU,
	radius = 16*FU,
	height = 32*FU,
	mass = 100,
	flags = MF_SHOOTABLE|MF_NOGRAVITY|MF_SCENERY,
}

freeslot("sfx_kinvnc","sfx_kgrow","sfx_alarmi","sfx_alarmg")

freeslot("SPR_KINV","SPR_KINF","S_KARTINVULN_SMALL1","S_KARTINVULN_LARGE1","S_KARTINVULN_LARGE2",
"S_KARTINVULN_LARGE3","S_KARTINVULN_LARGE4","S_KARTINVULN_LARGE5","MT_INVULNFLASH","S_INVULNFLASH1",
"S_INVULNFLASH2","S_INVULNFLASH3","S_INVULNFLASH4")
states[S_KARTINVULN_SMALL1] = {SPR_KINV, FF_FULLBRIGHT|FF_ANIMATE,    1*5, nil, 5, 1, S_NULL}
states[S_KARTINVULN_LARGE1] = {SPR_KINV, FF_FULLBRIGHT|1,  1, nil, 0, 0, S_KARTINVULN_LARGE2}
states[S_KARTINVULN_LARGE2] = {SPR_KINV, FF_FULLBRIGHT|1,  1, nil, 0, 0, S_KARTINVULN_LARGE3}
states[S_KARTINVULN_LARGE3] = {SPR_KINV, FF_FULLBRIGHT|1,  1, nil, 0, 0, S_KARTINVULN_LARGE4}
states[S_KARTINVULN_LARGE4] = {SPR_KINV, FF_FULLBRIGHT|1,  1, nil, 0, 0, S_KARTINVULN_LARGE5}
states[S_KARTINVULN_LARGE5] = {SPR_KINV, FF_FULLBRIGHT|1,  1, nil, 0, 0, S_NULL}

states[S_INVULNFLASH1] = {SPR_KINF, FF_FULLBRIGHT|FF_TRANS90, 1, nil, 0, 0, S_INVULNFLASH2}
states[S_INVULNFLASH2] = {SPR_NULL, FF_FULLBRIGHT|FF_TRANS90, 1, nil, 0, 0, S_INVULNFLASH3}
states[S_INVULNFLASH3] = {SPR_KINF, FF_FULLBRIGHT|FF_TRANS90, 1, nil, 0, 0, S_INVULNFLASH4}
states[S_INVULNFLASH4] = {SPR_NULL, FF_FULLBRIGHT|FF_TRANS90, 1, nil, 0, 0, S_INVULNFLASH1}

mobjinfo[MT_INVULNFLASH] = {
	spawnstate = S_INVULNFLASH1,
	radius = 8*FU,
	height = 8*FU,
	displayoffset = 1,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY,
}

local function K_SpawnSparkleTrail(mo)
	local rad = (mo.radius*2)>>FRACBITS;
	local sparkle;
	local i;

	assert(mo != nil);
	assert(mo.valid);

	for i=0,2
		local newx = mo.x + mo.momx + (P_RandomRange(-rad, rad)<<FRACBITS);
		local newy = mo.y + mo.momy + (P_RandomRange(-rad, rad)<<FRACBITS);
		local newz = mo.z + mo.momz + (P_RandomRange(0, mo.height>>FRACBITS)<<FRACBITS);

		sparkle = P_SpawnMobj(newx, newy, newz, MT_THOK);--SPARKLETRAIL);
		sparkle.state = S_KARTINVULN_SMALL1
		sparkle.height = 14*sparkle.scale
		K_FlipFromObject(sparkle, mo);

		if kart_rrpoweritems.value == 2
			sparkle.spriteroll = leveltime*ANG1*10
		end

		//if (i == 0)
			//sparkle.state = S_KARTINVULN_LARGE1;
		//end

		sparkle.target = mo;
-- 		sparkle.destscale = mo.destscale;
-- 		P_SetScale(sparkle, mo.scale);
		sparkle.scale = mo.scale
		sparkle.color = mo.color;
		//sparkle.colorized = mo.colorized;
	end

	sparkle.state = S_KARTINVULN_LARGE1;
end
rawset(_G,"K_SpawnSparkleTrail",K_SpawnSparkleTrail)

local K_KartItemOddsRace =
{
				//P-Odds	 0  1  2  3  4  5  6  7  8  9
			   /*Sneaker*/ {20, 0, 0, 4, 6, 7, 0, 0, 0, 0 }, // 	Sneaker
		/*Rocket Sneaker*/ { 0, 0, 0, 0, 0, 1, 4, 5, 3, 0 }, // Rocket Sneaker
		 /*Invincibility*/ { 0, 0, 0, 0, 0, 1, 4, 6,10, 0 }, // 	Invincibility
				/*Banana*/ { 0, 9, 4, 2, 1, 0, 0, 0, 0, 0 }, // 	Banana
		/*Eggman Monitor*/ { 0, 3, 2, 1, 0, 0, 0, 0, 0, 0 }, // Eggman Monitor
			  /*Orbinaut*/ { 0, 7, 6, 4, 2, 0, 0, 0, 0, 0 }, // 	Orbinaut
				  /*Jawz*/ { 0, 0, 3, 2, 1, 1, 0, 0, 0, 0 }, // Jawz
				  /*Mine*/ { 0, 0, 2, 2, 1, 0, 0, 0, 0, 0 }, // Mine
			   /*Ballhog*/ { 0, 0, 0, 2, 1, 0, 0, 0, 0, 0 }, // Ballhog
   /*Self-Propelled Bomb*/ { 0, 0, 1, 2, 3, 4, 2, 2, 0,20 }, // 	Self-Propelled Bomb
				  /*Grow*/ { 0, 0, 0, 0, 0, 0, 2, 5, 7, 0 }, // 	Grow
				/*Shrink*/ { 0, 0, 0, 0, 0, 0, 0, 2, 0, 0 }, // 	Shrink
		/*Thunder Shield*/ { 0, 1, 2, 0, 0, 0, 0, 0, 0, 0 }, // Thunder Shield
			   /*Hyudoro*/ { 0, 0, 0, 0, 1, 2, 1, 0, 0, 0 }, // Hyudoro
		   /*Pogo Spring*/ { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }, // 	Pogo Spring
		  /*Kitchen Sink*/ { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }, // Kitchen Sink
			/*Sneaker x3*/ { 0, 0, 0, 0, 3, 7, 9, 2, 0, 0 }, // 	Sneaker x3
			 /*Banana x3*/ { 0, 0, 1, 1, 0, 0, 0, 0, 0, 0 }, // 	Banana x3
			/*Banana x10*/ { 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 }, // 	Banana x10
		   /*Orbinaut x3*/ { 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 }, // 	Orbinaut x3
		   /*Orbinaut x4*/ { 0, 0, 0, 0, 1, 1, 0, 0, 0, 0 }, // 	Orbinaut x4
			   /*Jawz x2*/ { 0, 0, 0, 1, 2, 0, 0, 0, 0, 0 }  // Jawz x2
};


local function K_KartGetItemResult(player, getitem)
	if (getitem == KITEM_SPB or getitem == KITEM_SHRINK) // Indirect items
		indirectitemcooldown = 20*TICRATE;
	end
	if (getitem == KITEM_HYUDORO) // Hyudoro cooldown
		hyubgone = 5*TICRATE;
	end

	// Special roulettes first, then the generic ones are handled by default
	if getitem == KRITEM_TRIPLESNEAKER // Sneaker x3
		player.kartstuff[k_itemtype] = KITEM_SNEAKER;
		player.kartstuff[k_itemamount] = 3;
	elseif getitem == KRITEM_TRIPLEBANANA // Banana x3
		player.kartstuff[k_itemtype] = KITEM_BANANA;
		player.kartstuff[k_itemamount] = 3;
	elseif getitem == KRITEM_TENFOLDBANANA // Banana x10
		player.kartstuff[k_itemtype] = KITEM_BANANA;
		player.kartstuff[k_itemamount] = 10;
	elseif getitem == KRITEM_TRIPLEORBINAUT // Orbinaut x3
		player.kartstuff[k_itemtype] = KITEM_ORBINAUT;
		player.kartstuff[k_itemamount] = 3;
	elseif getitem == KRITEM_QUADORBINAUT // Orbinaut x4
		player.kartstuff[k_itemtype] = KITEM_ORBINAUT;
		player.kartstuff[k_itemamount] = 4;
	elseif getitem == KRITEM_DUALJAWZ // Jawz x2
		player.kartstuff[k_itemtype] = KITEM_JAWZ;
		player.kartstuff[k_itemamount] = 2;
	else
		if (getitem <= 0)-- or getitem >= NUMKARTRESULTS) // Sad (Fallback)
			if (getitem != 0)
				CONS_Printf(player,string.format("ERROR: P_KartGetItemResult - Item roulette gave bad item (%d) :(\n",getitem));
			end
			player.kartstuff[k_itemtype] = KITEM_SAD;
		else
			player.kartstuff[k_itemtype] = getitem;
		end
		player.kartstuff[k_itemamount] = 1;
	end
end


local function K_KartGetItemOdds(pos, item, mashed, spbrush)
	local distvar = (64*14);
	local newodds;
	local pingame, pexiting = 0, 0;
	local thunderisout = false;
	local first, second = -1, -1;
	local secondist = 0;
-- 	local itemenabled = {
-- 		cv_sneaker.value,
-- 		cv_rocketsneaker.value,
-- 		cv_invincibility.value,
-- 		cv_banana.value,
-- 		cv_eggmanmonitor.value,
-- 		cv_orbinaut.value,
-- 		cv_jawz.value,
-- 		cv_mine.value,
-- 		cv_ballhog.value,
-- 		cv_selfpropelledbomb.value,
-- 		cv_grow.value,
-- 		cv_shrink.value,
-- 		cv_thundershield.value,
-- 		cv_hyudoro.value,
-- 		cv_pogospring.value,
-- 		cv_kitchensink.value,
-- 		cv_triplesneaker.value,
-- 		cv_triplebanana.value,
-- 		cv_decabanana.value,
-- 		cv_tripleorbinaut.value,
-- 		cv_quadorbinaut.value,
-- 		cv_dualjawz.value
-- 	};

	assert(item > KITEM_NONE); // too many off by one scenarioes.

	--kart
-- 	if (not itemenabled[item-1] and not modeattacking)
-- 		return 0;
-- 	end

	if false--(G_BattleGametype())
		newodds = K_KartItemOddsBattle[item-1+1][pos+1];
	else
		newodds = K_KartItemOddsRace[item-1+1][pos+1];
	end

	// Base multiplication to ALL item odds to simulate fractional precision
	newodds = $ * 4;

	for p in players.iterate
		if (not p.valid or p.spectator or not p.kart)
			continue;
		end

-- 		if (not G_BattleGametype() or p.kartstuff[k_bumper])
			pingame = $ + 1;
-- 		end

		if (p.exiting)
			pexiting = $ + 1;
		end

		if (p.mo)
			if (p.kartstuff[k_itemtype] == KITEM_THUNDERSHIELD)
				thunderisout = true;
			end

			if true--(!G_BattleGametype())
				if (p.kartstuff[k_position] == 1 and first == -1)
					first = #p;
				end
				if (p.kartstuff[k_position] == 2 and second == -1)
					second = #p;
				end
			end
		end
	end

	if (first != -1 and second != -1) // calculate 2nd's distance from 1st, for SPB
		secondist = P_AproxDistance(P_AproxDistance(players[first].mo.x - players[second].mo.x,
													players[first].mo.y - players[second].mo.y),
													players[first].mo.z - players[second].mo.z) / mapobjectscale;
		if (franticitems)
			secondist = (15 * secondist) / 14;
		end
		secondist = ((28 + (8-pingame)) * secondist) / 28;
	end

	// POWERITEMODDS handles all of the "frantic item" related functionality, for all of our powerful items.
	// First, it multiplies it by 2 if franticitems is true; easy-peasy.
	// Next, it multiplies it again if it's in SPB mode and 2nd needs to apply pressure to 1st.
	// Then, it multiplies it further if the player count isn't equal to 8.
	// This is done to make low player count races more interesting and high player count rates more fair.
	// (2P normal would be about halfway between 8P normal and 8P frantic.)
	// (This scaling is not done for SPB Rush, so that catchup strength is not weakened.)
	// Lastly, it *divides* it by your mashed value, which was determined in K_KartItemRoulette, for lesser items needed in a pinch.

	local PLAYERSCALING = (8 - (spbrush and 2 or pingame))

	local function POWERITEMODDS(odds)
		if (franticitems)
			odds = $ << 1;
		end
		odds = FixedMul(odds<<FRACBITS, FRACUNIT + ((PLAYERSCALING << FRACBITS) / 25)) >> FRACBITS;
		if (mashed > 0)
			odds = FixedDiv(odds<<FRACBITS, FRACUNIT + mashed) >> FRACBITS;
		end
	end

	local COOLDOWNONSTART = (leveltime < (30*TICRATE)+starttime)

	if item == KITEM_ROCKETSNEAKER
	or item == KITEM_JAWZ
	or item == KITEM_BALLHOG
	or item == KRITEM_TRIPLESNEAKER
	or item == KRITEM_TRIPLEBANANA
	or item == KRITEM_TENFOLDBANANA
	or item == KRITEM_TRIPLEORBINAUT
	or item == KRITEM_QUADORBINAUT
	or item == KRITEM_DUALJAWZ
		POWERITEMODDS(newodds);
	elseif item == KITEM_INVINCIBILITY
	or item == KITEM_MINE
	or item == KITEM_GROW
		if (COOLDOWNONSTART)
			newodds = 0;
		else
			POWERITEMODDS(newodds);
		end
	elseif item == KITEM_SPB
		if (((indirectitemcooldown > 0) or (pexiting > 0) or (secondist/distvar < 3))
			and (pos != 9)) // Force SPB
			newodds = 0;
		else
			newodds = $ * min((secondist/distvar)-4, 3); // POWERITEMODDS(newodds);
		end
	elseif item == KITEM_SHRINK
		if ((indirectitemcooldown > 0) or (pingame-1 <= pexiting) or COOLDOWNONSTART)
			newodds = 0;
		else
			POWERITEMODDS(newodds);
		end
	elseif item == KITEM_THUNDERSHIELD
		if (thunderisout or COOLDOWNONSTART)
			newodds = 0;
		else
			POWERITEMODDS(newodds);
		end
	elseif item == KITEM_HYUDORO
		if ((hyubgone > 0) or COOLDOWNONSTART)
			newodds = 0;
		end
	end

-- #undef POWERITEMODDS

	return newodds;
end
rawset(_G,"K_KartGetItemOdds",K_KartGetItemOdds)

local function dist(player,pingame)
	local pdis = 0
	for p in players.iterate
		if (p.valid and not p.spectator and p.mo and p.kart
			and p.kartstuff[k_position] != 0
			and p.kartstuff[k_position] < player.kartstuff[k_position])
			pdis = $ + P_AproxDistance(P_AproxDistance(p.mo.x - player.mo.x,
													p.mo.y - player.mo.y),
													p.mo.z - player.mo.z) / mapobjectscale
													* (pingame - p.kartstuff[k_position])
													/ max(1, ((pingame - 1) * (pingame + 1) / 3));
		end
	end
	return pdis
end

local function K_FindUseodds(player, mashed, pingame, bestbumper, spbrush, dontforcespb)
	local distvar = (64*14);
	local pdis, useodds = 0, 0;
	local disttable = {};
	local distlen = 0;
	local oddsvalid = {};

	// Unused now, oops :V
-- 	(void)bestbumper;

	for i=0,10-1
		local available = false;

-- 		if (G_BattleGametype() and i > 1)
-- 			oddsvalid[i] = false;
-- 			break;
-- 		end

		for j = 1,NUMKARTRESULTS-1
			if (K_KartGetItemOdds(i, j, mashed, spbrush) > 0)
				available = true;
				break;
			end
		end

		oddsvalid[i] = available;
	end

	pdis = dist(player,pingame)

-- #define SETUPDISTTABLE(odds, num) \
-- 	for (i = num; i; --i) disttable[distlen++] = odds
	--i have to use an embedded function just this once
	local function SETUPDISTTABLE(odds, num)
		for i=num,0,-1
			disttable[distlen] = odds
			distlen = $ + 1
		end
	end
		

	if false--(G_BattleGametype()) // Battle Mode
-- 		if (player.kartstuff[k_roulettetype] == 1 and oddsvalid[1] == true)
-- 			// 1 is the extreme odds of player-controlled "Karma" items
-- 			useodds = 1;
-- 		else
-- 			useodds = 0;

-- 			if (oddsvalid[0] == false and oddsvalid[1] == true)
-- 				// try to use karma odds as a fallback
-- 				useodds = 1;
-- 			end
-- 		end
	else
		if (oddsvalid[1]) SETUPDISTTABLE(1,1); end
		if (oddsvalid[2]) SETUPDISTTABLE(2,1); end
		if (oddsvalid[3]) SETUPDISTTABLE(3,1); end
		if (oddsvalid[4]) SETUPDISTTABLE(4,2); end
		if (oddsvalid[5]) SETUPDISTTABLE(5,2); end
		if (oddsvalid[6]) SETUPDISTTABLE(6,3); end
		if (oddsvalid[7]) SETUPDISTTABLE(7,3); end
		if (oddsvalid[8]) SETUPDISTTABLE(8,1); end

		if (franticitems) // Frantic items make the distances between everyone artifically higher, for crazier items
			pdis = (15 * pdis) / 14;
		end

		if (spbrush) // SPB Rush Mode: It's 2nd place's job to catch-up items and make 1st place's job hell
			pdis = (3 * pdis) / 2;
		end

		pdis = ((28 + (8-pingame)) * pdis) / 28;

		if (pingame == 1 and oddsvalid[0])					// Record Attack, or just alone
			useodds = 0;
		elseif (pdis <= 0)									// (64*14) *  0 =     0
			useodds = disttable[0];
		elseif (player.kartstuff[k_position] == 2 and pdis > (distvar*6)
			and spbplace == -1 and not indirectitemcooldown and not dontforcespb
			and oddsvalid[9])								// Force SPB in 2nd
			useodds = 9;
		elseif (pdis > distvar * ((12 * distlen) / 14))	// (64*14) * 12 = 10752
			useodds = disttable[distlen-1];
		else
			for i=1,13-1
				if (pdis <= distvar * ((i * distlen) / 14))
					useodds = disttable[((i * distlen) / 14)];
					break;
				end
			end
		end
	end

-- #undef SETUPDISTTABLE

	//CONS_Printf("Got useodds %d. (position: %d, distance: %d)\n", useodds, player->kartstuff[k_position], pdis);

	return useodds;
end
rawset(_G,"K_FindUseodds",K_FindUseodds)

local function K_KartItemRoulette(player, cmd)
	local pingame = 0;
	local roulettestop;
	local useodds = 0;
	local spawnchance = {};
	local totalspawnchance = 0;
	local bestbumper = 0;
	local mashed = 0;
	local dontforcespb = false;
	local spbrush = false;

	// This makes the roulette cycle through items - if this is 0, you shouldn't be here.
	if (player.kartstuff[k_itemroulette])
		player.kartstuff[k_itemroulette] = $ + 1;
	else
		return;
	end

	// Gotta check how many players are active at this moment.
	for p in players.iterate
		if (not p or p.spectator or not p.kartstuff)
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

	// No forced SPB in 1v1s, it has to be randomly rolled
	if (pingame <= 2)
		dontforcespb = true;
	end

	// This makes the roulette produce the random noises.
	if ((player.kartstuff[k_itemroulette] % 3) == 1 and player == displayplayer)-- and !demo.freecam)
-- 		for (i = 0; i <= splitscreen; i = $ + 1)
			if (player == displayplayer and player.kartstuff[k_itemroulette])
				S_StartSound(nil, sfx_itrol1 + ((player.kartstuff[k_itemroulette] / 3) % 8));
			end
-- 		end
	end

	roulettestop = TICRATE + (3*(pingame - player.kartstuff[k_position]));

	// If the roulette finishes or the player presses BT_ATTACK, stop the roulette and calculate the item.
	// I'm returning via the exact opposite, however, to forgo having another bracket embed. Same result either way, I think.
	// Finally, if you get past this check, now you can actually start calculating what item you get.
	if ((cmd.buttons & BT_CUSTOM3) and not (player.kartstuff[k_eggmanheld] or player.kartstuff[k_itemheld]) and player.kartstuff[k_itemroulette] >= roulettestop and not modeattacking)
		// Mashing reduces your chances for the good items
		mashed = FixedDiv((player.kartstuff[k_itemroulette])*FRACUNIT, ((TICRATE*3)+roulettestop)*FRACUNIT) - FRACUNIT;
	elseif (not (player.kartstuff[k_itemroulette] >= (TICRATE*3)))
		return;
	end

	if (cmd.buttons & BT_CUSTOM3)
		player.pflags = $ | PF_ATTACKDOWN;
	end

	if (player.kartstuff[k_roulettetype] == 2) // Fake items
		player.kartstuff[k_eggmanexplode] = 4*TICRATE;
		//player.kartstuff[k_itemblink] = TICRATE;
		//player.kartstuff[k_itemblinkmode] = 1;
		player.kartstuff[k_itemroulette] = 0;
		player.kartstuff[k_roulettetype] = 0;
		if (player == displayplayer)-- and !demo.freecam)
			S_StartSound(nil, sfx_itrole);
		end
		return;
	end

	if (kart_debugitem.value != 0 and not modeattacking)
		K_KartGetItemResult(player, kart_debugitem.value);
		player.kartstuff[k_itemamount] = kart_debugamount.value;
		player.kartstuff[k_itemblink] = TICRATE;
		player.kartstuff[k_itemblinkmode] = 2;
		player.kartstuff[k_itemroulette] = 0;
		player.kartstuff[k_roulettetype] = 0;
		if (player == displayplayer)-- and !demo.freecam)
			S_StartSound(nil, sfx_dbgsal);
		end
		return;
	end

-- 	if (G_RaceGametype())
-- 		spbrush = (spbplace != -1 and player.kartstuff[k_position] == spbplace+1);
-- 	end

	// Initializes existing spawnchance values
	for i = 0, NUMKARTRESULTS-1
		spawnchance[i] = 0;
	end

	// Split into another function for a debug function below
	useodds = K_FindUseodds(player, mashed, pingame, bestbumper, spbrush, dontforcespb);

	for i = 1, NUMKARTRESULTS-1
		local c = K_KartGetItemOdds(useodds, i, mashed, spbrush)
		totalspawnchance = $ + c
		spawnchance[i] = totalspawnchance;
	end

	// Award the player whatever power is rolled
	if (totalspawnchance > 0)
		totalspawnchance = P_RandomKey(totalspawnchance);
		for i = 0,NUMKARTRESULTS-1 --and spawnchance[i] <= totalspawnchance; i = $ + 1);
			K_KartGetItemResult(player, i);
			if spawnchance[i] > totalspawnchance break end
		end
	else
		player.kartstuff[k_itemtype] = KITEM_SAD;
		player.kartstuff[k_itemamount] = 1;
-- 		player.kartstuff[k_itemtype] = KITEM_SNEAKER--mashed and KITEM_SUPERRING or KITEM_SNEAKER;
-- 		player.kartstuff[k_itemamount] = 1;
	end

	if (player == displayplayer)-- and !demo.freecam)
		S_StartSound(nil, ((player.kartstuff[k_roulettetype] == 1) and sfx_itrolk or (mashed and sfx_itrolm or sfx_itrolf)));
	end

	player.kartstuff[k_itemblink] = TICRATE;
	player.kartstuff[k_itemblinkmode] = ((player.kartstuff[k_roulettetype] == 1) and 2 or (mashed and 1 or 0));

	player.kartstuff[k_itemroulette] = 0; // Since we're done, clear the roulette number
	player.kartstuff[k_roulettetype] = 0; // This too
end
rawset(_G,"K_KartItemRoulette",K_KartItemRoulette)

local function K_PlayAttackTaunt(player)
	return
end
rawset(_G,"K_PlayAttackTaunt",K_PlayAttackTaunt)

local function K_PlayBoostTaunt(player)
	return
end
rawset(_G,"K_PlayBoostTaunt",K_PlayBoostTaunt)

local function K_PlayPowerGloatSound(player)
	return
end
rawset(_G,"K_PlayPowerGloatSound",K_PlayPowerGloatSound)


local function K_DoSneaker(player, type)
	local intendedboost;

	if gamespeed == 0
		intendedboost = 54508;
	elseif gamespeed == 1
		intendedboost = 32768;
	else
		intendedboost = 18062;
	end

	if (not player.kartstuff[k_floorboost] or player.kartstuff[k_floorboost] == 3)
		if not kart_booststacking.value
			S_StartSound(player.mo, sfx_cdfm01);
		else
			S_StopSoundByID(player.mo, sfx_cdfm01);
			S_StopSoundByID(player.mo, sfx_cdfm40);
			
			S_StartSound(player.mo, player.kartstuff[k_numsneakers] and sfx_cdfm40 or sfx_cdfm01);
			
			player.kartstuff[k_numsneakers] = $ + 1
		end
		K_SpawnDashDustRelease(player);
		if (intendedboost > player.kartstuff[k_speedboost])
			player.kartstuff[k_destboostcam] = FixedMul(FRACUNIT, FixedDiv((intendedboost - player.kartstuff[k_speedboost]), intendedboost));
		end
	end

	if (not player.kartstuff[k_sneakertimer])
		if (type == 2)
			if (player.mo.hnext)
				local cur = player.mo.hnext;
				while (cur and cur.valid)
					if (not cur.tracer)
						local overlay = P_SpawnMobj(cur.x, cur.y, cur.z, MT_BOOSTFLAME);
						overlay.target = cur;
						cur.tracer = overlay;
						overlay.scale = 3*cur.scale/4;
						K_FlipFromObject(overlay, cur);
					end
					cur = cur.hnext;
				end
			end
		else
			local overlay = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_BOOSTFLAME);
			overlay.target = player.mo;
			overlay.destscale = player.mo.scale;
			P_SetScale(overlay, overlay.destscale);
			K_FlipFromObject(overlay, player.mo);
		end
	end

	player.kartstuff[k_sneakertimer] = sneakertime;

	// set angle for spun out players:
	player.kartstuff[k_boostangle] = player.mo.angle;

	if (type != 0)
		player.pflags = $ | PF_ATTACKDOWN;
-- 		K_PlayBoostTaunt(player.mo);
	end
end
rawset(_G,"K_DoSneaker",K_DoSneaker)

local function K_DoPogoSpring(mo, vertispeed, sound)
	local vscale = mapobjectscale + (mo.scale - mapobjectscale);

	if (mo.player and mo.player.spectator)
		return;
	end

	if (mo.eflags & MFE_SPRUNG)
		return;
	end

-- 	mo.standingslope = NULL;

-- 	mo.eflags = $ | MFE_SPRUNG;
	local mx,my = mo.momx,mo.momy
	mo.z = $ + P_MobjFlip(mo)
	mo.flags = $ | MF_NOCLIPHEIGHT
	P_TryMove(mo,mo.x,mo.y,true)
	mo.flags = $ & ~MF_NOCLIPHEIGHT
	mo.momx,mo.momy = mx,my

	if (mo.eflags & MFE_VERTICALFLIP)
		vertispeed = $ * -1;
	end

	if (vertispeed == 0)
		local thrust;

		if (mo.player)
			thrust = 3*mo.player.speed/2;
			if (thrust < 48<<FRACBITS)
				thrust = 48<<FRACBITS;
			end
			if (thrust > 72<<FRACBITS)
				thrust = 72<<FRACBITS;
			end
			if (mo.player.kartstuff[k_pogospring] != 2)
				if (mo.player.kartstuff[k_sneakertimer])
					thrust = FixedMul(thrust, 5*FRACUNIT/4);
				elseif (mo.player.kartstuff[k_invincibilitytimer])
					thrust = FixedMul(thrust, 9*FRACUNIT/8);
				end
			end
		else
			thrust = FixedDiv(3*P_AproxDistance(mo.momx, mo.momy)/2, 5*FRACUNIT/2);
			if (thrust < 16<<FRACBITS)
				thrust = 16<<FRACBITS;
			end
			if (thrust > 32<<FRACBITS)
				thrust = 32<<FRACBITS;
			end
		end

		mo.momz = P_MobjFlip(mo)*FixedMul(sin(ANGLE_22h), FixedMul(thrust, vscale));
	else
		mo.momz = FixedMul(vertispeed, vscale);
	end

	if (mo.eflags & MFE_UNDERWATER)
		mo.momz = (117 * mo.momz) / 200;
	end

	if (sound)
		S_StartSound(mo, (sound == 1 and sfx_kc2f or sfx_kpogos));
	end
end
rawset(_G,"K_DoPogoSpring",K_DoPogoSpring)

local function K_FindLastTrailMobj(player)
	local trail = player.mo
	if not player or not trail or not player.mo.hnext or not player.mo.hnext.health
		return
	end
	
	while trail.hnext and trail.hnext.valid and trail.hnext.health
		trail = $.hnext
	end
	
	return trail
end

local function K_SpawnKartMissile(source, type, an, flags2, speed)
	local th;
	local x, y, z;
	local finalspeed = speed;
	local throwmo;

	if (source.player and source.player.speed > K_GetKartSpeed(source.player, false))
		local input = source.angle - an;
		local invert = (input > ANGLE_180);
		if (invert)
			input = InvAngle(input);
		end

		finalspeed = max(speed, FixedMul(speed, FixedMul(
			FixedDiv(source.player.speed, K_GetKartSpeed(source.player, false)), // Multiply speed to be proportional to your own, boosted maxspeed.
			(((180<<FRACBITS) - AngleFixed(input)) / 180) // multiply speed based on angle diff... i.e: don't do this for firing backward :V
			)));
	end

	x = source.x + source.momx + FixedMul(finalspeed, cos(an));
	y = source.y + source.momy + FixedMul(finalspeed, sin(an));
	z = source.z; // spawn on the ground please

	if (P_MobjFlip(source) < 0)
		z = source.z+source.height - mobjinfo[type].height;
	end

	th = P_SpawnMobj(x, y, z, type);
	th.shadowscale = FU

	th.flags2 = $ | flags2;

	th.threshold = 10;

	if (th.info.seesound)
		S_StartSound(source, th.info.seesound);
	end

	th.target = source;

	if (P_IsObjectOnGround(source))
		// floorz and ceilingz aren't properly set to account for FOFs and Polyobjects on spawn
		// This should set it for FOFs
		P_SetOrigin(th, th.x, th.y, th.z);
		// spawn on the ground if the player is on the ground
		if (P_MobjFlip(source) < 0)
			th.z = th.ceilingz - th.height;
			th.eflags = $ | MFE_VERTICALFLIP;
		else
			th.z = th.floorz;
		end
	end

	th.angle = an;
	th.momx = FixedMul(finalspeed, cos(an));
	th.momy = FixedMul(finalspeed, sin(an));

	if type == MT_ORBINAUT
		if (source and source.player)
			th.color = source.player.skincolor;
		else
			th.color = SKINCOLOR_GREY;
		end
		th.movefactor = finalspeed;
	elseif type == MT_JAWZ
		if (source and source.player)
			local lasttarg = source.player.kartstuff[k_lastjawztarget];
			th.cvmem = source.player.skincolor;
			if ((lasttarg >= 0 and lasttarg < 32)
				and players[lasttarg]
				and not players[lasttarg].spectator
				and players[lasttarg].mo and players[lasttarg].kart)
				th.tracer = players[lasttarg].mo;
			end
		else
			th.cvmem = SKINCOLOR_KETCHUP2;
		end
		/* FALLTHRU */
	elseif type == MT_JAWZ_DUD
		S_StartSound(th, th.info.activesound);
		/* FALLTHRU */
	elseif type == MT_SPB
		th.movefactor = finalspeed;
	end

	x = x + P_ReturnThrustX(source, an, source.radius + th.radius);
	y = y + P_ReturnThrustY(source, an, source.radius + th.radius);
-- 	throwmo = P_SpawnMobj(x, y, z, MT_FIREDITEM);
-- 	throwmo.movecount = 1;
-- 	throwmo.movedir = source.angle - an;
-- 	throwmo.target = source;

	return nil;
end
rawset(_G,"K_SpawnKartMissile",K_SpawnKartMissile)

local function K_ThrowKartItem(player, missile, mapthing, defaultDir, altthrow)
	local mo;
	local dir;
	local PROJSPEED;
	local newangle;
	local newx, newy, newz;
	local throwmo;

	if (not player)
		return nil;
	end

	// Figure out projectile speed by game speed
	if (missile)-- and mapthing != MT_BALLHOG) // Trying to keep compatability...
		PROJSPEED = mobjinfo[mapthing].speed;
		if (gamespeed == 0)
			PROJSPEED = FixedMul(PROJSPEED, FRACUNIT-FRACUNIT/4);
		elseif (gamespeed == 2)
			PROJSPEED = FixedMul(PROJSPEED, FRACUNIT+FRACUNIT/4);
		end
		PROJSPEED = FixedMul(PROJSPEED, mapobjectscale);
	else
		PROJSPEED = (68+14*gamespeed)*mapobjectscale
	end

	if (altthrow)
		if (altthrow == 2) // Kitchen sink throwing
			if (player.kartstuff[k_throwdir] == 1)
				dir = 2;
			else
				dir = 1;
			end
		else
			if (player.kartstuff[k_throwdir] == 1)
				dir = 2;
			elseif (player.kartstuff[k_throwdir] == -1)
				dir = -1;
			else
				dir = 1;
			end
		end
	else
		if (player.kartstuff[k_throwdir] != 0)
			dir = player.kartstuff[k_throwdir];
		else
			dir = defaultDir;
		end
	end

	if (missile) // Shootables
		if false--(mapthing == MT_BALLHOG) // Messy
			if (dir == -1)
				// Shoot backward
				mo = K_SpawnKartMissile(player.mo, mapthing, player.mo.angle + ANGLE_180 - 0x06000000, 0, PROJSPEED/16);
				K_SpawnKartMissile(player.mo, mapthing, player.mo.angle + ANGLE_180 - 0x03000000, 0, PROJSPEED/16);
				K_SpawnKartMissile(player.mo, mapthing, player.mo.angle + ANGLE_180, 0, PROJSPEED/16);
				K_SpawnKartMissile(player.mo, mapthing, player.mo.angle + ANGLE_180 + 0x03000000, 0, PROJSPEED/16);
				K_SpawnKartMissile(player.mo, mapthing, player.mo.angle + ANGLE_180 + 0x06000000, 0, PROJSPEED/16);
			else
				// Shoot forward
				mo = K_SpawnKartMissile(player.mo, mapthing, player.mo.angle - 0x06000000, 0, PROJSPEED);
				K_SpawnKartMissile(player.mo, mapthing, player.mo.angle - 0x03000000, 0, PROJSPEED);
				K_SpawnKartMissile(player.mo, mapthing, player.mo.angle, 0, PROJSPEED);
				K_SpawnKartMissile(player.mo, mapthing, player.mo.angle + 0x03000000, 0, PROJSPEED);
				K_SpawnKartMissile(player.mo, mapthing, player.mo.angle + 0x06000000, 0, PROJSPEED);
			end
		else
			if (dir == -1 and mapthing != MT_SPB)
				// Shoot backward
				mo = K_SpawnKartMissile(player.mo, mapthing, player.mo.angle + ANGLE_180, 0, PROJSPEED/8);
			else
				// Shoot forward
				mo = K_SpawnKartMissile(player.mo, mapthing, player.mo.angle, 0, PROJSPEED);
			end
		end
	else
		player.kartstuff[k_bananadrag] = 0; // RESET timer, for multiple bananas

		if (dir > 0)
			// Shoot forward
			mo = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z + player.mo.height/2, mapthing);
			//K_FlipFromObject(mo, player.mo);
			// These are really weird so let's make it a very specific case to make SURE it works...
			if (player.mo.eflags & MFE_VERTICALFLIP)
				mo.z = $ - player.mo.height;
				mo.flags2 = $ | MF2_OBJECTFLIP;
				mo.eflags = $ | MFE_VERTICALFLIP;
			end

			mo.threshold = 10;
			mo.target = player.mo;

			S_StartSound(player.mo, mo.info.seesound);

			if (mo)
				local fa = player.mo.angle;
				local HEIGHT = (20 + (dir*10))*mapobjectscale + (player.mo.momz*P_MobjFlip(player.mo));

				mo.momz = HEIGHT*P_MobjFlip(mo);
				mo.momx = player.mo.momx + FixedMul(cos(fa), PROJSPEED*dir);
				mo.momy = player.mo.momy + FixedMul(sin(fa), PROJSPEED*dir);

				mo.extravalue2 = dir;

				if (mo.eflags & MFE_UNDERWATER)
					mo.momz = (117 * mo.momz) / 200;
				end
			end

			// this is the small graphic effect that plops in you when you throw an item:
-- 			throwmo = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z + player.mo.height/2, MT_FIREDITEM);
-- 			throwmo.target = player.mo;
-- 			// Ditto:
-- 			if (player.mo.eflags & MFE_VERTICALFLIP)
-- 				throwmo.z = $ - player.mo.height;
-- 				throwmo.flags2 = $ | MF2_OBJECTFLIP;
-- 				throwmo.eflags = $ | MFE_VERTICALFLIP;
-- 			end

-- 			throwmo.movecount = 0; // above player
		else
			local lasttrail = K_FindLastTrailMobj(player);

			if (lasttrail)
				newx = lasttrail.x;
				newy = lasttrail.y;
				newz = lasttrail.z;
			else
				// Drop it directly behind you.
				local dropradius = FixedHypot(player.mo.radius, player.mo.radius) + FixedHypot(mobjinfo[mapthing].radius, mobjinfo[mapthing].radius);

				newangle = player.mo.angle;

				newx = player.mo.x + P_ReturnThrustX(player.mo, newangle + ANGLE_180, dropradius);
				newy = player.mo.y + P_ReturnThrustY(player.mo, newangle + ANGLE_180, dropradius);
				newz = player.mo.z;
			end

			mo = P_SpawnMobj(newx, newy, newz, mapthing); // this will never return null because collision isn't processed here
			K_FlipFromObject(mo, player.mo);

			mo.threshold = 10;
			mo.shadowscale = FU
			mo.target = player.mo;

			if (P_IsObjectOnGround(player.mo))
				// floorz and ceilingz aren't properly set to account for FOFs and Polyobjects on spawn
				// This should set it for FOFs
				P_SetOrigin(mo, mo.x, mo.y, mo.z); // however, THIS can fuck up your day. just absolutely ruin you.
				if (not mo.valid)
					return nil;
				end

				if (P_MobjFlip(mo) > 0)
					if (mo.floorz > mo.target.z - mo.height)
						mo.z = mo.floorz;
					end
				else
					if (mo.ceilingz < mo.target.z + mo.target.height + mo.height)
						mo.z = mo.ceilingz - mo.height;
					end
				end
			end

			if (player.mo.eflags & MFE_VERTICALFLIP)
				mo.eflags = $ | MFE_VERTICALFLIP;
			end

-- 			if (mapthing == MT_SSMINE)
-- 				mo.extravalue1 = 49; // Pads the start-up length from 21 frames to a full 2 seconds
-- 			end
		end
	end

	return mo;
end
rawset(_G,"K_ThrowKartItem",K_ThrowKartItem)

local function K_DoShrink(user)
	local i;

	S_StartSound(user.mo, sfx_kc46); // Sound the BANG!
-- 	user.pflags |= PF_ATTACKDOWN;

	for p in players.iterate
		if (not p or not p.mo or not p.kart)
			continue;
		end
		if (p == user)
			continue;
		end
		if (p.kartstuff[k_position] < user.kartstuff[k_position])
			//P_FlashPal(p, PAL_NUKE, 10);

			// Grow should get taken away.
			if (p.kartstuff[k_growshrinktimer] > 0)
				K_RemoveGrowShrink(p);
			// Don't hit while invulnerable!
			elseif (not p.kartstuff[k_invincibilitytimer]
				and p.kartstuff[k_growshrinktimer] <= 0
				and not p.kartstuff[k_hyudorotimer])
				// Start shrinking!
-- 				K_DropItems(p);
				p.kartstuff[k_growshrinktimer] = -(20*TICRATE);

				if (p.mo and p.mo.valid)
					p.mo.scalespeed = mapobjectscale/TICRATE;
					p.mo.destscale = (6*mapobjectscale)/8;
-- 					if (cv_kartdebugshrink.value and not modeattacking and not p.bot)
-- 						p.mo.destscale = (6*p.mo.destscale)/8;
-- 					end
					S_StartSound(p.mo, sfx_kc59);
				end
			end
		end
	end
end


local function K_RemoveGrowShrink(player)
	if (player.mo and player.mo.valid)
		if (player.kartstuff[k_growshrinktimer] > 0) // Play Shrink noise
			S_StartSound(player.mo, sfx_kc59);
		elseif (player.kartstuff[k_growshrinktimer] < 0) // Play Grow noise
			S_StartSound(player.mo, sfx_kc5a);
		end

		if (player.kartstuff[k_invincibilitytimer] == 0)
			player.mo.color = player.skincolor;
		end

		player.mo.scalespeed = mapobjectscale/TICRATE;
		player.mo.destscale = mapobjectscale;
-- 		if (cv_kartdebugshrink.value && !modeattacking && !player.bot)
-- 			player.mo.destscale = (6*player.mo.destscale)/8;
-- 		end
	end

	player.kartstuff[k_growshrinktimer] = 0;
	player.kartstuff[k_growcancel] = -1;

	P_RestoreMusic(player);
end
rawset(_G,"K_RemoveGrowShrink",K_RemoveGrowShrink)

// Just for firing/dropping items.
local function K_UpdateHnextList(player, clean)
	local work = player.mo
	local nextwork;

	if (not work)
		return;
	end

	nextwork = work.hnext;
	work = nextwork;

	while (work and work.valid)
		nextwork = work.hnext;

		if (not clean and (not work.movedir or work.movedir <= player.kartstuff[k_itemamount]))
			work = nextwork;
			continue;
		end

		P_RemoveMobj(work);
		work = nextwork;
	end
end


local function UpdateItem(player,onground)
	local cmd = player.kmd;
-- 	local ATTACK_IS_DOWN = ((cmd.buttons & BT_ATTACK) and not (player.pflags & PF_ATTACKDOWN));
	local ATTACK_IS_DOWN = ((cmd.buttons & BT_CUSTOM3) and not (player.klastbuttons & BT_CUSTOM3));
	local HOLDING_ITEM = (player.kartstuff[k_itemheld] or player.kartstuff[k_eggmanheld]);
	local NO_HYUDORO = (player.kartstuff[k_stolentimer] == 0 and player.kartstuff[k_stealingtimer] == 0);
	
	if (player and player.mo and player.mo.health > 0 and not player.spectator and not (player.exiting or mapreset)
	and player.kartstuff[k_spinouttimer] == 0 and player.kartstuff[k_squishedtimer] == 0 and player.kartstuff[k_respawn] == 0)
		// First, the really specific, finicky items that function without the item being directly in your item slot.
		// Karma item dropping
		if (ATTACK_IS_DOWN and player.kartstuff[k_comebackmode] and not player.kartstuff[k_comebacktimer])
			local newitem;

			if (player.kartstuff[k_comebackmode] == 1)
				newitem = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_RANDOMITEM);
				newitem.threshold = 69; // selected "randomly".
			else
				newitem = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_EGGMANITEM);
				if (player.kartstuff[k_eggmanblame] >= 0
				and player.kartstuff[k_eggmanblame] < MAXPLAYERS
				and players[player.kartstuff[k_eggmanblame]].valid
				and not players[player.kartstuff[k_eggmanblame]].spectator
				and players[player.kartstuff[k_eggmanblame]].mo)
					newitem.target = players[player.kartstuff[k_eggmanblame]].mo;
				end
				player.kartstuff[k_eggmanblame] = -1;
			end

			newitem.flags2 = (player.mo.flags2 & MF2_OBJECTFLIP);
			newitem.fuse = 15*TICRATE; // selected randomly.

			player.kartstuff[k_comebackmode] = 0;
			player.kartstuff[k_comebacktimer] = comebacktime;
			S_StartSound(player.mo, sfx_s254);
		// Eggman Monitor exploding
		elseif (player.kartstuff[k_eggmanexplode])
			if (ATTACK_IS_DOWN and player.kartstuff[k_eggmanexplode] <= 3*TICRATE and player.kartstuff[k_eggmanexplode] > 1)
				player.kartstuff[k_eggmanexplode] = 1;
			end
		// Eggman Monitor throwing
		elseif (ATTACK_IS_DOWN and player.kartstuff[k_eggmanheld])
			K_ThrowKartItem(player, false, MT_EGGMANITEM, -1, 0);
			K_PlayAttackTaunt(player.mo);
			player.kartstuff[k_eggmanheld] = 0;
-- 			K_UpdateHnextList(player, true);
		// Rocket Sneaker
		elseif (ATTACK_IS_DOWN and not HOLDING_ITEM and onground and NO_HYUDORO
			and player.kartstuff[k_rocketsneakertimer] > 1)
			K_DoSneaker(player, 2);
			K_PlayBoostTaunt(player.mo);
			player.kartstuff[k_rocketsneakertimer] = $ - 2*TICRATE;
			if (player.kartstuff[k_rocketsneakertimer] < 1)
				player.kartstuff[k_rocketsneakertimer] = 1;
			end
		// Grow Canceling
		elseif (player.kartstuff[k_growshrinktimer] > 0) and not kart_rrpoweritems.value
			if (player.kartstuff[k_growcancel] >= 0)
				if (cmd.buttons & BT_CUSTOM3)--BT_ATTACK)
					player.kartstuff[k_growcancel] = $ + 1;
					if (player.kartstuff[k_growcancel] > 26)
						K_RemoveGrowShrink(player);
					end
				else
					player.kartstuff[k_growcancel] = 0;
				end
			else
				if ((cmd.buttons & BT_CUSTOM3))--BT_ATTACK) or (player.pflags & PF_ATTACKDOWN))
					player.kartstuff[k_growcancel] = -1;
				else
					player.kartstuff[k_growcancel] = 0;
				end
			end		// Ring boosts with no item
		elseif (player.kartstuff[k_itemtype] == KITEM_NONE)
			if (--[[(player.pflags & PF_ATTACKDOWN)]](cmd.buttons & BT_CUSTOM3) and not HOLDING_ITEM and NO_HYUDORO
				and not player.kartstuff[k_itemroulette] and not player.kartstuff[k_ringdelay]
				and player.kartstuff[k_rings] > 0)
				local ring = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_RING);
				ring.extravalue1 = 1; // Ring use animation timer
				ring.extravalue2 = 1; // Ring use animation flag
				ring.target = player.mo; // user
				player.kartstuff[k_rings] = $ - 1;
				player.kartstuff[k_ringdelay] = 3;
			end
		elseif (player.kartstuff[k_itemamount] == 0)--<= 0)
			player.kartstuff[k_itemamount], player.kartstuff[k_itemheld] = 0, 0;
		else
			local i = player.kartstuff[k_itemtype]
			if i == KITEM_SUPERRING
				if (ATTACK_IS_DOWN and not HOLDING_ITEM and NO_HYUDORO)
					player.kartstuff[k_superring] = $ + (10*3);
					player.kartstuff[k_itemamount] = $ - 1;
				end
			elseif i == KITEM_SNEAKER
				if (ATTACK_IS_DOWN and not HOLDING_ITEM and onground and NO_HYUDORO)
					K_DoSneaker(player, 1);
					K_PlayBoostTaunt(player.mo);
					player.kartstuff[k_itemamount] = $ - 1;
				end
			elseif i == KITEM_ROCKETSNEAKER
				if (ATTACK_IS_DOWN and not HOLDING_ITEM and onground and NO_HYUDORO
					and player.kartstuff[k_rocketsneakertimer] == 0)
					local mo = nil;
					local prev = player.mo;

					K_PlayBoostTaunt(player.mo);
					//player.kartstuff[k_itemheld] = 1;
					S_StartSound(player.mo, sfx_s3k3a);

					//K_DoSneaker(player, 2);

					player.kartstuff[k_rocketsneakertimer] = (itemtime*3);
					player.kartstuff[k_itemamount] = $ - 1;
-- 						K_UpdateHnextList(player, true);

					for moloop = 0,2-1
-- 						mo = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_ROCKETSNEAKER);
-- 						K_MatchGenericExtraFlags(mo, player.mo);
-- 						mo.flags = $ | MF_NOCLIPTHING;
-- 						mo.angle = player.mo.angle;
-- 						mo.threshold = 10;
-- 						mo.movecount = moloop%2;
-- 						mo.movedir,mo.lastlook = moloop+1,moloop+1;
-- 						mo.target = player.mo;
-- 						mo.hprev = prev;
-- 						prev.hnext = mo;
-- 						prev = mo;
					end
				end
			elseif i == KITEM_INVINCIBILITY
				if (ATTACK_IS_DOWN and not HOLDING_ITEM and NO_HYUDORO) // Doesn't hold your item slot hostage normally, so you're free to waste it if you have multiple
					if (not player.kartstuff[k_invincibilitytimer])
						local overlay = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_INVULNFLASH);
						overlay.target = player.mo;
						overlay.scale = player.mo.scale;
					end
					
					if kart_rrpoweritems.value
						local pingame = 0
						for p in players.iterate
							if p and p.valid and p.mo and p.kart
								pingame = $ + 1
							end
						end
						
						local behind = min(dist(player,pingame) * TICRATE/4500, 10*TICRATE)
						player.kartstuff[k_invincibilitytimer] = max(7*TICRATE+behind,$+5*TICRATE)
					else
						player.kartstuff[k_invincibilitytimer] = itemtime+(2*TICRATE); // 10 seconds
					end
					P_RestoreMusic(player);
					S_ChangeMusic("kinvnc",true)
					if (player ~= displayplayer)
						S_StartSound(player.mo, (kart_invinsfx.value and sfx_alarmi or sfx_kinvnc));
					end
					K_PlayPowerGloatSound(player.mo);
					player.kartstuff[k_itemamount] = $ - 1;
				end
			elseif i == KITEM_BANANA
				if (ATTACK_IS_DOWN and not HOLDING_ITEM and NO_HYUDORO)
					local mo;
					local prev = player.mo;

					//K_PlayAttackTaunt(player.mo);
					player.kartstuff[k_itemheld] = 1;
					S_StartSound(player.mo, sfx_s254);

					for moloop = 0,player.kartstuff[k_itemamount]-1
						mo = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_BANANA_SHIELD);
						if (not mo)
							player.kartstuff[k_itemamount] = moloop;
							break
						else
							mo.flags = $ | MF_NOCLIPTHING;
							mo.threshold = 10;
							mo.movecount = player.kartstuff[k_itemamount];
							mo.movedir = moloop+1;
							mo.shadowscale = FU
							mo.target = player.mo;
							mo.hprev = prev;
							prev.hnext = mo;
							prev = mo;
						end
					end
				elseif (ATTACK_IS_DOWN and player.kartstuff[k_itemheld]) // Banana x3 thrown
					K_ThrowKartItem(player, false, MT_BANANA, -1, 0);
					K_PlayAttackTaunt(player.mo);
					player.kartstuff[k_itemamount] = $ - 1;
					K_UpdateHnextList(player, false);
				end
			elseif i == KITEM_EGGMAN-- and false
				if (ATTACK_IS_DOWN and not HOLDING_ITEM and NO_HYUDORO)
-- 					local mo;
					player.kartstuff[k_itemamount] = $ - 1;
-- 					player.kartstuff[k_eggmanheld] = 1;
					S_StartSound(player.mo, sfx_s254);
-- 					mo = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_EGGMANITEM_SHIELD);
-- 					if (mo)
-- 						mo.flags = $ | MF_NOCLIPTHING;
-- 						mo.threshold = 10;
-- 						mo.movecount = 1;
-- 						mo.movedir = 1;
-- 						mo.target = player.mo;
-- 						player.mo.hnext = mo;
-- 					end
				end
			elseif i == KITEM_ORBINAUT
				if (ATTACK_IS_DOWN and not HOLDING_ITEM and NO_HYUDORO)
					local newangle;
					local mo = nil;
					local prev = player.mo;

					//K_PlayAttackTaunt(player.mo);
					player.kartstuff[k_itemheld] = 1;
					S_StartSound(player.mo, sfx_s3k3a);

					for moloop = 0,player.kartstuff[k_itemamount]-1
						newangle = (player.mo.angle + ANGLE_157h) + FixedAngle(((360 / player.kartstuff[k_itemamount]) * moloop) << FRACBITS) + ANGLE_90;
						mo = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_ORBINAUT_SHIELD);
						if (not mo)
							player.kartstuff[k_itemamount] = moloop;
						else
							mo.flags = $ | MF_NOCLIPTHING;
							mo.shadowscale = FU
							mo.angle = newangle;
							mo.threshold = 10;
							mo.movecount = player.kartstuff[k_itemamount];
							mo.movedir, mo.lastlook = moloop+1, moloop+1;
							mo.color = player.skincolor;
							mo.target = player.mo;
							mo.hprev = prev;
							prev.hnext = mo;
							prev = mo;
						end
					end
				elseif (ATTACK_IS_DOWN and player.kartstuff[k_itemheld]) // Orbinaut x3 thrown
					K_ThrowKartItem(player, true, MT_ORBINAUT, 1, 0);
					K_PlayAttackTaunt(player.mo);
					player.kartstuff[k_itemamount] = $ - 1;
					K_UpdateHnextList(player, false);
				end
			elseif i == KITEM_JAWZ
				if (ATTACK_IS_DOWN and not HOLDING_ITEM and NO_HYUDORO)
					local newangle;
					local mo = NULL;
					local prev = player.mo;

					//K_PlayAttackTaunt(player.mo);
					player.kartstuff[k_itemheld] = 1;
					S_StartSound(player.mo, sfx_s3k3a);

					for moloop = 0,player.kartstuff[k_itemamount]-1
						newangle = (player.mo.angle + ANGLE_157h) + FixedAngle(((360 / player.kartstuff[k_itemamount]) * moloop) << FRACBITS) + ANGLE_90;
						mo = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_JAWZ_SHIELD);
						if (not mo)
							player.kartstuff[k_itemamount] = moloop;
						else
							mo.flags = $ | MF_NOCLIPTHING;
							mo.angle = newangle;
							mo.threshold = 10;
							mo.movecount = player.kartstuff[k_itemamount];
							mo.movedir, mo.lastlook = moloop+1, moloop+1;
							mo.target = player.mo;
							mo.hprev = prev;
							prev.hnext = mo;
							prev = mo;
						end
					end
				elseif (ATTACK_IS_DOWN and HOLDING_ITEM and player.kartstuff[k_itemheld]) // Jawz thrown
					if (player.kartstuff[k_throwdir] == 1 or player.kartstuff[k_throwdir] == 0)
						K_ThrowKartItem(player, true, MT_JAWZ, 1, 0);
					elseif (player.kartstuff[k_throwdir] == -1) // Throwing backward gives you a dud that doesn't home in
						K_ThrowKartItem(player, true, MT_JAWZ_DUD, -1, 0);
					end
					K_PlayAttackTaunt(player.mo);
					player.kartstuff[k_itemamount] = $ - 1;
					K_UpdateHnextList(player, false);
				end
			elseif i == KITEM_MINE-- and false
				if (ATTACK_IS_DOWN and not HOLDING_ITEM and NO_HYUDORO)
-- 					local mo;
-- 					player.kartstuff[k_itemheld] = 1;
					S_StartSound(player.mo, sfx_s254);
-- 					mo = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_SSMINE_SHIELD);
-- 					if (mo)
-- 						mo.flags = $ | MF_NOCLIPTHING;
-- 						mo.threshold = 10;
-- 						mo.movecount = 1;
-- 						mo.movedir = 1;
-- 						mo.target = player.mo;
-- 						player.mo.hnext = mo;
-- 					end
-- 				elseif (ATTACK_IS_DOWN and player.kartstuff[k_itemheld])
-- 					K_ThrowKartItem(player, false, MT_SSMINE, 1, 1);
					K_PlayAttackTaunt(player.mo);
					player.kartstuff[k_itemamount] = $ - 1;
					player.kartstuff[k_itemheld] = 0;
-- 					K_UpdateHnextList(player, true);
				end
			elseif i == KITEM_BALLHOG-- and false
				if (ATTACK_IS_DOWN and not HOLDING_ITEM and NO_HYUDORO)
					player.kartstuff[k_itemamount] = $ - 1;
-- 					K_ThrowKartItem(player, true, MT_BALLHOG, 1, 0);
					K_PlayAttackTaunt(player.mo);
				end
			elseif i == KITEM_SPB
				if (ATTACK_IS_DOWN and not HOLDING_ITEM and NO_HYUDORO)
					player.kartstuff[k_itemamount] = $ - 1;
					K_ThrowKartItem(player, true, MT_SPB, 1, 0);
					K_PlayAttackTaunt(player.mo);
				end
			elseif i == KITEM_GROW
				if (ATTACK_IS_DOWN and not HOLDING_ITEM and NO_HYUDORO
					and (player.kartstuff[k_growshrinktimer] <= 0 or kart_rrpoweritems.value)) // Grow holds the item box hostage
					if (player.kartstuff[k_growshrinktimer] < 0 and not kart_rrpoweritems.value) // If you're shrunk, then "grow" will just make you normal again.
						K_RemoveGrowShrink(player);
					else
						if player.kartstuff[k_growshrinktimer] < 0 and kart_rrpoweritems.value
							K_RemoveGrowShrink(player);
						end
						K_PlayPowerGloatSound(player.mo);
						player.mo.scalespeed = mapobjectscale/TICRATE;
						player.mo.destscale = (3*mapobjectscale)/2;
-- 						if (cv_kartdebugshrink.value and not modeattacking and not player.bot)
-- 							player.mo.destscale = (6*player.mo.destscale)/8;
-- 						end
						if kart_rrpoweritems.value
							player.kartstuff[k_growshrinktimer] = max($,0)
							player.kartstuff[k_growshrinktimer] = $ + 12*TICRATE
						else
							player.kartstuff[k_growshrinktimer] = itemtime+(4*TICRATE); // 12 seconds
						end
						P_RestoreMusic(player);
						S_ChangeMusic("kgrow",true)
						if (player ~= displayplayer)
							S_StartSound(player.mo, (kart_invinsfx.value and sfx_alarmg or sfx_kgrow));
						end
						S_StartSound(player.mo, sfx_kc5a);
					end
					player.kartstuff[k_itemamount] = $ - 1;
				end
			elseif i == KITEM_SHRINK
				if (ATTACK_IS_DOWN and not HOLDING_ITEM and NO_HYUDORO)
					K_DoShrink(player);
					player.kartstuff[k_itemamount] = $ - 1;
					K_PlayPowerGloatSound(player.mo);
				end
			elseif i == KITEM_THUNDERSHIELD-- and false
-- 				if (player.kartstuff[k_curshield] != 1)
-- 					local shield = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_THUNDERSHIELD);
-- 					shield.scale = (5*shield.destscale)>>2
-- 					shield.target = player.mo;
-- 					S_StartSound(shield, sfx_s3k41);
-- 					player.kartstuff[k_curshield] = 1;
-- 				end
				if (ATTACK_IS_DOWN and not HOLDING_ITEM and NO_HYUDORO)
-- 					K_DoThunderShield(player);
					player.kartstuff[k_itemamount] = $ - 1;
					K_PlayAttackTaunt(player.mo);
				end
			elseif i == KITEM_HYUDORO-- and false
				if (ATTACK_IS_DOWN and not HOLDING_ITEM and NO_HYUDORO)
					player.kartstuff[k_itemamount] = $ - 1;
-- 					K_DoHyudoroSteal(player); // yes. yes they do.
				end
			elseif i == KITEM_POGOSPRING
				if (ATTACK_IS_DOWN and not HOLDING_ITEM and onground and NO_HYUDORO
					and not player.kartstuff[k_pogospring])
					K_PlayBoostTaunt(player.mo);
					K_DoPogoSpring(player.mo, 32<<FRACBITS, 2);
					player.kartstuff[k_pogospring] = 1;
					player.kartstuff[k_itemamount] = $ - 1;
				end
			elseif i == KITEM_KITCHENSINK-- and false
				if (ATTACK_IS_DOWN and not HOLDING_ITEM and NO_HYUDORO)
-- 					local mo;
-- 					player.kartstuff[k_itemheld] = 1;
					S_StartSound(player.mo, sfx_s254);
-- 					mo = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_SINK_SHIELD);
-- 					if (mo)
-- 						mo.flags = $ | MF_NOCLIPTHING;
-- 						mo.threshold = 10;
-- 						mo.movecount = 1;
-- 						mo.movedir = 1;
-- 						mo.target = player.mo;
-- 						player.mo.hnext = mo;
-- 					end
-- 				elseif (ATTACK_IS_DOWN and HOLDING_ITEM and player.kartstuff[k_itemheld]) // Sink thrown
-- 					K_ThrowKartItem(player, false, MT_SINK, 1, 2);
					K_PlayAttackTaunt(player.mo);
					player.kartstuff[k_itemamount] = $ - 1;
					player.kartstuff[k_itemheld] = 0;
-- 					K_UpdateHnextList(player, true);
				end
			elseif i == KITEM_SAD
				if (ATTACK_IS_DOWN and not HOLDING_ITEM and NO_HYUDORO
					and not player.kartstuff[k_sadtimer])
					player.kartstuff[k_sadtimer] = stealtime;
					player.kartstuff[k_itemamount] = $ - 1;
				end
			end
		end

		// Prevent ring misfire
		if (player.kartstuff[k_itemtype] != KITEM_NONE)
			player.kartstuff[k_ringdelay] = 15;
		end
		// No more!
		if (not player.kartstuff[k_itemamount])
			player.kartstuff[k_itemheld] = 0;
			player.kartstuff[k_itemtype] = KITEM_NONE;
		end

		if (player.kartstuff[k_itemtype] != KITEM_THUNDERSHIELD)
			player.kartstuff[k_curshield] = 0;
		end

		if (player.kartstuff[k_growshrinktimer] <= 0)
			player.kartstuff[k_growcancel] = -1;
		end

		if (player.kartstuff[k_itemtype] == KITEM_SPB
			or player.kartstuff[k_itemtype] == KITEM_SHRINK
			or player.kartstuff[k_growshrinktimer] < 0)
			indirectitemcooldown = 20*TICRATE;
		end

		if (player.kartstuff[k_hyudorotimer] > 0)
			if (splitscreen)
				if (leveltime & 1)
					player.mo.flags2 = $ | MF2_DONTDRAW;
				else
					player.mo.flags2 = $ & ~MF2_DONTDRAW;
				end

				if (player.kartstuff[k_hyudorotimer] >= (1*TICRATE/2) and player.kartstuff[k_hyudorotimer] <= hyudorotime-(1*TICRATE/2))
					if (player ~= displayplayer)
-- 						player.mo.eflags = $ | MFE_DRAWONLYFORP2;
-- 					else
						player.mo.flags2 = $ | MF2_DONTDRAW;
					end
				end
			else
				if (player == displayplayer
					or (player ~= displayplayer and (player.kartstuff[k_hyudorotimer] < (1*TICRATE/2) or player.kartstuff[k_hyudorotimer] > hyudorotime-(1*TICRATE/2))))
					if (leveltime & 1)
						player.mo.flags2 = $ | MF2_DONTDRAW;
					else
						player.mo.flags2 = $ & ~MF2_DONTDRAW;
					end
				else
					player.mo.flags2 = $ | MF2_DONTDRAW;
				end
			end

			player.kartflashing = player.kartstuff[k_hyudorotimer]; // We'll do this for now, let's people know about the invisible people through subtle hints
		elseif (player.kartstuff[k_hyudorotimer] == 0)
			player.mo.flags2 = $ & ~MF2_DONTDRAW;
		end
	end
end
rawset(_G,"UpdateItem",UpdateItem)

local function K_MoveHeldObjects(player)
	local mo = player.mo
	if not mo or not mo.valid return end
	
	if not mo.hnext or not mo.hnext.valid
		mo.hnext = nil
		player.kartstuff[k_bananadrag] = 0
		if player.kartstuff[k_eggmanheld]
			player.kartstuff[k_eggmanheld] = 0
		elseif player.kartstuff[k_itemheld]
			player.kartstuff[k_itemamount],player.kartstuff[k_itemheld] = 0,0
			player.kartstuff[k_itemtype] = 0
		end
		return
	end
	
	local t = mo.hnext.type
	if t == MT_ORBINAUT_SHIELD or t == MT_JAWZ_SHIELD
		local cur = mo.hnext
		local speed = ((8-min(4,player.kartstuff[k_itemamount]))*cur.info.speed)/7
		while cur and cur.valid
			local radius = fixhypot(mo.radius,mo.radius)+fixhypot(cur.radius,cur.radius)
			local z = mo.z
			if not cur.health
				cur = $.hnext
				continue
			end
			
			cur.color = player.skincolor
			cur.angle = $ - ANGLE_90 + fixangle(speed)
			
			if cur.extravalue1 < radius
				cur.extravalue1 = $ + P_AproxDistance(cur.extravalue1,radius)/12
			end
			cur.extravalue1 = min($,radius)
			
			cur.eflags = ($ & ~MFE_VERTICALFLIP) | (mo.eflags & MFE_VERTICALFLIP)
			cur.scale = fixmul(fixdiv(cur.extravalue1,radius),mo.scale)
			
			if P_MobjFlip(cur) < 0
				z = $ + mo.height - cur.height
			end
			
			cur.flags = $ | MF_NOCLIPTHING
			P_MoveOrigin(cur,mo.x,mo.y,z)
			cur.momx = fixmul(cos(cur.angle),cur.extravalue1)
			cur.momy = fixmul(sin(cur.angle),cur.extravalue1)
			cur.flags = $ & ~MF_NOCLIPTHING
			if not P_TryMove(cur,mo.x+cur.momx,mo.y+cur.momy,true)
				P_SlideMove(cur,true)
			end
			
			if P_IsObjectOnGround(mo)
				if P_MobjFlip(cur) > 0
					if cur.floorz > mo.z-cur.height
						z = cur.floorz
					end
				else
					if cur.ceilingz < mo.z+mo.height+cur.height
						z = cur.ceilingz-cur.height
					end
				end
			end
			
			z = $ + (fixmul(cur.info.height, mo.scale-cur.scale)>>1)*P_MobjFlip(cur)
			cur.z = z
			cur.momx,cur.momy = 0,0
			cur.angle = $ + ANGLE_90
			cur = $.hnext
		end
	elseif t == MT_BANANA_SHIELD
		local cur = mo.hnext
		local targ = mo
		
		if P_IsObjectOnGround(mo) and player.speed > 0
			player.kartstuff[k_bananadrag] = $ + 1
		end
		
		while cur and cur.valid
			local radius = FixedHypot(targ.radius,targ.radius)+FixedHypot(cur.radius,cur.radius)
			local ang
			local targx,targy,targz
			local speed,dist
			
			cur.flags = $ & ~MF_NOCLIPTHING
			
			if not cur.health
				cur = $.hnext
				continue
			end
			
			if cur.extravalue1 < radius
				cur.extravalue1 = $ + fixmul(P_AproxDistance(cur.extravalue1,radius),FU/12)
			end
			
			cur.extravalue1 = min($,radius)
			
			if cur ~= mo.hnext
				targ = cur.hprev
				dist = cur.extravalue1/4
			else
				dist = cur.extravalue1/2
			end
			
			if not targ or not targ.valid
				continue
			end
			
			cur.scale = fixmul(fixdiv(cur.extravalue1,radius),mo.scale)
			
			ang = targ.angle
			targx = targ.x + P_ReturnThrustX(cur,ang+ANGLE_180,dist)
			targy = targ.y + P_ReturnThrustY(cur,ang+ANGLE_180,dist)
			targz = targ.z
			
			speed = fixmul(R_PointToDist2(cur.x,cur.y,targx,targy),FU*3/4)
			if P_IsObjectOnGround(targ)
				targz = cur.floorz
			end
			
			cur.angle = R_PointToAngle2(cur.x,cur.y,targx,targy)
			
			if speed > dist
				P_InstaThrust(cur,cur.angle,speed-dist)
			end
			
			P_SetObjectMomZ(cur,fixmul(targz-cur.z,FU*7/8)-gravity*8/5,false)
			
			if R_PointToDist2(cur.x,cur.y,targx,targy) > 768*FU
				P_MoveOrigin(cur,targx,targy,cur.z)
			end
			
			cur = $.hnext
		end
	--..
	end
			
end
rawset(_G,"K_MoveHeldObjects",K_MoveHeldObjects)

local function K_GetKartFlashing(player)
	local tics = flashingtics/2;

	if (not player)
		return tics;
	end

	if (false)--G_BattleGametype())
		tics = $ * 2;
	end

	tics = $ + (flashingtics/8/2) * (player.kartspeed);

	return tics;
end
rawset(_G,"K_GetKartFlashing",K_GetKartFlashing)

local function K_SpinPlayer(player, source, type, inflictor, trapitem)
	local scoremultiply = 1;
	// PS: Inflictor is unused for all purposes here and is actually only ever relevant to Lua. It may be nil too.
-- #ifdef HAVE_BLUA
-- 	boolean force = false;	// Used to check if Lua ShouldSpin should get us damaged reguardless of flashtics or heck knows what.
-- 	UINT8 shouldForce = LUAh_ShouldSpin(player, inflictor, source);
-- 	if (P_MobjWasRemoved(player.mo))
-- 		return; // mobj was removed (in theory that shouldn't happen)
-- 	if (shouldForce == 1)
-- 		force = true;
-- 	else if (shouldForce == 2)
-- 		return;
-- #else
	local force = false;
	local inflictor;	// in case some weirdo doesn't want Lua.
-- #endif


	if (not trapitem and false)-- G_BattleGametype())
		if (K_IsPlayerWanted(player))
			scoremultiply = 3;
		elseif (player.kartstuff[k_bumper] == 1)
			scoremultiply = 2;
		end
	end

	if (player.mo.health <= 0)
		return;
	end

	if (player.kartflashing > 0 or player.kartstuff[k_squishedtimer] > 0 or player.kartstuff[k_spinouttimer] > 0
		or player.kartstuff[k_invincibilitytimer] > 0 or player.kartstuff[k_growshrinktimer] > 0 or player.kartstuff[k_hyudorotimer] > 0
		or (false--[[G_BattleGametype()]] and ((player.kartstuff[k_bumper] <= 0 and player.kartstuff[k_comebacktimer]) or player.kartstuff[k_comebackmode] == 1)))
		if (not force)	// if shoulddamage force, we go THROUGH that.
-- 			K_DoInstashield(player);
			return;
		end
	end

-- 	if (source and source != player.mo and source.player)
-- 		K_PlayHitEmSound(source);
-- 	end

	//player.kartstuff[k_sneakertimer] = 0;
	player.kartstuff[k_driftboost] = 0;

	player.kartstuff[k_drift] = 0;
	player.kartstuff[k_driftcharge] = 0;
	player.kartstuff[k_pogospring] = 0;

	if false--(G_BattleGametype())
		if (source and source.player and player != source.player)
			P_AddPlayerScore(source.player, scoremultiply);
			K_SpawnBattlePoints(source.player, player, scoremultiply);
			if (not trapitem)
				source.player.kartstuff[k_wanted] = $ - wantedreduce;
				player.kartstuff[k_wanted] = $ - (wantedreduce/2);
			end
		end

		if (player.kartstuff[k_bumper] > 0)
			if (player.kartstuff[k_bumper] == 1)
				local karmahitbox = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_KARMAHITBOX); // Player hitbox is too small!!
				karmahitbox.target = player.mo;
				karmahitbox.scale = player.mo.scale;
				CONS_Printf(string.format("%s lost all of their bumpers!\n", player_names[player-players]));
			end
			player.kartstuff[k_bumper] = $ - 1;
			if (K_IsPlayerWanted(player))
				K_CalculateBattleWanted();
			end
		end

		if (not player.kartstuff[k_bumper])
			player.kartstuff[k_comebacktimer] = comebacktime;
			if (player.kartstuff[k_comebackmode] == 2)
				local poof = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_EXPLODE);
				S_StartSound(poof, mobjinfo[MT_KARMAHITBOX].seesound);
				player.kartstuff[k_comebackmode] = 0;
			end
		end

		K_CheckBumpers();
	end

	player.kartstuff[k_spinouttype] = type;

	if (player.kartstuff[k_spinouttype] <= 0) // type 0 is spinout, type 1 is wipeout, type 2 is spb
		// At spinout, player speed is increased to 1/4 their regular speed, moving them forward
		if (player.speed < K_GetKartSpeed(player, true)/4)
			P_InstaThrust(player.mo, player.mo.angle, FixedMul(K_GetKartSpeed(player, true)/4, player.mo.scale));
		end
		S_StartSound(player.mo, sfx_slip);
	end

	player.kartstuff[k_spinouttimer] = (3*TICRATE/2)+2;
	player.kartflashing = K_GetKartFlashing(player);

-- 	if (player.mo.state != S_KART_SPIN)
-- 		player.mo.state = S_KART_SPIN;
-- 	end

	player.kartstuff[k_instashield] = 15;
-- 	if (cv_kartdebughuddrop.value and not modeattacking)
-- 		K_DropItems(player);
-- 	else
-- 		K_DropHnextList(player);
-- 	end
	return
end
rawset(_G,"K_SpinPlayer",K_SpinPlayer)

--https://git.do.srb2.org/KartKrew/Kart-Public/-/blob/next/src/p_mobj.c#L7960
--https://git.do.srb2.org/KartKrew/Kart-Public/-/blob/next/src/p_mobj.c#L1248
addHook("MobjThinker",function(mo)
	if mo and mo.valid
		local grounded = P_IsObjectOnGround(mo)
		
		if not grounded
			mo.momz = $ - P_GetMobjGravity(mo) + P_GetMobjGravity(mo)*8/5
		end
		if mo.health
			if mo.flags2 & MF2_AMBUSH
				if grounded and (mo.flags & MF_NOCLIPTHING)
					mo.momx,mo.momy = 1,0
					mo.frame = 3
					S_StartSound(mo,mo.info.activesound)
				elseif mo.movecount
					mo.movecount = $-1
				elseif mo.frame < 3
					mo.movecount = 2
					mo.frame = $ + 1
				end
			else
				local finalspeed = mo.movefactor
				P_SpawnGhostMobj(mo)
				
				mo.angle = R_PointToAngle2(0,0,mo.momx,mo.momy)
				if mo.health <= 5
					for i=5,mo.health,-1
						finalspeed = fixmul($,FU-FU/4)
					end
				end
				
				P_InstaThrust(mo,mo.angle,finalspeed)
				if grounded
					--
				end
				
				if mo.threshold
					mo.threshold = $-2
				end
				
				if not (leveltime%6)
					S_StartSound(mo,mo.info.activesound)
				end
			end
		elseif grounded
			P_RemoveMobj(mo)
		end
	end
end,MT_ORBINAUT)

addHook("MobjThinker",function(mo)
	if mo and mo.valid
		mo.friction = ORIG_FRICTION/4
		
		if mo.momx or mo.momy
			P_SpawnGhostMobj(mo)
		end
		
		local grounded = P_IsObjectOnGround(mo)
		
		if not grounded
			mo.momz = $ - P_GetMobjGravity(mo) + P_GetMobjGravity(mo)*8/5
		end
		if mo.health
			if grounded
				if mo.health > 1
					S_StartSound(mo,mo.info.activesound)
					mo.momx,mo.momy = 0,0
					mo.health = 1
				end
			end
			
			if mo.threshold
				mo.threshold = $-2
			end
		elseif grounded
			P_RemoveMobj(mo)
		end
	end
end,MT_BANANA)

addHook("MobjMoveCollide", function(enemy,mo)
	if mo and mo.valid and mo.player and mo.player.kart --runners are spared
	and enemy.z <= mo.z + mo.height and mo.z <= enemy.z + enemy.height
	and not enemy.threshold and enemy.health
		local player = mo.player
		if enemy == mo return end
		local source = enemy.target
		player.kartstuff[k_sneakertimer] = 0;
		K_SpinPlayer(player, source, 1, enemy, false);
		S_StartSound(mo,sfx_s3k7b)
-- 		damage = player.mo.health - 1;
-- 		P_RingDamage(player, inflictor, source, damage);
-- 		P_PlayerRingBurst(player, 5);
		if (P_IsLocalPlayer(player))
			P_StartQuake(32*FU,5)
		end
		P_SetObjectMomZ(enemy,8*FU,false)
		P_InstaThrust(enemy,R_PointToAngle2(0,0,enemy.momx,enemy.momy)+ANGLE_90,16*FU)
		P_KillMobj(enemy)
		enemy.flags = $ & ~MF_NOGRAVITY
	end
end,MT_ORBINAUT)

addHook("MobjMoveCollide", function(enemy,mo)
	if mo and mo.valid and mo.player and mo.player.kart --runners are spared
	and enemy.z <= mo.z + mo.height and mo.z <= enemy.z + enemy.height
	and not enemy.threshold and enemy.health
		local player = mo.player
		if enemy == mo return end
		local source = enemy.target
		P_KillMobj(enemy)
		K_SpinPlayer(player, source, 0, enemy, true);
		enemy.z = $ + enemy.height*P_MobjFlip(enemy)*2
		S_StartSound(enemy,enemy.info.deathsound)
		
		if enemy.health > 1
			S_StartSound(enemy,sfx_bsnipe)
		end
		
		P_SetObjectMomZ(enemy,8*FU,false)
		P_InstaThrust(enemy,R_PointToAngle2(0,0,enemy.momx,enemy.momy)+ANGLE_90,16*FU)
-- 		print(enemy.momz) --why does the banana not get thrusted the first time!??!?!?!?!
	end
end,MT_BANANA)

addHook("MobjThinker",function(mo)
	if mo and mo.valid
		if not mo.target or not mo.target.health
			P_RemoveMobj(mo)
			return
		end
		
		mo.angle = mo.target.angle
		P_MoveOrigin(mo,mo.target.x+P_ReturnThrustX(nil,mo.angle+ANGLE_180,mo.target.radius),mo.target.y+P_ReturnThrustY(nil,mo.angle+ANGLE_180,mo.target.radius),mo.target.z)
		mo.scale = mo.target.scale
		
		local player
		if mo.target.target--[[?!]] and mo.target.target.player
			player = mo.target.target.player
		else
			player = mo.target.player
		end
		
		if player
			if player.kartstuff[k_sneakertimer] > mo.movecount
				mo.state = S_BOOSTFLAME
			end
			mo.movecount = player.kartstuff[k_sneakertimer]
		end
		
		if mo.state == S_BOOSTSMOKESPAWNER
			local smoke = P_SpawnMobj(mo.x, mo.y, mo.z+(8<<FRACBITS), MT_BOOSTSMOKE);
			
			smoke.scale = mo.target.scale/2;
			smoke.destscale = 3*mo.target.scale/2;
			smoke.scalespeed = mo.target.scale/12;
			
			smoke.momx = mo.target.momx/2;
			smoke.momy = mo.target.momy/2;
			smoke.momz = mo.target.momz/2;
			
			P_Thrust(smoke, mo.angle+FixedAngle(P_RandomRange(135, 225)<<FRACBITS), P_RandomRange(0, 8) * mo.target.scale);
		end
	end
end,MT_BOOSTFLAME)

addHook("MobjThinker",function(mo)
	if not mo.target or not mo.target.health or (mo.target.player and (not mo.target.player.kart or not mo.target.player.kartstuff[k_invincibilitytimer]))
		P_RemoveMobj(mo)
		return
	end
	
	mo.scale = mo.target.scale
	P_SetOrigin(mo,mo.target.x,mo.target.y,mo.target.z)
end,MT_INVULNFLASH)