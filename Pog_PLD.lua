-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
	include('Pog-Globals.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff.Sentinel = buffactive.sentinel or false
    state.Buff.Cover = buffactive.cover or false
    state.Buff.Doom = buffactive.Doom or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Sak', 'Sp', 'Hy', 'CP')
    state.HybridMode:options('Normal', 'PDT', 'Reraise')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.PhysicalDefenseMode:options('PDT', 'DT', 'FT', 'SP', 'HP', 'Reraise', 'Charm')
    state.MagicalDefenseMode:options('MDT', 'DT', 'HP', 'Reraise', 'Charm')
    
    state.ExtraDefenseMode = M{['description']='Extra Defense Mode', 'None', 'MP', 'Knockback', 'MP_Knockback'}
    state.EquipShield = M(false, 'Equip Shield w/Defense')

    update_defense_mode()
    
    send_command('bind ^f11 gs c cycle MagicalDefenseMode')
    send_command('bind !f11 gs c cycle ExtraDefenseMode')
    send_command('bind @f10 gs c toggle EquipShield')
    send_command('bind @f11 gs c toggle EquipShield')
	send_command('bind !q input /equip main "Excalibur"; input /equip sub "Blurred Shield +1";')

    select_default_macro_book()
end

function user_unload()
    send_command('unbind ^f11')
    send_command('unbind !f11')
    send_command('unbind @f10')
    send_command('unbind @f11')
	send_command('unbind !q')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast sets
    --------------------------------------
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Invincible'] = {legs="Caballarius Breeches"}
    sets.precast.JA['Holy Circle'] = {feet="Reverence Leggings +1"}
    sets.precast.JA['Shield Bash'] = {ear2="Knightly Earring",hands="Valor Gauntlets +2"}
    sets.precast.JA['Sentinel'] = {feet="Valor Leggings"}
    sets.precast.JA['Rampart'] = {head="Valor Coronet"}
    sets.precast.JA['Fealty'] = {body="Caballarius Surcoat +3"}
    sets.precast.JA['Divine Emblem'] = {feet="Creed Sabatons +2"}
    sets.precast.JA['Cover'] = {head="Reverence Coronet +1"}
    sets.precast.JA['Provoke'] = {
		head="Hero's Galea",
		neck="Invidia Torque",
        body="Creed Cuirass +2",
		hands="Valor Gauntlets +2",
		ring2="Hercules' Ring",
        back="Valor Cape",
		legs="Valor Breeches",
		feet="Creed Sabatons +2"
	}
	
	sets.Ele = {head="Mekira-oto"}

    -- add mnd for Chivalry
    sets.precast.JA['Chivalry'] = {
        head="Reverence Coronet +1",
        body="Reverence Surcoat +1",
		hands="Reverence Gauntlets +1",
		ring1="Leviathan Ring",
		ring2="Aquasoul Ring",
        back="Weard Mantle",
		legs="Reverence Breeches +1",
		feet="Whirlpool Greaves"
	}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
		ammo="Sonia's Plectrum",
        head="Reverence Coronet +1",
        body="Vatic Byrnie",
		hands="Reverence Gauntlets +1",
		ring2="Asklepian Ring",
        back="Iximulew Cape",
		waist="Caudata Belt",
		legs="Reverence Breeches +1",
		feet="Whirlpool Greaves"
	}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
    
    sets.precast.Step = {waist="Chaac Belt"}
    sets.precast.Flourish1 = {waist="Chaac Belt"}

    -- Fast cast sets for spells
    
    sets.precast.FC = {
		ammo="Incantor Stone",
        head="Chevalier's Armet +1",
		neck="Invidia Torque",
		body="Nuevo Coselete",
		ear1="Loquacious Earring",
		ring2="Hercules' Ring",
		waist="Rumination Sash",
		legs="Enif Cosciales",
		feet="Odyssean Greaves"
	}
	
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
	
	--sets.precast.FC['Trust'] = {body="Apururu Unity Shirt"}

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
		ammo="Floestone",
        head="Flamma Zucchetto +2",
		neck=gear.ElementalGorget,
		ear1="Moonshade Earring",
		ear2="Thrud Earring",
        body="Sulevia's Platemail +2",
		hands="Odyssean Gauntlets",
		ring1="Karieyh Ring",
		ring2="Beithir Ring",
        back="Atheling Mantle",
		waist="Fotia Belt",
		--waist=gear.ElementalBelt,
		legs="Sulevia's Cuisses +2",
		feet="Sulevia's Leggings +2"
	}

    sets.precast.WS.Acc = {
		ammo="Ginsen",
        head="Yaoyotl Helm",
		neck=gear.ElementalGorget,
		ear1="Moonshade Earring",
		ear2="Thrud Earring",
        body="Vatic Byrnie",
		hands="Sulevia's Gauntlets +2",
		ring1="Rajas Ring",
		ring2="Patricius Ring",
        back="Atheling Mantle",
		waist="Fotia Belt",
		--waist=gear.ElementalBelt,
		legs="Cizin Breeches",
		feet="Whirlpool Greaves"
	}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {
			ammo="Aqua Sachet",
			--neck=gear.ElementalGorget,
			ring1="Solemn Ring",
			ring2="Sirona's Ring",
			--waist=gear.ElementalBelt
		}
	)
    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS.Acc, {ring1="Leviathan Ring"})

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {ammo="Thunder Sachet",hands="Buremte Gloves",waist="Zoran's Belt"})
    sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS.Acc, {waist="Zoran's Belt"})
	

    sets.precast.WS['Sanguine Blade'] = {
		ammo="Ginsen",
        head="Reverence Coronet +1",
		neck="Eddy Necklace",
		ear1="Friomisi Earring",
		ear2="Hecate's Earring",
        body="Reverence Surcoat +1",
		hands="Reverence Gauntlets +1",
		ring1="Shiva Ring",
		ring2="K'ayres Ring",
        back="Toro Cape",
		waist="Caudata Belt",
		legs="Reverence Breeches +1",
		feet="Reverence Leggings +1"
	}
    
    sets.precast.WS['Atonement'] = {
		ammo="Iron Gobbet",
        head="Reverence Coronet +1",
		neck=gear.ElementalGorget,
		ear1="Creed Earring",
		ear2="Steelflash Earring",
        body="Reverence Surcoat +1",
		hands="Reverence Gauntlets +1",
		ring1="Rajas Ring",
		ring2="Vexer Ring",
        back="Fierabras's Mantle",
		waist="Fotia Belt",
		--waist=gear.ElementalBelt,
		legs="Reverence Breeches +1",
		feet="Caballarius Leggings"
	}
	
	sets.precast.WS['Knights of Round'] = {
		ammo="Floestone",
		head="Flamma Zucchetto +2",
		neck=gear.ElementalGorget,
		ear1="Moonshade Earring",
		ear2="Thrud Earring",
		body="Caballarius Surcoat +3",
		hands="Sulev. Gauntlets +2",
		ring1="Rajas Ring",
		ring2="Karieyh Ring",
		back="Rudianos's Mantle",
		waist="Fotia Belt",
		legs="Sulevia's Cuisses +2",
		feet="Sulevia's Leggings +2"
	}
    
    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {
		ammo="Staunch Tathlum",
		ear2="Knightly Earring",
        head="Reverence Coronet +1",
        body="Reverence Surcoat +1",
		hands="Reverence Gauntlets +1",
        waist="Zoran's Belt",
		legs="Enif Cosciales",
		feet="Odyssean Greaves"
	}
        
    sets.midcast.Enmity = {
		ammo="Charitoni Sling",
		head="Loess Barbuta +1",
		neck="Invidia Torque",
        body="Creed Cuirass +2",
		hands="Valor Gauntlets +2",
		waist="Creed Baudrier",
		ring2="Hercules' Ring",
        back="Valor Cape",
		legs="Valor Breeches",
		feet="Odyssean Greaves"
	}

    sets.midcast.Flash = set_combine(sets.midcast.Enmity, {legs="Enif Cosciales"})
    
    sets.midcast.Stun = sets.midcast.Flash
    
    sets.midcast.Cure = {
		ammo="Iron Gobbet",
        head="Adaman Barbuta",
		neck="Invidia Torque",
		ear1="Hospitaler Earring",
		ear2="Nourishing Earring +1",
        body="Reverence Surcoat +1",
		hands="Buremte Gloves",
		ring1="Kunaji Ring",
		ring2="Sirona's Ring",
        back="Solemnity Cape",
		waist="Chuq'aba Belt",
		legs="Reverence Breeches +1",
		feet="Odyssean Greaves"
	}

    sets.midcast['Enhancing Magic'] = {
		neck="Colossus's Torque",
		waist="Olympus Sash",
		legs="Reverence Breeches +1"
	}
    
    sets.midcast.Protect = {ring1="Sheltered Ring"}
    sets.midcast.Shell = {ring1="Sheltered Ring"}
	--sets.midcast['Trust'] = {body="Apururu Unity Shirt"}
    
    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    sets.Reraise = {head="Twilight Helm", body="Twilight Mail"}
    
    sets.resting = {
		neck="Creed Collar",
        ring1="Sheltered Ring",
		ring2="Paguroidea Ring",
        waist="Austerity Belt"
	}
    

    -- Idle sets
    sets.idle = {
		ammo="Staunch Tathlum",
        head="Loess Barbuta +1",
		neck="Diemer Gorget",
		ear1="Tuisto Earring",
		ear2="Ethereal Earring",
		--body={ name="Nuevo Coselete", augments={'Enmity+5','"Fast Cast"+5',}},
        body="Caballarius Surcoat +3",
		hands="Odyssean Gauntlets",
		ring1="Karieyh Ring",
		ring2="Defending Ring",
        back="Rudianos's Mantle",
		waist="Flume Belt",
		legs="Sulevia's Cuisses +2",
		feet="Odyssean Greaves"
	}

    sets.idle.Town = {
		--main="Anahera Sword",
		ammo="Incantor Stone",
        head="Hero's Galea",
		neck="Creed Collar",
		ear1="Brutal Earring",
		ear2="Creed Earring",
        body="Nuevo Coselete",
		hands="Valor Gauntlets +2",
		ring1="Rajas Ring",
		ring2="Warp Ring",
        back="Atheling Mantle",
		waist="Flume Belt",
		legs="Creed Cuisses +2",
		feet="Jingang Greaves"
	}
    
    sets.idle.Weak = {
		ammo="Iron Gobbet",
		head="Sulevia's Mask +1",
		neck="Twilight Torque",
		ear1="Creed Earring",
		ear2="Ethereal Earring",
		body="Sulevia's Platemail +2",
		hands="Sulevia's Gauntlets +2",
		ring1="Spiral Ring",
		ring2="Sulevia's Ring",
		waist="Flume Belt",
		legs="Sulevia's Cuisses +2",
		feet="Sulevia's Leggings +2"
	}
    
    sets.idle.Weak.Reraise = set_combine(sets.idle.Weak, sets.Reraise)
    
    sets.Kiting = {legs="Crimson Cuisses"}

    sets.latent_refresh = {waist="Fucho-no-obi"}


    --------------------------------------
    -- Defense sets
    --------------------------------------
    
    -- Extra defense sets.  Apply these on top of melee or defense sets.
    sets.Knockback = {back="Repulse Mantle"}
    sets.MP = {neck="Creed Collar",waist="Flume Belt"}
    sets.MP_Knockback = {neck="Creed Collar",waist="Flume Belt",back="Repulse Mantle"}
    
    -- If EquipShield toggle is on (Win+F10 or Win+F11), equip the weapon/shield combos here
    -- when activating or changing defense mode:
    sets.PhysicalShield = {main="Anahera Sword",sub="Killedar Shield"} -- Ochain
    sets.MagicalShield = {main="Anahera Sword",sub="Beatific Shield +1"} -- Aegis

    -- Basic defense sets.
        
    sets.defense.PDT = {
		ammo="Staunch Tathlum",
        head="Chevalier Armet +1",
		neck="Diemer Gorget",
		ear1="Tuisto Earring",
		ear2="Ethereal Earring",
        body="Sulevia's Platemail +2",
		hands="Sulevia's Gauntlets +2",
		ring1="Gelatinous Ring +1",
		--ring2=gear.DarkRing.physical,
		ring2="Warden's Ring",
        back="Rudianos's Mantle",
		waist="Flume Belt",
		legs="Sulevia's Cuisses +2",
		feet="Sulevia's Leggings +2"
	}
    sets.defense.HP = {
		ammo="Iron Gobbet",
        head="Reverence Coronet +1",
		neck="Twilight Torque",
		ear1="Creed Earring",
		ear2="Tuisto Earring",
        body="Reverence Surcoat +1",
		hands="Reverence Gauntlets +1",
		ring1="Meridian Ring",
		ring2="Defending Ring",
        back="Weard Mantle",
		waist="Creed Baudrier",
		legs="Reverence Breeches +1",
		feet="Reverence Leggings +1"
	}
    sets.defense.Reraise = {ammo="Iron Gobbet",
        head="Twilight Helm",neck="Twilight Torque",ear1="Creed Earring",ear2="Bloodgem Earring",
        body="Twilight Mail",hands="Reverence Gauntlets +1",ring1="Defending Ring",ring2=gear.DarkRing.physical,
        back="Weard Mantle",waist="Nierenschutz",legs="Reverence Breeches +1",feet="Reverence Leggings +1"}
    sets.defense.Charm = {ammo="Iron Gobbet",
        head="Reverence Coronet +1",neck="Lavalier +1",ear1="Creed Earring",ear2="Buckler Earring",
        body="Reverence Surcoat +1",hands="Reverence Gauntlets +1",ring1="Defending Ring",ring2=gear.DarkRing.physical,
        back="Shadow Mantle",waist="Flume Belt",legs="Reverence Breeches +1",feet="Reverence Leggings +1"}
    -- To cap MDT with Shell IV (52/256), need 76/256 in gear.
    -- Shellra V can provide 75/256, which would need another 53/256 in gear.
    sets.defense.MDT = {ammo="Demonry Stone",
        head="Reverence Coronet +1",neck="Twilight Torque",ear1="Tuisto Earring",ear2="Ethereal Earring",
        body="Reverence Surcoat +1",hands="Reverence Gauntlets +1",ring1="Defending Ring",ring2="Shadow Ring",
        back="Engulfer Cape",waist="Creed Baudrier",legs="Osmium Cuisses",feet="Reverence Leggings +1"}
	sets.defense.DT = {
		ammo="Staunch Tathlum",
        head="Loess Barbuta +1",
		neck="Diemer Gorget",
		ear1="Tuisto Earring",
		ear2="Ethereal Earring",
        body="Caballarius Surcoat +3",
		hands="Odyssean Gauntlets",
		ring1="Gelatinous Ring +1",
		ring2="Defending Ring",
        back="Rudianos's Mantle",
		waist="Flume Belt",
		legs="Sulevia's Cuisses +2",
		feet="Odyssean Greaves"
	}
	sets.defense.FT = {
		ammo="Staunch Tathlum",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck="Diemer Gorget",
		waist="Flume Belt",
		left_ear="Tuisto Earring",
		right_ear="Ethereal Earring",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+3','"Store TP"+10',}}
	}
	sets.defense.SP = {
	    --main="Sakpata's Sword",
		--sub="Blurred Shield +1",
		ammo="Staunch Tathlum",
		head="Loess Barbuta +1",
		body="Caballarius Surcoat +3",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck="Creed Collar",
		waist="Flume Belt",
		left_ear="Odnowa Earring +1",
		right_ear="Ethereal Earring",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		--back="Solemnity Cape"
		back={ name="Rudianos's Mantle", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+3','"Store TP"+10',}}
	}

    --------------------------------------
    -- Engaged sets
    --------------------------------------
    
    sets.engaged = {
		ammo="Floestone",
        head="Flamma Zucchetto +2",
		--neck="Sanctity Necklace",
		neck="Decimus Torque",
		ear1="Brutal Earring",
		ear2="Thrud Earring",
        body="Vatic Byrnie",
		hands="Sulevia's Gauntlets +2",
		ring1="Vehemence Ring",
		ring2="Sulevia's Ring",
        back="Rudianos's Mantle",
		waist="Cetl Belt",
		legs="Sulevia's Cuisses +2",
		feet="Flamma Gambieras +2"
	}

    sets.engaged.Acc = {
		ammo="Thunder Sachet",
        head="Sulevia's Mask +1",
		neck="Sanctity Necklace",
		ear1="Brutal Earring",
		ear2="Assuage Earring",
        body="Sulevia's Platemail +2",
		hands="Sulevia's Gauntlets +2",
		ring1="Enlivened Ring",
		ring2="Sulevia's Ring",
        back="Rudianos's Mantle",
		waist="Cetl Belt",
		legs="Sulevia's Cuisses +2",
		feet="Sulevia's Leggings +2"
	}
	
	sets.engaged.CP = set_combine(sets.engaged, {
		back="Mecistopins Mantle"
	})
	
	sets.engaged.Hy = {
		ammo="Floestone",
        head="Flamma Zucchetto +2",
		neck="Sanctity Necklace",
		--neck="Decimus Torque",
		ear1="Tuisto Earring",
		ear2="Cassie Earring",
        body="Caballarius Surcoat +3",
		hands="Sulevia's Gauntlets +2",
		ring1="Gelatinous Ring +1",
		ring2="Defending Ring",
        back="Rudianos's Mantle",
		waist="Sailfi Belt +1",
		legs="Sulevia's Cuisses +2",
		feet="Flamma Gambieras +2"
	}

	sets.engaged.Sak = {
	    --main="Sakpata's Sword",
		--sub="Blurred Shield +1",
		ammo="Floestone",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck="Decimus Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Brutal Earring",
		right_ear="Assuage Earring",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+3','"Store TP"+10',}}
	}

	sets.engaged.Sp = {
	    --main="Sakpata's Sword",
		--sub="Blurred Shield +1",
		ammo="Charitoni Sling",
		head="Loess Barbuta +1",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Odnowa Earring +1",
		right_ear="Ethereal Earring",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back="Solemnity Cape"
		--back={ name="Rudianos's Mantle", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+3','"Store TP"+10',}}
	}

    sets.engaged.DW = {
		ammo="Flame Sachet",
        head="Acro Helm",
		neck="Sanctity Necklace",
		ear1="Brutal Earring",
		ear2="Thrud Earring",
        body="Vatic Byrnie",
		hands="Sulevia's Gauntlets +2",
		ring1="Sulevia's Ring",
		ring2="Vehemence Ring",
        back="Rudianos's Mantle",
		waist="Cetl Belt",
		legs="Scuffler's Cosciales",
		feet="Acro Leggings"
	}

    sets.engaged.DW.Acc = {
		ammo="Thunder Sachet",
        head="Yaoyotl Helm",
		neck="Sanctity Necklace",
		ear1="Brutal Earring",
		ear2="Assuage Earring",
        body="Vatic Byrnie",
		hands="Sulevia's Gauntlets +2",
		ring1="Sulevia's Ring",
		ring2="Enlivened Ring",
        back="Weard Mantle",
		waist="Cetl Belt",
		legs="Cizin Breeches",
		feet="Whirlpool Greaves"
	}

	sets.engaged.DW.CP = set_combine(sets.engaged.DW, {
		back="Mecistopins Mantle"
	})

    sets.engaged.PDT = set_combine(sets.engaged, {body="Reverence Surcoat +1",neck="Twilight Torque",ring1="Defending Ring"})
    sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc, {body="Reverence Surcoat +1",neck="Twilight Torque",ring1="Defending Ring"})
    sets.engaged.Reraise = set_combine(sets.engaged, sets.Reraise)
    sets.engaged.Acc.Reraise = set_combine(sets.engaged.Acc, sets.Reraise)

    sets.engaged.DW.PDT = set_combine(sets.engaged.DW, {body="Reverence Surcoat +1",neck="Twilight Torque",ring1="Defending Ring"})
    sets.engaged.DW.Acc.PDT = set_combine(sets.engaged.DW.Acc, {body="Reverence Surcoat +1",neck="Twilight Torque",ring1="Defending Ring"})
    sets.engaged.DW.Reraise = set_combine(sets.engaged.DW, sets.Reraise)
    sets.engaged.DW.Acc.Reraise = set_combine(sets.engaged.DW.Acc, sets.Reraise)


    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.buff.Doom = {ring2="Saida Ring"}
    sets.buff.Cover = {head="Reverence Coronet +1", body="Caballarius Surcoat +3"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_midcast(spell, action, spellMap, eventArgs)
    -- If DefenseMode is active, apply that gear over midcast
    -- choices.  Precast is allowed through for fast cast on
    -- spells, but we want to return to def gear before there's
    -- time for anything to hit us.
    -- Exclude Job Abilities from this restriction, as we probably want
    -- the enhanced effect of whatever item of gear applies to them,
    -- and only one item should be swapped out.
    if state.DefenseMode.value ~= 'None' and spell.type ~= 'JobAbility' then
        handle_equipping_gear(player.status)
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_state_change(field, new_value, old_value)
    classes.CustomDefenseGroups:clear()
    classes.CustomDefenseGroups:append(state.ExtraDefenseMode.current)
    if state.EquipShield.value == true then
        classes.CustomDefenseGroups:append(state.DefenseMode.current .. 'Shield')
    end

    classes.CustomMeleeGroups:clear()
    classes.CustomMeleeGroups:append(state.ExtraDefenseMode.current)
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_defense_mode()
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.Buff.Doom then
        idleSet = set_combine(idleSet, sets.buff.Doom)
    end
    
    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.Buff.Doom then
        meleeSet = set_combine(meleeSet, sets.buff.Doom)
    end
    
    return meleeSet
end

function customize_defense_set(defenseSet)
    if state.ExtraDefenseMode.value ~= 'None' then
        defenseSet = set_combine(defenseSet, sets[state.ExtraDefenseMode.value])
    end
    
    if state.EquipShield.value == true then
        defenseSet = set_combine(defenseSet, sets[state.DefenseMode.current .. 'Shield'])
    end
    
    if state.Buff.Doom then
        defenseSet = set_combine(defenseSet, sets.buff.Doom)
    end
    
    return defenseSet
end


function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end

    if state.ExtraDefenseMode.value ~= 'None' then
        msg = msg .. ', Extra: ' .. state.ExtraDefenseMode.value
    end
    
    if state.EquipShield.value == true then
        msg = msg .. ', Force Equip Shield'
    end
    
    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end

    add_to_chat(122, msg)

    eventArgs.handled = true
end

function job_post_precast(spell, action, spellMap, eventArgs)
    -- Equip Mekira if weather/day matches for WS.
    if spell.type == 'WeaponSkill' then
        if spell.english == 'Requiescat' then
            --if world.weather_element == 'Dark' or world.day_element == 'Dark' or world.weather_element == 'Earth' or world.day_element == 'Earth' then
			if world.day_element == 'Dark' or world.day_element == 'Earth' then
                equip(sets.Ele)
            end
        elseif spell.english == 'Savage Blade' and (world.day_element == 'Wind' or world.day_element == 'Lightning' or world.day_element == 'Earth') then
            equip(sets.Ele)
        end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_defense_mode()
    if player.equipment.main == 'Kheshig Blade' and not classes.CustomDefenseGroups:contains('Kheshig Blade') then
        classes.CustomDefenseGroups:append('Kheshig Blade')
    end
	
    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        if player.equipment.sub and not player.equipment.sub:contains('Shield') and
           player.equipment.sub ~= 'Aegis' and player.equipment.sub ~= 'Ochain' then
            state.CombatForm:set('DW')
        else
            state.CombatForm:reset()
        end
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(5, 2)
    elseif player.sub_job == 'NIN' then
        set_macro_page(4, 2)
    elseif player.sub_job == 'RDM' then
        set_macro_page(3, 2)
	elseif player.sub_job == 'BLU' then
		set_macro_page(6, 2)
	elseif player.sub_job == 'WAR' then
		set_macro_page(7, 2)
	elseif player.sub_job == 'WHM' then
		set_macro_page(8, 2)
	elseif player.sub_job == 'DRK' then
		set_macro_page(9, 2)
	elseif player.sub_job == 'RUN' then
		set_macro_page(1, 2)
    else
        set_macro_page(2, 2)
    end
end

