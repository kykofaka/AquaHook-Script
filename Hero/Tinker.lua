local RastaTinker = {}
local myHero, myPlayer, myTeam, myMana, myFaction, attackRange, myPos, myBase, enemyBase, enemyPosition
local enemy
local comboHero
local q,w,e,r,f
local nextTick = 0
local nextTick2 = 0
local needTime = 0
local needTime2 = 0
local needAttack
local added = false
local ebladeCasted = {}
local RearmChannelTime = {}
RearmChannelTime[1] = 3.00
RearmChannelTime[2] = 1.5
RearmChannelTime[3] = 0.75
local clone, clone_q, clone_w, clone_e, clone_mana, clone_state, clone_target, thinker
local clone_hex, clone_orchid, clone_blood, clone_nullifier, clone_silver, clone_mjolnir, clone_manta, clone_midas, clone_bkb, clone_diffusal, clone_satanic, clone_boots, clone_necro, clone_mom
local x,y
--items
local urn, soulring, vessel, hex, halberd, mjolnir, bkb, nullifier, solar, courage, force, pike, eul, orchid, Glimmer, diffusal, armlet, lotus, satanic, blademail, blink, abyssal, eblade, phase, discord, shiva, refresher, manta, silver, midas, necro, silver, branch, mom, arcane
local time = 0
local cachedHeroIcons = {}
local cachedItemIcons = {}
RastaTinker.optionTinkerEnable = Menu.AddOptionBool({"Hero Specific", "Tinker"}, "Enable", false)
Menu.AddMenuIcon({"Hero Specific", "Tinker"}, "panorama/images/heroes/icons/npc_dota_hero_tinker_png.vtex_c")
RastaTinker.optionTinkerComboKey = Menu.AddKeyOption({"Hero Specific", "Tinker"}, "Combo Key", Enum.ButtonCode.KEY_Z)
RastaTinker.optionTinkerSpamKey = Menu.AddKeyOption({"Hero Specific", "Tinker"}, "Spam Rockets Key", Enum.ButtonCode.KEY_F)
RastaTinker.optionTinkerFailSwitch = Menu.AddOptionBool({"Hero Specific", "Tinker"}, "Rocket and Rearm failswitch", true)
RastaTinker.optionTinkerSoulRearm = Menu.AddOptionBool({"Hero Specific", "Tinker"}, "Auto use soulring before rearm", true)
RastaTinker.optionTinkerPoopLaser = Menu.AddOptionBool({"Hero Specific", "Tinker"}, "Poop Linken with Laser", false)
RastaTinker.optionTinkerTargetStyle = Menu.AddOptionCombo({"Hero Specific", "Tinker"}, "Target Style", {"Free Target", "Lock Target"}, 1)
RastaTinker.optionTinkerCheckBM = Menu.AddOptionBool({"Hero Specific", "Tinker"}, "Check BM/Lotus", true)
RastaTinker.optionTinkerEnableLaser = Menu.AddOptionBool({"Hero Specific", "Tinker","Skills"}, "Laser", true)
RastaTinker.optionTinkerEnableRockets = Menu.AddOptionBool({"Hero Specific", "Tinker","Skills"}, "Heat-Seeking Missle", true)
RastaTinker.optionTinkerEnableRearm = Menu.AddOptionBool({"Hero Specific", "Tinker", "Skills"}, "Rearm", true)
RastaTinker.optionTinkerEnableBkb = Menu.AddOptionBool({"Hero Specific", "Tinker", "Items"}, "Black King Bar", false)
RastaTinker.optionTinkerEnableBlink = Menu.AddOptionBool({"Hero Specific", "Tinker", "Items"}, "Blink Dagger", false)
RastaTinker.optionTinkerBlinkSafeRange = Menu.AddOptionSlider({"Hero Specific", "Tinker", "Items"}, "Safe Radius for Blink", 0, 800, 400)
RastaTinker.optionTinkerBlinkStyle = Menu.AddOptionCombo({"Hero Specific", "Tinker", "Items"}, "Blink Style", {"Auto Blink Safe Pozition", "Cursor Position"}, 0)
RastaTinker.optionTinkerEnableBlood = Menu.AddOptionBool({"Hero Specific", "Tinker", "Items"}, "Glimmer", false)
RastaTinker.optionTinkerEnableDagon = Menu.AddOptionBool({"Hero Specific", "Tinker", "Items"}, "Dagon", false)
RastaTinker.optionTinkerEnableEblade = Menu.AddOptionBool({"Hero Specific", "Tinker", "Items"}, "Ethereal Blade", false)
RastaTinker.optionTinkerEnableLotus = Menu.AddOptionBool({"Hero Specific", "Tinker", "Items"}, "Lotus Orb", false)
RastaTinker.optionTinkerEnableOrchid = Menu.AddOptionBool({"Hero Specific", "Tinker", "Items"}, "Orchid", false)
RastaTinker.optionTinkerEnableHex = Menu.AddOptionBool({"Hero Specific", "Tinker", "Items"}, "Scythe of Vyse", false)
RastaTinker.optionTinkerEnableShiva = Menu.AddOptionBool({"Hero Specific", "Tinker", "Items"}, "Shiva's Guard", false)
RastaTinker.optionTinkerEnableSoul = Menu.AddOptionBool({"Hero Specific", "Tinker", "Items"}, "Soul Ring", false)
RastaTinker.optionTinkerThreshold = Menu.AddOptionSlider({"Hero Specific", "Tinker", "Items"}, "HP Percent Threshold for use soulring", 0, 99, 10)
RastaTinker.optionTinkerEnableDiscord = Menu.AddOptionBool({"Hero Specific", "Tinker", "Items"}, "Veil of Discord", false)
RastaTinker.optionEnablePoopLinken = Menu.AddOptionBool({"Hero Specific", "Tinker", "Poop Linken"}, "Enable", false)
RastaTinker.optionEnablePoopAbyssal = Menu.AddOptionBool({"Hero Specific", "Tinker", "Poop Linken"}, "Abyssal Blade", false)
RastaTinker.optionEnablePoopBlood = Menu.AddOptionBool({"Hero Specific", "Tinker", "Poop Linken"}, "Glimmer", false)
RastaTinker.optionEnablePoopDagon = Menu.AddOptionBool({"Hero Specific", "Tinker", "Poop Linken"}, "Dagon", false)
RastaTinker.optionEnablePoopDiffusal = Menu.AddOptionBool({"Hero Specific", "Tinker", "Poop Linken"}, "Diffusal Blade", false)
RastaTinker.optionEnablePoopEul = Menu.AddOptionBool({"Hero Specific", "Tinker", "Poop Linken"}, "Eul", false)
RastaTinker.optionEnablePoopForce = Menu.AddOptionBool({"Hero Specific", "Tinker", "Poop Linken"}, "Force Staff", false)
RastaTinker.optionEnablePoopHalberd = Menu.AddOptionBool({"Hero Specific", "Tinker", "Poop Linken"}, "Heavens Halberd", false)
RastaTinker.optionEnablePoopHex = Menu.AddOptionBool({"Hero Specific", "Tinker", "Poop Linken"}, "Hex", false)
RastaTinker.optionEnablePoopPike = Menu.AddOptionBool({"Hero Specific", "Tinker", "Poop Linken"}, "Hurricane Pike", false)
RastaTinker.optionEnablePoopOrchid = Menu.AddOptionBool({"Hero Specific", "Tinker", "Poop Linken"}, "Orchid", false)



function RastaTinker.Init( ... )
	myHero = Heroes.GetLocal()
	nextTick = 0
	nextTick2 = 0
	needTime = 0
	needTime2 = 0
	time = 0
	added = false
	if not myHero then return end
	if NPC.GetUnitName(myHero) == "npc_dota_hero_tinker" then
		comboHero = "Tinker"
		q = NPC.GetAbilityByIndex(myHero, 0)
		w = NPC.GetAbilityByIndex(myHero, 1)
		r = NPC.GetAbility(myHero, "tinker_rearm")
			else	
		myHero = nil
		return	
	end
	myTeam = Entity.GetTeamNum(myHero)
	if myTeam == 2 then -- radiant
		myBase = Vector(-7328.000000, -6816.000000, 512.000000)
		enemyBase = Vector(7141.750000, 6666.125000, 512.000000)
		myFaction = "radiant"
	else
		myBase = Vector(7141.750000, 6666.125000, 512.000000)
		enemyBase = Vector(-7328.000000, -6816.000000, 512.000000)
		myFaction = "dire"
	end
	myPlayer = Players.GetLocal()
end


function RastaTinker.OnGameStart( ... )
	RastaTinker.Init()
end

function RastaTinker.ClearVar( ... )
	urn = nil
	vessel = nil 
	hex = nil
	halberd = nil 
	mjolnir = nil
	bkb = nil
	nullifier = nil 
	solar = nil 
	courage = nil 
	force = nil
	pike = nil
	eul = nil
	orchid = nil
	Glimmer = nil
	diffusal = nil
	armlet = nil 
	lotus = nil 
	satanic = nil 
	blademail = nil
	blink = nil
	abyssal = nil
	discrd = nil
	phase = nil
	dagon = nil
	eblade = nil
	shiva = nil
	refresher = nil
	soulring = nil
	necro = nil
	manta = nil
	silver = nil
	branch = nil
	arcane = nil
	mom = nil
end

function RastaTinker.OnUpdate( ... )
	if not myHero then return end
	myMana = NPC.GetMana(myHero)
	time = GameRules.GetGameTime()
	myPos = Entity.GetAbsOrigin(myHero)
		if comboHero == "Tinker" and Menu.IsEnabled(RastaTinker.optionTinkerEnable) then
		if Menu.IsKeyDown(RastaTinker.optionTinkerComboKey) then
			if Menu.GetValue(RastaTinker.optionTinkerTargetStyle) == 1 and not enemy then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			elseif Menu.GetValue(RastaTinker.optionTinkerTargetStyle) == 0 then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			end
			if enemy and Entity.IsAlive(enemy) then
				enemyPosition = Entity.GetAbsOrigin(enemy)
				RastaTinker.TinkerCombo()
			end
		else
			enemy = nil		
		end
	end
		if Menu.IsKeyDown(RastaTinker.optionTinkerSpamKey) then
			RastaTinker.TinkerSpamRockets()
		end
		RastaTinker.ClearVar()
	for i = 0, 5 do
		item = NPC.GetItemByIndex(myHero, i)
		if item and item ~= 0 then
			local name = Ability.GetName(item)
			if name == "item_urn_of_shadows" then
				urn = item
			elseif name == "item_spirit_vessel" then
				vessel = item
			elseif name == "item_sheepstick" then
				hex = item
			elseif name == "item_nullifier" then
				nullifier = item
			elseif name == "item_diffusal_blade" then
				diffusal = item
			elseif name == "item_mjollnir" then
				mjolnir = item
			elseif name == "item_heavens_halberd" then
				halberd = item
			elseif name == "item_abyssal_blade" then
				abyssal = item
			elseif name == "item_armlet" then
				armlet = item
			elseif name == "item_glimmer_cape" then
				Glimmer = item
			elseif name == "item_black_king_bar" then
				bkb = item
			elseif name == "item_medallion_of_courage" then
				courage = item
			elseif name == "item_solar_crest" then
				solar = item
			elseif name == "item_blink" then
				blink = item
			elseif name == "item_blade_mail" then
				blademail = item
			elseif name == "item_orchid" then
				orchid = item
			elseif name == "item_lotus_orb" then
				lotus = item
			elseif name == "item_cyclone" then
				eul = item
			elseif name == "item_satanic" then
				satanic = item
			elseif name == "item_force_staff" then
				force = item
			elseif name == "item_hurricane_pike" then
				pike = item 
			elseif name == "item_ethereal_blade" then
				eblade = item
			elseif name == "item_phase_boots" then
				phase = item
			elseif name == "item_dagon" or name == "item_dagon_2" or name == "item_dagon_3" or name == "item_dagon_4" or name == "item_dagon_5" then
				dagon = item
			elseif name == "item_veil_of_discord" then
				discord = item
			elseif name == "item_shivas_guard" then
				shiva = item
			elseif name == "item_refresher" then
				refresher = item
			elseif name == "item_soul_ring"	then
				soulring = item
			elseif name == "item_manta" then
				manta = item
			elseif name == "item_necronomicon" or name == "item_necronomicon_2" or name == "item_necronomicon_3" then
				necro = item
			elseif name == "item_silver_edge" then
				silver = item
			elseif name == "item_branches" then
				branch = item
			elseif name == "item_mask_of_madness" then
				mom = item
			elseif name == "item_arcane_boots" then
				arcane = item	
			end
		end
	end
end

function RastaTinker.TinkerSpamRockets( ... )
	local tempTable = Entity.GetHeroesInRadius(myHero, Ability.GetCastRange(w), Enum.TeamType.TEAM_ENEMY)
	local bool = false
	if tempTable then
		for i, k in pairs(tempTable) do
			if not NPC.HasState(k, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) and not NPC.HasState(k, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
				bool = true
				break
			end
		end
	end
	if bool and not Ability.IsChannelling(r) then
		if soulring and Ability.IsCastable(soulring, 0) and Entity.GetHealth(myHero)/Entity.GetMaxHealth(myHero)*100 > Menu.GetValue(RastaTinker.optionTinkerThreshold) then
			Ability.CastNoTarget(soulring)
			return
		end
		if Ability.IsCastable(w,myMana) then
			Ability.CastNoTarget(w)
			return
		end
		if Ability.IsCastable(r, myMana) and time >= nextTick then
			Ability.CastNoTarget(r)
			nextTick = time + (RearmChannelTime[Ability.GetLevel(r)] + Ability.GetCastPoint(r) + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING))/2
			return
		end
	end
end
function RastaTinker.TinkerNeedRearm( ... )
	local bool = true
	if hex and Menu.IsEnabled(RastaTinker.optionTinkerEnableHex) and Ability.IsCastable(hex, myMana) then
		bool = false
	end
	if discord and Menu.IsEnabled(RastaTinker.optionTinkerEnableDiscord) and Ability.IsCastable(discord, myMana) then
		bool = false
	end
	if eblade and Menu.IsEnabled(RastaTinker.optionTinkerEnableEblade) and Ability.IsCastable(eblade, myMana) then
		bool = false
	end
	if bkb and Menu.IsEnabled(GetAvgLatency.optionTinkerEnableBkb) and Ability.IsCastable(bkb, 0) then
		bool = false
	end
	if lotus and Menu.IsEnabled(RastaTinker.optionTinkerEnableLotus) and Ability.IsCastable(lotus, myMana) then
		bool = false
	end
	if orchid and Menu.IsEnabled(RastaTinker.optionTinkerEnableOrchid) and Ability.IsCastable(orchid, myMana) then
		bool = false
	end
	if Glimmer and Menu.IsEnabled(RastaTinker.optionTinkerEnableBlood) and Ability.IsCastable(Glimmer, myMana) then
		bool = false
	end
	if shiva and Menu.IsEnabled(RastaTinker.optionTinkerEnableShiva) and Ability.IsCastable(shiva, myMana) then
		bool = false
	end
	if w and Menu.IsEnabled(RastaTinker.optionTinkerEnableRockets) and Ability.IsCastable(w, myMana) then
		bool = false
	end
	if q and Menu.IsEnabled(RastaTinker.optionTinkerEnableLaser) and Ability.IsCastable(q, myMana) then
		bool = false
	end
	return bool
end
function RastaTinker.TinkerCombo( ... )
	if not enemy or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		enemy = nil
		return
	end
	if Menu.IsEnabled(RastaTinker.optionTinkerCheckBM) and (NPC.HasModifier(enemy, "modifier_item_blade_mail_reflect") or NPC.HasModifier(enemy, "modifier_item_lotus_orb_active")) then
		return
	end
	if not Ability.IsChannelling(r) then
		if soulring and Menu.IsEnabled(RastaTinker.optionTinkerEnableSoul) and Ability.IsCastable(soulring, 0) and NPC.IsEntityInRange(myHero, enemy, 1050) and Entity.GetHealth(myHero)/Entity.GetMaxHealth(myHero)*100 > Menu.GetValue(RastaTinker.optionTinkerThreshold) then
			Ability.CastNoTarget(soulring)
			return
		end
		if time < needTime then
			return
		end
		if blink and Menu.IsEnabled(RastaTinker.optionTinkerEnableBlink) and Ability.IsCastable(blink, 0) and not NPC.IsEntityInRange(myHero, enemy, 801) and NPC.IsPositionInRange(myHero, enemyPosition + (myPos - enemyPosition):Normalized():Scaled(Menu.GetValue(RastaTinker.optionTinkerBlinkSafeRange)), 1199) then
			if Menu.GetValue(RastaTinker.optionTinkerBlinkStyle) == 0 then
				Ability.CastPosition(blink, enemyPosition + (myPos - enemyPosition):Normalized():Scaled(Menu.GetValue(RastaTinker.optionTinkerBlinkSafeRange)))
			else
				Ability.CastPosition(blink, Input.GetWorldCursorPos())
			end
			return
		end
		if RastaTinker.IsLinkensProtected(enemy) then
			if Menu.IsEnabled(RastaTinker.optionTinkerPoopLaser) and Ability.IsCastable(q, myMana) then
				Ability.CastTarget(q,enemy)
				return
			elseif Menu.IsEnabled(RastaTinker.optionEnablePoopLinken) then
				RastaTinker.PoopLinken()
				needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			end
		end
		if hex and Menu.IsEnabled(RastaTinker.optionTinkerEnableHex) and Ability.IsCastable(hex, myMana) and not NPC.HasModifier(enemy, "modifier_sheepstick_debuff") or NPC.HasModifier(enemy, "modifier_sheepstick_debuff") and Modifier.GetDieTime(NPC.GetModifier(enemy, "modifier_sheepstick_debuff")) - time <= RearmChannelTime[Ability.GetLevel(r)] + Ability.GetCastPoint(r) + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)*2 then
			Ability.CastTarget(hex, enemy)
			return
		end
		if discord and Menu.IsEnabled(RastaTinker.optionTinkerEnableDiscord) and Ability.IsCastable(discord, myMana) and not NPC.HasModifier(enemy, "modifier_item_veil_of_discord_debuff") or NPC.HasModifier(enemy, "modifier_item_veil_of_discord_debuff") and Modifier.GetDieTime(NPC.GetModifier(enemy, "modifier_item_veil_of_discord_debuff")) - time <= RearmChannelTime[Ability.GetLevel(r)] + Ability.GetCastPoint(r) + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)*2 then
			Ability.CastPosition(discord, enemyPosition)
			return
		end
		if eblade and Menu.IsEnabled(RastaTinker.optionTinkerEnableEblade) and Ability.IsCastable(eblade, myMana) and not NPC.HasModifier(enemy, "modifier_item_ethereal_blade_ethereal") or NPC.HasModifier(enemy, "modifier_item_ethereal_blade_ethereal") and Modifier.GetDieTime(NPC.GetModifier(enemy, "modifier_item_ethereal_blade_ethereal")) - time <= RearmChannelTime[Ability.GetLevel(r)] + Ability.GetCastPoint(r) + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)*2 then
			Ability.CastTarget(eblade, enemy)
			ebladeCasted[enemy] = true
			return
		end
		if bkb and Menu.IsEnabled(RastaTinker.optionTinkerEnableBkb) and Ability.IsCastable(bkb, 0) and NPC.IsEntityInRange(myHero, enemy, 1050) and not NPC.HasModifier(myHero, "modifier_black_king_bar_immune") or NPC.HasModifier(myHero, "modifier_black_king_bar_immune") and Modifier.GetDieTime(NPC.GetModifier(myHero, "modifier_black_king_bar_immune")) - time <= RearmChannelTime[Ability.GetLevel(r)] + Ability.GetCastPoint(r) + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)*2 then
			Ability.CastNoTarget(bkb)
			return
		end
		if lotus and Menu.IsEnabled(RastaTinker.optionTinkerEnableLotus) and Ability.IsCastable(lotus, myMana) and NPC.IsEntityInRange(myHero, enemy, 1050) and not NPC.HasModifier(myHero, "modifier_item_lotus_orb_active") or NPC.HasModifier(myHero, "modifier_item_lotus_orb_active") and Modifier.GetDieTime(NPC.GetModifier(myHero, "modifier_item_lotus_orb_active")) - time <= RearmChannelTime[Ability.GetLevel(r)] + Ability.GetCastPoint(r) + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)*2 then
			Ability.CastTarget(lotus, myHero)
			return
		end
		if orchid and Menu.IsEnabled(RastaTinker.optionTinkerEnableOrchid) and Ability.IsCastable(orchid, myMana) then
			Ability.CastTarget(orchid, enemy)
			return
		end
		if Glimmer and Menu.IsEnabled(RastaTinker.optionTinkerEnableBlood) and Ability.IsCastable(Glimmer, myMana) then
			Ability.CastTarget(Glimmer, myHero)
			return
		end
		if shiva and Menu.IsEnabled(RastaTinker.optionTinkerEnableShiva) and Ability.IsCastable(shiva, myMana) and NPC.IsEntityInRange(myHero, enemy, 800) then
			Ability.CastNoTarget(shiva)
			return
		end
		if Ability.IsCastable(w, myMana) and NPC.IsEntityInRange(myHero, enemy, Ability.GetCastRange(w)) and Menu.IsEnabled(RastaTinker.optionTinkerEnableRockets) then
			Ability.CastNoTarget(w)
			return
		end
		if Ability.IsCastable(q, myMana) and Menu.IsEnabled(RastaTinker.optionTinkerEnableLaser) then
			Ability.CastTarget(q, enemy)
			return
		end
		if dagon and Menu.IsEnabled(RastaTinker.optionTinkerEnableDagon) and Ability.IsCastable(dagon, myMana) then
			if ebladeCasted[enemy] and Ability.SecondsSinceLastUse(eblade) < 3 then
				if NPC.HasModifier(enemy, "modifier_item_ethereal_blade_ethereal") then
					Ability.CastTarget(dagon, enemy)
					ebladeCasted[enemy] = nil
					return
				end	
			else
				Ability.CastTarget(dagon, enemy)
				ebladeCasted[enemy] = nil
				return
			end
		end
		if Ability.IsCastable(r, myMana) and time >= nextTick and Menu.IsEnabled(RastaTinker.optionTinkerEnableRearm) then
			if RastaTinker.TinkerNeedRearm() then
				Ability.CastNoTarget(r)
				nextTick = time + (RearmChannelTime[Ability.GetLevel(r)] + Ability.GetCastPoint(r) + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING))/2
				return
			end
		end
	end
end

function RastaTinker.FindBestOrderPosition(tempTable, radius)
	if not tempTable then
		return
	end
	local enemyCount = #tempTable
	if enemyCount == 1 then
		return Entity.GetAbsOrigin(tempTable[1])
	end
	local count = 0
	local coord = {}
	for i, k in pairs(tempTable) do
		if NPC.IsEntityInRange(k, tempTable[1], radius) then
			local origin = Entity.GetAbsOrigin(k)
			local originX = origin:GetX()
			local originY = origin:GetY()
			table.insert(coord, {x = originX, y = originY})
			count = count + 1
		end
	end 
	local x = 0
	local y = 0
	for i = 1, count do
		x = x + coord[i].x
		y = y + coord[i].y
	end
	x = x/count
	y = y/count
	return Vector(x,y,0)
end


function RastaTinker.castPrediction(enemy,adjVar, keyValue)
	local enemyRotation = Entity.GetRotation(enemy):GetVectors()
	enemyRotation:SetZ(0)
	local enemyOrigin = Entity.GetAbsOrigin(enemy)
	enemyOrigin:SetZ(0)
	if enemyRotation and enemyOrigin then
		if not NPC.IsRunning(enemy) then
			return enemyOrigin
		else
			if keyValue == 1 then --lion
				enemyRotation = Entity.GetRotation(enemy)
				local enemyPos = enemyOrigin+enemyRotation:GetForward():Normalized():Scaled(RastaTinker.GetMoveSpeed(enemy)*adjVar)
				if NPC.IsPositionInRange(myHero, enemyPos, 600) then
					return enemyOrigin
				else
					return enemyOrigin+enemyRotation:GetVectors():Scaled(RastaTinker.GetMoveSpeed(enemy))	
				end
			else
				return enemyOrigin:__add(enemyRotation:Normalized():Scaled(RastaTinker.GetMoveSpeed(enemy) * adjVar))
			end
		end
	end
end


function RastaTinker.IsLinkensProtected(npc)
	if NPC.IsLinkensProtected(npc) then
		return true
	end
	if NPC.GetUnitName(npc) == "npc_dota_hero_antimage" then
		if (NPC.HasItem(npc, "item_ultimate_scepter") or NPC.HasModifier(npc, "modifier_item_ultimate_scepter_consumed")) and Ability.IsReady(NPC.GetAbility(npc, "antimage_spell_shield")) and not NPC.HasModifierState(npc, Enum.ModifierState.MODIFIER_STATE_PASSIVES_DISABLED) then
			return true
		end
	end
	return false
end


function RastaTinker.PoopLinken(exception)
	if abyssal and Menu.IsEnabled(RastaTinker.optionEnablePoopAbyssal) and Ability.IsCastable(abyssal, myMana) then
		Ability.CastTarget(abyssal, enemy)
		return
	end
	if Glimmer and Menu.IsEnabled(RastaTinker.optionEnablePoopBlood) and Ability.IsCastable(Glimmer, myMana) then
		Ability.CastTarget(Glimmer, enemy)
		return
	end
	if dagon and Menu.IsEnabled(RastaTinker.optionEnablePoopDagon) and Ability.IsCastable(dagon, myMana) then
		Ability.CastTarget(dagon, enemy)
		return
	end
	if diffusal and Menu.IsEnabled(RastaTinker.optionEnablePoopDiffusal) and Ability.IsCastable(diffusal, 0) then
		Ability.CastTarget(diffusal, enemy)
		return
	end
	if eul and Menu.IsEnabled(RastaTinker.optionEnablePoopEul) and Ability.IsCastable(eul, myMana) and eul ~= exception then
		Ability.CastTarget(eul, enemy)
		return
	end
	if force and Menu.IsEnabled(RastaTinker.optionEnablePoopForce) and Ability.IsCastable(force, myMana) then
		Ability.CastTarget(force, enemy)
		return
	end
	if halberd and Menu.IsEnabled(RastaTinker.optionEnablePoopHalberd) and Ability.IsCastable(halberd, myMana) then
		Ability.CastTarget(halberd, enemy)
		return
	end
	if hex and Menu.IsEnabled(RastaTinker.optionEnablePoopHex) and Ability.IsCastable(hex, myMana) then
		Ability.CastTarget(hex, enemy)
		return
	end
	if pike and Menu.IsEnabled(RastaTinker.optionEnablePoopPike) and Ability.IsCastable(pike, myMana) then
		Ability.CastTarget(pike, enemy)
		return
	end
	if orchid and Menu.IsEnabled(RastaTinker.optionEnablePoopOrchid) and Ability.IsCastable(orchid, myMana) then
		Ability.CastTarget(orchid, enemy)
		return
	end
end


function RastaTinker.OnPrepareUnitOrders(order)
	if not myHero or comboHero ~= "Tinker" then
		return
	end
	if not order or not order.ability or order.order ~= 8 then
		return
	end
	if Ability.GetName(order.ability) == "tinker_heat_seeking_missile" and Menu.IsEnabled(RastaTinker.optionTinkerFailSwitch) then
		if not Entity.GetHeroesInRadius(myHero, 2500, Enum.TeamType.TEAM_ENEMY) then
			return false
		end
	end
	if Ability.GetName(order.ability) == "tinker_rearm" then
		local bool = false
		for i = 0, 8 do
			local item = NPC.GetItemByIndex(myHero, i)
			if item and item ~= 0 and not Ability.IsReady(item) then
				bool = true
				break
			end
		end
		if not bool then
			for i = 0, 5 do
				local ability = NPC.GetAbilityByIndex(myHero, i)
				if ability and not Ability.IsHidden(ability) and not Ability.IsReady(ability) then
					bool = true
					break
				end
			end
		end
		if Menu.IsEnabled(RastaTinker.optionTinkerFailSwitch) and not bool then
			return false
		end
		if soulring and Ability.IsCastable(soulring, 0) and Menu.IsEnabled(RastaTinker.optionTinkerSoulRearm) then
			Ability.CastNoTarget(soulring)
		end
	end
end


function RastaTinker.AbilityIsCastable(ability, myMana)
	if not Entity.IsAlive(myHero) then return false end
	if myMana >= Ability.GetManaCost(ability) and Ability.IsReady(ability) then
		if not NPC.IsSilenced(myHero) and not NPC.IsStunned(myHero) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_HEXED) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
			return true
		end
	end
	return false
end


function RastaTinker.ItemIsCastable(ability, myMana)
	if not Entity.IsAlive(myHero) then return false end
	if myMana >= Ability.GetManaCost(ability) and Ability.IsReady(ability) then
		if not NPC.IsStunned(myHero) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_HEXED) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) and not NPC.HasModifier(myHero, "modifier_doom_bringer_doom") and not NPC.HasModifier(myHero, "modifier_item_nullifier_mute") then
			return true
		end
	end
	return false
end


RastaTinker.Init()
return RastaTinker