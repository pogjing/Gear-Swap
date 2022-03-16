-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
	include('Runera-Globals.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff.Hasso = buffactive.Hasso or false
    state.Buff.Seigan = buffactive.Seigan or false
    state.Buff.Sekkanoki = buffactive.Sekkanoki or false
    state.Buff.Sengikori = buffactive.Sengikori or false
    state.Buff['Meikyo Shisui'] = buffactive['Meikyo Shisui'] or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Mpaca', 'STP')
    state.HybridMode:options('Normal', 'PDT', 'Reraise')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
    state.PhysicalDefenseMode:options('PDT', 'Reraise')

    update_combat_form()
    
    -- Additional local binds
    send_command('bind ^` input /ja "Hasso" <me>')
    send_command('bind !` input /ja "Seigan" <me>')
	send_command('bind !q input /equip main "Masamune"; input /equip sub "Duplus Grip";')
	send_command('bind !o input /ja "Sekkanoki" <me>; wait 3; input /ws "Tachi: Shoha" <t>; wait 4; input /ja "Meditate" <me>; wait 4; input /ws "Tachi: Kasha" <t>; wait 3; input /ja "Hagakure" <me>; wait 3; input /ws "Tachi: Fudo" <t>;')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !-')
	send_command('unbind !q')
	send_command('unbind !o')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA.Meditate = {head="Wakido Kabuto +2",hands="Sao. Kote +2",back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}}
    sets.precast.JA['Warding Circle'] = {head="Wakido Kabuto +2"}
    sets.precast.JA['Blade Bash'] = {hands="Sao. Kote +2"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Yaoyotl Helm",
        body="Otronif Harness +1",hands="Buremte Gloves",ring1="Spiral Ring",
        back="Iximulew Cape",waist="Caudata Belt",legs="Karieyh Brayettes +1",feet="Otronif Boots +1"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
		ammo="Knobkierrie",
        --head="Flamma Zucchetto +2",
		head="Mpaca's Cap",
		neck="Samurai's Nodowa +2",
		ear1="Moonshade Earring",
		ear2="Thrud Earring",
        body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
		hands="Valorous Mitts",
		ring1="Niqmaddu Ring",
		ring2="Epaminondas's Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
		waist="Sailfi Belt +1",
		legs="Wakido Haidate +3",
		feet="Flamma Gambieras +2"
	}
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {back="Letalis Mantle"})
	
	sets.precast.WS.Mod = set_combine(sets.precast.WS, {
			ammo="Knobkierrie",
			head="Flamma Zucchetto +2",
			neck="Samurai's Nodowa +2",
			ear1="Ishvara Earring",
			ear2="Thrud Earring",
			body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
			hands="Valorous Mitts",
			ring1="Flamma Ring",
			ring2="Epaminondas's Ring",
			back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
			waist="Sailfi Belt +1",
			legs="Wakido Haidate +3",
			feet="Flamma Gambieras +2"
		}
	)

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
--[[
	sets.precast.WS['Tachi: Fudo'] = set_combine(sets.precast.WS, {neck=gear.ElementalGorget,waist=gear.ElementalBelt})
    sets.precast.WS['Tachi: Fudo'].Acc = set_combine(sets.precast.WS.Acc, {neck="Snow Gorget",waist="Snow Belt"})--]]
    --sets.precast.WS['Tachi: Fudo'].Mod = set_combine(sets.precast.WS['Tachi: Fudo'], {waist="Snow Belt"})

    sets.precast.WS['Tachi: Shoha'] = set_combine(sets.precast.WS, {ring1="Niqmaddu Ring"})--{neck=gear.ElementalGorget,waist=gear.ElementalBelt})
--[[    sets.precast.WS['Tachi: Shoha'].Acc = set_combine(sets.precast.WS.Acc, {neck="Thunder Gorget",waist="Thunder Belt"})
    sets.precast.WS['Tachi: Shoha'].Mod = set_combine(sets.precast.WS['Tachi: Shoha'], {waist="Thunder Belt"})

    sets.precast.WS['Tachi: Rana'] = set_combine(sets.precast.WS, {neck=gear.ElementalGorget,waist=gear.ElementalBelt,ear1="Bladeborn Earring",ear2="Steelflash Earring",})
    sets.precast.WS['Tachi: Rana'].Acc = set_combine(sets.precast.WS.Acc, {neck="Snow Gorget",ear1="Bladeborn Earring",ear2="Steelflash Earring",})
    sets.precast.WS['Tachi: Rana'].Mod = set_combine(sets.precast.WS['Tachi: Rana'], {waist="Snow Belt"})

    sets.precast.WS['Tachi: Kasha'] = set_combine(sets.precast.WS, {neck=gear.ElementalGorget,waist=gear.ElementalBelt})

    sets.precast.WS['Tachi: Gekko'] = set_combine(sets.precast.WS, {neck=gear.ElementalGorget,waist=gear.ElementalBelt})

    sets.precast.WS['Tachi: Yukikaze'] = set_combine(sets.precast.WS, {neck=gear.ElementalGorget,waist=gear.ElementalBelt})

    sets.precast.WS['Tachi: Ageha'] = set_combine(sets.precast.WS, {neck=gear.ElementalGorget,waist=gear.ElementalBelt})

    sets.precast.WS['Tachi: Jinpu'] = set_combine(sets.precast.WS, {neck=gear.ElementalGorget,waist=gear.ElementalBelt})
--]]

    -- Midcast Sets
    sets.midcast.FastRecast = {
        head="Yaoyotl Helm",
        body="Otronif Harness +1",hands="Otronif Gloves",
        legs="Phorcys Dirs",feet="Otronif Boots +1"}

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {neck="Wiglen Gorget",ring1="Sheltered Ring",ring2="Paguroidea Ring"}
    

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle.Town = {
		--main="Tsurumaru", 
		--sub="Pole Grip",
		ammo="Thew Bomblet",
        head="Yaoyotl Helm",
		neck="Asperity Necklace",
		ear1="Bladeborn Earring",
		ear2="Steelflash Earring",
        body="Otronif Harness +1",
		hands="Otronif Gloves",
		ring1="Sheltered Ring",
		ring2="Paguroidea Ring",
        back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		waist="Flume Belt",
		legs="Phorcys Dirs",
		feet="Danzo Sune-ate"
	}
    
    sets.idle.Field = {
        head="Wakido Kabuto +2",
		neck="Sanctity Necklace",
		ear1="Bladeborn Earring",
		ear2="Steelflash Earring",
        body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
		hands="Wakido Kote +3",
		ring1="Flamma Ring",
		ring2="Patronus Ring",
        back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		waist="Ioskeha Belt",
		legs="Wakido Haidate +3",
		feet="Flamma Gambieras +2"
	}

    sets.idle.Weak = {
        head="Twilight Helm",neck="Wiglen Gorget",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Twilight Mail",hands="Buremte Gloves",ring1="Sheltered Ring",ring2="Paguroidea Ring",
        back="Shadow Mantle",waist="Flume Belt",legs="Karieyh Brayettes +1",feet="Danzo Sune-ate"}
    
    -- Defense sets
    sets.defense.PDT = {ammo="Iron Gobbet",
        head="Yaoyotl Helm",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Otronif Harness +1",hands="Otronif Gloves",ring1="Defending Ring",ring2=gear.DarkRing.physical,
        back="Shadow Mantle",waist="Flume Belt",legs="Karieyh Brayettes +1",feet="Otronif Boots +1"}

    sets.defense.Reraise = {
        head="Twilight Helm",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Twilight Mail",hands="Buremte Gloves",ring1="Defending Ring",ring2="Paguroidea Ring",
        back="Shadow Mantle",waist="Flume Belt",legs="Karieyh Brayettes +1",feet="Otronif Boots +1"}

    sets.defense.MDT = {ammo="Demonry Stone",
        head="Yaoyotl Helm",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Otronif Harness +1",hands="Otronif Gloves",ring1="Defending Ring",ring2="Shadow Ring",
        back="Engulfer Cape",waist="Flume Belt",legs="Karieyh Brayettes +1",feet="Otronif Boots +1"}

    sets.Kiting = {feet="Danzo Sune-ate"}

    sets.Reraise = {head="Twilight Helm",body="Twilight Mail"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    -- Delay 450 GK, 25 Save TP => 65 Store TP for a 5-hit (25 Store TP in gear)
    sets.engaged = {
		ammo="Aurgelmir Orb",
        head="Flamma Zucchetto +2",
		neck="Samurai's Nodowa +2",
		ear1="Schere Earring",
		ear2="Brutal Earring",
        body="Wakido Domaru +3", --{ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
		hands="Wakido Kote +3",
		ring1="Niqmaddu Ring",
		ring2="Chirich Ring",
        back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		waist="Ioskeha Belt",
		legs="Tatenashi Haidate +1",
		feet="Flamma Gambieras +2"
	}
    sets.engaged.Acc = {
		ammo="Ginsen",
        head="Flamma Zucchetto +2",
		neck="Samurai's Nodowa +2",
		ear1="Bladeborn Earring",
		ear2="Steelflash Earring",
        body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
		hands="Wakido Kote +3",
		ring1="Flamma Ring",
		ring2="Chirich Ring",
        back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		waist="Ioskeha Belt",
		legs="Wakido Haidate +3",
		feet="Flamma Gambieras +2"
	}
    sets.engaged.STP = {
		--sub="Bloodrain Strap",
		--ranged="Cibitshavore",
        head="Flamma Zucchetto +2",
		neck="Samurai's Nodowa +2",
		ear1="Dedition Earring",
		ear2="Brutal Earring",
        body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
		hands="Wakido Kote +3",
		ring1="Flamma Ring",
		ring2="Chirich Ring",
        back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		waist="Ioskeha Belt",
		legs="Tatenashi Haidate +1",
		feet="Flamma Gambieras +2"
	}
	sets.engaged.Mpaca = {
		head="Flam. Zucchetto +2",
		body="Mpaca's Doublet",
		hands="Mpaca's Gloves",
		legs="Mpaca's Hose",
		feet="Mpaca's Boots",
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Schere Earring",
		right_ear="Brutal Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Chirich Ring",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	}
	
    sets.engaged.PDT = {ammo="Thew Bomblet",
        head="Yaoyotl Helm",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Otronif Harness +1",hands="Otronif Gloves",ring1="Defending Ring",ring2="K'ayres Ring",
        back="Iximulew Cape",waist="Goading Belt",legs="Unkai Haidate +2",feet="Otronif Boots +1"}
    sets.engaged.Acc.PDT = {ammo="Honed Tathlum",
        head="Yaoyotl Helm",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Otronif Harness +1",hands="Otronif Gloves",ring1="Defending Ring",ring2="K'ayres Ring",
        back="Letalis Mantle",waist="Goading Belt",legs="Unkai Haidate +2",feet="Otronif Boots +1"}
    sets.engaged.Reraise = {ammo="Thew Bomblet",
        head="Twilight Helm",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Twilight Mail",hands="Otronif Gloves",ring1="Beeline Ring",ring2="K'ayres Ring",
        back="Ik Cape",waist="Goading Belt",legs="Unkai Haidate +2",feet="Otronif Boots +1"}
    sets.engaged.Acc.Reraise = {ammo="Thew Bomblet",
        head="Twilight Helm",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Twilight Mail",hands="Otronif Gloves",ring1="Beeline Ring",ring2="K'ayres Ring",
        back="Letalis Mantle",waist="Goading Belt",legs="Unkai Haidate +2",feet="Otronif Boots +1"}
        
    -- Melee sets for in Adoulin, which has an extra 10 Save TP for weaponskills.
    -- Delay 450 GK, 35 Save TP => 89 Store TP for a 4-hit (49 Store TP in gear), 2 Store TP for a 5-hit
    sets.engaged.Adoulin = {
				ammo="Hasty Pinion +1",
        head="Flamma Zucchetto +2",
		neck="Samurai's Nodowa +2",
		ear1="Bladeborn Earring",
		ear2="Steelflash Earring",
        body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
		hands="Wakido Kote +3",
		ring1="Flamma Ring",
		ring2="Chirich Ring",
        back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		waist="Ioskeha Belt",
		legs="Tatenashi Haidate +1",
		feet="Flamma Gambieras +2"
	}
		--{ammo="Thew Bomblet",
        --head="Yaoyotl Helm",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        --body="Gorney Haubert +1",hands="Otronif Gloves",ring1="Rajas Ring",ring2="K'ayres Ring",
        --back="Takaha Mantle",waist="Goading Belt",legs="Unkai Haidate +2",feet="Otronif Boots +1"}
    sets.engaged.Adoulin.Acc = {
		ammo="Hasty Pinion +1",
        head="Flamma Zucchetto +2",
		neck="Samurai's Nodowa +2",
		ear1="Bladeborn Earring",
		ear2="Steelflash Earring",
        body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
		hands="Wakido Kote +3",
		ring1="Flamma Ring",
		ring2="Chirich Ring",
        back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		waist="Ioskeha Belt",
		legs="Wakido Haidate +3",
		feet="Flamma Gambieras +2"
	}
		--{ammo="Thew Bomblet",
        --head="Yaoyotl Helm",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        --body="Unkai Domaru +2",hands="Otronif Gloves",ring1="Rajas Ring",ring2="K'ayres Ring",
        --back="Letalis Mantle",waist="Goading Belt",legs="Unkai Haidate +2",feet="Otronif Boots +1"}
    sets.engaged.Adoulin.PDT = {ammo="Thew Bomblet",
        head="Yaoyotl Helm",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Otronif Harness +1",hands="Otronif Gloves",ring1="Defending Ring",ring2="K'ayres Ring",
        back="Iximulew Cape",waist="Goading Belt",legs="Unkai Haidate +2",feet="Otronif Boots +1"}
    sets.engaged.Adoulin.Acc.PDT = {ammo="Honed Tathlum",
        head="Yaoyotl Helm",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Otronif Harness +1",hands="Otronif Gloves",ring1="Defending Ring",ring2="K'ayres Ring",
        back="Letalis Mantle",waist="Goading Belt",legs="Unkai Haidate +2",feet="Otronif Boots +1"}
    sets.engaged.Adoulin.Reraise = {ammo="Thew Bomblet",
        head="Twilight Helm",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Twilight Mail",hands="Otronif Gloves",ring1="Beeline Ring",ring2="K'ayres Ring",
        back="Ik Cape",waist="Goading Belt",legs="Unkai Haidate +2",feet="Otronif Boots +1"}
    sets.engaged.Adoulin.Acc.Reraise = {ammo="Thew Bomblet",
        head="Twilight Helm",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Twilight Mail",hands="Otronif Gloves",ring1="Beeline Ring",ring2="K'ayres Ring",
        back="Letalis Mantle",waist="Goading Belt",legs="Unkai Haidate +2",feet="Otronif Boots +1"}


    sets.buff.Sekkanoki = {hands="Unkai Kote +2"}
    sets.buff.Sengikori = {feet="Unkai Sune-ate +2"}
    sets.buff['Meikyo Shisui'] = {feet="Sakonji Sune-ate"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        -- Change any GK weaponskills to polearm weaponskill if we're using a polearm.
        if player.equipment.main=='Quint Spear' or player.equipment.main=='Quint Spear' then
            if spell.english:startswith("Tachi:") then
                send_command('@input /ws "Penta Thrust" '..spell.target.raw)
                eventArgs.cancel = true
            end
		-- if the player has 3000 tp changes the WS mode to Mod inorder to min/max the dmg
		elseif player.tp > 2990 and state.WeaponskillMode.current == 'Normal' then
				state.WeaponskillMode:set('Mod')
		elseif player.tp < 2990 and state.WeaponskillMode.current == 'Mod' then
				state.WeaponskillMode:set('Normal')
        end
    end
end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type:lower() == 'weaponskill' then
        if state.Buff.Sekkanoki then
            equip(sets.buff.Sekkanoki)
        end
        if state.Buff.Sengikori then
            equip(sets.buff.Sengikori)
        end
        if state.Buff['Meikyo Shisui'] then
            equip(sets.buff['Meikyo Shisui'])
        end
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
--    if spell.type == "WeaponSkill" and player.tp == 3000 then
--	if spell.type == "WeaponSkill" and (player.tp > 2990) then
	if spell.type == "WeaponSkill" then
--		if player.tp == 3000 then
		if player.tp > 2990 then
           --equip(sets.precast.WS['Impulse Drive'].HighTP)
			equip(sets.precast.WS.FullTP)
		end
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Effectively lock these items in place.
    if state.HybridMode.value == 'Reraise' or
        (state.DefenseMode.value == 'Physical' and state.PhysicalDefenseMode.value == 'Reraise') then
        equip(sets.Reraise)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_combat_form()
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    if areas.Adoulin:contains(world.area) and buffactive.ionis then
        state.CombatForm:set('Adoulin')
    else
        state.CombatForm:reset()
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(1, 11)
    elseif player.sub_job == 'DNC' then
        set_macro_page(2, 11)
    elseif player.sub_job == 'THF' then
        set_macro_page(3, 11)
    elseif player.sub_job == 'NIN' then
        set_macro_page(4, 11)
	elseif player.sub_job == 'DRG' then
        set_macro_page(5, 11)
    else
        set_macro_page(1, 11)
    end
end

