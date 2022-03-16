-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:

    gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
    
    Treasure hunter modes:
        None - Will never equip TH gear
        Tag - Will equip TH gear sufficient for initial contact with a mob (either melee, ranged hit, or Aeolian Edge AOE)
        SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
        Fulltime - Will keep TH gear equipped fulltime

--]]

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
	include('Runera-Globals.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false
    
    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'TH', 'Mod')
    state.HybridMode:options('Normal', 'Evasion', 'PDT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
    state.PhysicalDefenseMode:options('Evasion', 'PDT')


    gear.default.weaponskill_neck = "Asperity Necklace"
    gear.default.weaponskill_waist = "Caudata Belt"
    gear.AugQuiahuiz = {name="Quiahuiz Trousers", augments={'Haste+2','"Snapshot"+2','STR+8'}}

    -- Additional local binds
    send_command('bind ^` input /ja "Flee" <me>')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind !- gs c cycle targetmode')
	send_command('bind !q input /equip main "Skinflayer"; input /equip sub "Shijo";')
	send_command('bind @/ input /item "Skeleton key" <t>')
	send_command('bind !. input /ja "spectral Jig" <me>')

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !-')
	send_command('unbind !q')
	send_command('unbind @/')
	send_command('unbind !.')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    sets.TreasureHunter = {
		head="White Rarab Cap +1",
		hands="Plunderer's Armlets",
		waist="Chaac Belt",
		feet="Skulker's Poulaines"
	}
    sets.ExtraRegen = {head="Ocelomeh Headpiece +1"}
    sets.Kiting = {feet="Skadi's Jambeaux +1"}

    sets.buff['Sneak Attack'] = {
		ammo="Qirmiz Tathlum",
        head="Mummu Bonnet +2",
		neck="Sanctity Necklace",
		ear1="Brutal Earring",
		ear2="Odr Earring",
        body="Mummu Jacket +2",
		hands="Mummu Wrists +2",
		ring1="Rajas Ring",
		ring2="Epona's Ring",
        back="Toutatis's Cape",
		waist="Cuchulains's Belt",
		legs="Mummu Kecks +2",
		feet="Mummu Gamashes +2"
	}

    sets.buff['Trick Attack'] = {
		ammo="Qirmiz Tathlum",
        head="Mummu Bonnet +2",
		neck="Huani Collar",
		ear1="Brutal Earring",
		ear2="Raider's Earring",
        body="Mummu Jacket +2",
		hands="Mummu Wrists +2",
		ring1="Meghanada Ring",
		ring2="Epona's Ring",
        back="Atheling Mantle",
		waist="Beir Belt +1",
		legs="Mummu Kecks +2",
		feet="Mummu Gamashes +2"
	}

    -- Actions we want to use to tag TH.
    sets.precast.Step = sets.TreasureHunter
    sets.precast.Flourish1 = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter


    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Collaborator'] = {head="Raider's Bonnet +2"}
    sets.precast.JA['Accomplice'] = {head="Raider's Bonnet +2"}
    sets.precast.JA['Flee'] = {feet="Rogue's Poulaines"}
    sets.precast.JA['Hide'] = {body="Rogue's Vest"}
    sets.precast.JA['Conspirator'] = {body="Raider's Vest +2"}
    sets.precast.JA['Steal'] = {
		head="Plunderer's Bonnet",
		hands="Rogue's Armlets",
		legs="Rogue's Culottes",
		feet="Pillager's Poulaines +1"
	}
    sets.precast.JA['Despoil'] = {legs="Raider's Culottes +2",feet="Skulker's Poulaines"}
    sets.precast.JA['Perfect Dodge'] = {hands="Plunderer's Armlets +1"}
    sets.precast.JA['Feint'] = {} -- {legs="Assassin's Culottes +2"}

    sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
    sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']


    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
		ammo="Sonia's Plectrum",
        head="Whirlpool Mask",
        body="Pillager's Vest +1",
		hands="Pillager's Armlets +1",
		ring1="Asklepian Ring",
        back="Iximulew Cape",
		waist="Caudata Belt",
		legs="Pillager's Culottes +1",
		feet="Plunderer's Poulaines +1"
	}

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}


    -- Fast cast sets for spells
    sets.precast.FC = {
		head="Haruspex Hat",
		ear2="Loquacious Earring",
		hands="Thaumas Gloves",
		ring1="Prolix Ring",
		legs="Enif Cosciales"
	}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})


    -- Ranged snapshot gear
    sets.precast.RA = {head="Aurore Beret",hands="Iuitl Wristbands",legs="Nahtirah Trousers",feet="Wurrukatte Boots"}


    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
		ammo="Voluspa Tathlum",
        head="Mummu Bonnet +2",
		neck="Rancor Collar",
		neck=gear.ElementalGorget,
		ear1="Ishvara Earring",
		ear2="Odr Earring",
        body="Meghanada	Cuirie +2",
		hands="Meghanada Gloves +2",
		ring1="Epaminondas's Ring",
		ring2="Epona's Ring",
        back="Toutatis's Cape",
		waist="Sailfi Belt +1",
		waist=gear.ElementalBelt,
		legs="Meghanada Chausses +2",
		feet="Mummu Gamashes +2"
	}
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {ammo="Honed Tathlum", back="Toutatis's Cape"})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {ring1="Stormsoul Ring",legs="Nahtirah Trousers"})
    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {ammo="Honed Tathlum", back="Letalis Mantle"})
    sets.precast.WS['Exenterator'].Mod = set_combine(sets.precast.WS['Exenterator'], {head="Felistris Mask",waist=gear.ElementalBelt})
    sets.precast.WS['Exenterator'].SA = set_combine(sets.precast.WS['Exenterator'].Mod, {ammo="Qirmiz Tathlum"})
    sets.precast.WS['Exenterator'].TA = set_combine(sets.precast.WS['Exenterator'].Mod, {ammo="Qirmiz Tathlum"})
    sets.precast.WS['Exenterator'].SATA = set_combine(sets.precast.WS['Exenterator'].Mod, {ammo="Qirmiz Tathlum"})

    sets.precast.WS['Dancing Edge'] = set_combine(sets.precast.WS, {ammo="Jukukik Feather",neck=gear.ElementalGorget,waist=gear.ElementalBelt})
    sets.precast.WS['Dancing Edge'].Acc = set_combine(sets.precast.WS['Dancing Edge'], {ammo="Honed Tathlum", back="Letalis Mantle"})
    sets.precast.WS['Dancing Edge'].Mod = set_combine(sets.precast.WS['Dancing Edge'], {waist=gear.ElementalBelt})
    sets.precast.WS['Dancing Edge'].SA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {ammo="Qirmiz Tathlum"})
    sets.precast.WS['Dancing Edge'].TA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {ammo="Qirmiz Tathlum"})
    sets.precast.WS['Dancing Edge'].SATA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {ammo="Qirmiz Tathlum"})

    --sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {ammo="Qirmiz Tathlum",head="Uk'uxkaj Cap",neck="Rancor Collar",ear1="Brutal Earring",ear2="Moonshade Earring"})
	sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {ammo="Jukukik Feather",neck=gear.ElementalGorget,ear1="Brutal Earring",ear2="Odr Earring",waist=gear.ElementalBelt})
    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {ammo="Honed Tathlum", back="Letalis Mantle"})
    sets.precast.WS['Evisceration'].Mod = set_combine(sets.precast.WS['Evisceration'], {back="Kayapa Cape",waist=gear.ElementalBelt})
    sets.precast.WS['Evisceration'].SA = set_combine(sets.precast.WS['Evisceration'].Mod, {})
    sets.precast.WS['Evisceration'].TA = set_combine(sets.precast.WS['Evisceration'].Mod, {})
    sets.precast.WS['Evisceration'].SATA = set_combine(sets.precast.WS['Evisceration'].Mod, {})

    sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {head="Pillager's Bonnet +1",ear1="Brutal Earring",ear2="Moonshade Earring"})
    sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {ammo="Honed Tathlum", back="Letalis Mantle"})
    sets.precast.WS["Rudra's Storm"].Mod = set_combine(sets.precast.WS["Rudra's Storm"], {back="Kayapa Cape",waist=gear.ElementalBelt})
    sets.precast.WS["Rudra's Storm"].SA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {ammo="Qirmiz Tathlum",body="Pillager's Vest +1",legs="Pillager's Culottes +1"})
    sets.precast.WS["Rudra's Storm"].TA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {ammo="Qirmiz Tathlum",body="Pillager's Vest +1",legs="Pillager's Culottes +1"})
    sets.precast.WS["Rudra's Storm"].SATA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {ammo="Qirmiz Tathlum",body="Pillager's Vest +1",legs="Pillager's Culottes +1"})

    --sets.precast.WS["Shark Bite"] = set_combine(sets.precast.WS, {head="Pillager's Bonnet +1",ear1="Brutal Earring",ear2="Moonshade Earring"})
	sets.precast.WS["Shark Bite"] = set_combine(sets.precast.WS, {head="Pillager's Bonnet +1",neck=gear.ElementalGorget,ear1="Brutal Earring",ear2="Odr Earring",waist=gear.ElementalBelt})
    sets.precast.WS['Shark Bite'].Acc = set_combine(sets.precast.WS['Shark Bite'], {ammo="Honed Tathlum", back="Letalis Mantle"})
    sets.precast.WS['Shark Bite'].Mod = set_combine(sets.precast.WS['Shark Bite'], {back="Kayapa Cape",waist=gear.ElementalBelt})
    sets.precast.WS['Shark Bite'].SA = set_combine(sets.precast.WS['Shark Bite'].Mod, {ammo="Qirmiz Tathlum",body="Pillager's Vest +1",legs="Pillager's Culottes +1"})
    sets.precast.WS['Shark Bite'].TA = set_combine(sets.precast.WS['Shark Bite'].Mod, {ammo="Qirmiz Tathlum",body="Pillager's Vest +1",legs="Pillager's Culottes +1"})
    sets.precast.WS['Shark Bite'].SATA = set_combine(sets.precast.WS['Shark Bite'].Mod, {ammo="Qirmiz Tathlum",body="Pillager's Vest +1",legs="Pillager's Culottes +1"})

    sets.precast.WS['Mandalic Stab'] = set_combine(sets.precast.WS, {head="Pillager's Bonnet +1",ear1="Brutal Earring",ear2="Moonshade Earring"})
    sets.precast.WS['Mandalic Stab'].Acc = set_combine(sets.precast.WS['Mandalic Stab'], {ammo="Honed Tathlum", back="Letalis Mantle"})
    sets.precast.WS['Mandalic Stab'].Mod = set_combine(sets.precast.WS['Mandalic Stab'], {back="Kayapa Cape",waist=gear.ElementalBelt})
    sets.precast.WS['Mandalic Stab'].SA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {ammo="Qirmiz Tathlum",body="Pillager's Vest +1",legs="Pillager's Culottes +1"})
    sets.precast.WS['Mandalic Stab'].TA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {ammo="Qirmiz Tathlum",body="Pillager's Vest +1",legs="Pillager's Culottes +1"})
    sets.precast.WS['Mandalic Stab'].SATA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {ammo="Qirmiz Tathlum",body="Pillager's Vest +1",legs="Pillager's Culottes +1"})

    sets.precast.WS['Aeolian Edge'] = {
		ammo="Jukukik Feather",
        head="Wayfarer Circlet",
		neck=gear.ElementalGorget,
		ear1="Hecate's Earring",
		ear2="Moldavite Earring",
        body="Wayfarer Robe",
		hands="Pillager's Armlets +1",
		ring1="Epaminondas's Ring",
		ring2="Acumen Ring",
		--ring2="Diamond Ring",
        back="Toro Cape",
		waist=gear.ElementalBelt,
		legs="Mummu Kecks +2",
		feet="Wayfarer Clogs"
	}

    sets.precast.WS['Aeolian Edge'].TH = set_combine(sets.precast.WS['Aeolian Edge'], sets.TreasureHunter)


    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {
        head="Whirlpool Mask",
		ear2="Loquacious Earring",
        body="Pillager's Vest +1",
		hands="Pillager's Armlets +1",
        back="Canny Cape",
		legs="Kaabnax Trousers",
		feet="Iuitl Gaiters +1"
	}

    -- Specific spells
    sets.midcast.Utsusemi = {
        head="Whirlpool Mask",
		neck="Magoraga Bead Necklace",
		ear2="Loquacious Earring",
        body="Pillager's Vest +1",
		hands="Pillager's Armlets +1",
		ring1="Beeline Ring",
        back="Canny Cape",
		waist="Twilight Belt",
		legs="Kaabnax Trousers",
		feet="Iuitl Gaiters +1"
	}

    -- Ranged gear
    sets.midcast.RA = {
        head="Whirlpool Mask",
		neck="Ej Necklace",
		ear1="Clearview Earring",
		ear2="Volley Earring",
        body="Iuitl Vest",
		hands="Iuitl Wristbands",
		ring1="Beeline Ring",
		ring2="Hajduk Ring",
        back="Libeccio Mantle",
		waist="Aquiline Belt",
		legs="Nahtirah Trousers",
		feet="Iuitl Gaiters +1"
	}

    sets.midcast.RA.Acc = {
        head="Pillager's Bonnet +1",
		neck="Ej Necklace",
		ear1="Clearview Earring",
		ear2="Volley Earring",
        body="Iuitl Vest",
		hands="Buremte Gloves",
		ring1="Beeline Ring",
		ring2="Hajduk Ring",
        back="Libeccio Mantle",
		waist="Aquiline Belt",
		legs="Thurandaut Tights +1",
		feet="Pillager's Poulaines +1"
	}


    --------------------------------------
    -- Idle/resting/defense sets
    --------------------------------------

    -- Resting sets
    sets.resting = {
		head="Ocelomeh Headpiece +1",
		neck="Wiglen Gorget",
        ring1="Sheltered Ring",
		ring2="Paguroidea Ring"
	}


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {
		--main="Twilight Knife", sub="Triplus Dagger",
		ammo="Thew Bomblet",
        head="Mummu Bonnet +2",
		neck="Sanctity Necklace",
		ear1="Brutal Earring",
		ear2="Eabani Earring",
        body="Mummu Jacket +2",
		hands="Mummu Wrists +2",
		ring1="Chirich Ring",
		ring2="Epona's Ring",
        back="Atheling Mantle",
		waist="Windbuffet Belt",
		legs="Mummu Kecks +2",
		feet="Mummu Gamashes +2"
	}

    sets.idle.Town = {
		--main="Twilight Knife", sub="Rapidus Sax",
		ammo="Thew Bomblet",
        head="Raider's Bonnet +2",
		neck="Magoraga Bead Necklace",
		ear1="Brutal Earring",
		ear2="Eabani Earring",
        body="Assassin's Vest +2",
		hands="Raider's Armlets +2",
		ring1="Epaminondas's Ring",
		ring2="Epona's Ring",
        back="Atheling Mantle",
		waist="Twilight Belt",
		legs="Raider's Culottes +2",
		feet="Skulker's Poulaines"
	}

    sets.idle.Weak = {
		ammo="Thew Bomblet",
        head="Meghanada Visor",
		neck="Peacock Amulet",
		ear1="Brutal Earring",
		ear2="Eabani Earring",
        body="Mummu Jacket +2",
		hands="Meghanada Gloves +2",
		ring1="Rajas Ring",
		ring2="Epona's Ring",
        back="Atheling Mantle",
		waist="Windbuffet Belt",
		legs="Mummu Kecks +2",
		feet="Meghanada Jambeaux +1"
	}


    -- Defense sets

    sets.defense.Evasion = {
        head="Pillager's Bonnet +1",
		neck="Ej Necklace",
        body="Qaaxo Harness",
		hands="Pillager's Armlets +1",
		ring1="Defending Ring",
		ring2="Beeline Ring",
        back="Canny Cape",
		waist="Flume Belt",
		legs="Kaabnax Trousers",
		feet="Iuitl Gaiters +1"
	}

    sets.defense.PDT = {
		ammo="Iron Gobbet",
        head="Pillager's Bonnet +1",
		neck="Twilight Torque",
        body="Iuitl Vest",
		hands="Pillager's Armlets +1",
		ring1="Defending Ring",
		ring2=gear.DarkRing.physical,
        back="Iximulew Cape",
		waist="Flume Belt",
		legs="Pillager's Culottes +1",
		feet="Iuitl Gaiters +1"
	}

    sets.defense.MDT = {
		ammo="Demonry Stone",
        head="Pillager's Bonnet +1",
		neck="Twilight Torque",
        body="Pillager's Vest +1",
		hands="Pillager's Armlets +1",
		ring1="Defending Ring",
		ring2="Shadow Ring",
        back="Engulfer Cape",
		waist="Flume Belt",
		legs="Pillager's Culottes +1",
		feet="Iuitl Gaiters +1"
	}


    --------------------------------------
    -- Melee sets
    --------------------------------------

    -- Normal melee group
    sets.engaged = {
		ammo="Aurgelmir Orb",
        head="Mummu Bonnet +2",
		neck="Asperity Necklace",
		ear1="Brutal Earring",
		ear2="Eabani Earring",
        body="Meghanada Cuirie +2",
		hands="Mummu Wrists +2",
		ring1="Mummu Ring",
		ring2="Epona's Ring",
        back="Toutatis's Cape",
		waist="Sailfi Belt +1",
		legs="Meghanada Chausses +2",
		feet="Plunderer's Poulaines +1"
	}
    sets.engaged.Acc = {
		ammo="Falcon Eye",
        head="Mummu Bonnet +2",
		neck="Sanctity Necklace",
		ear1="Brutal Earring",
		ear2="Odr Earring",
        body="Meghanada	Cuirie +2",
		hands="Mummu Wrists +2",
		ring1="Mummu Ring",
		ring2="Epona's Ring",
        back="Toutatis's Cape",
		waist="Sailfi Belt +1",
		legs="Meghanada Chausses +2",
		feet="Mummu Gamashes +2"
	}
    sets.engaged.TH = {
		ammo="Aurgelmir Orb",
        head="Mummu Bonnet +2",
		neck="Asperity Necklace",
		ear1="Brutal Earring",
		ear2="Eabani Earring",
        body="Meghanada Cuirie +2",
		hands="Mummu Wrists +2",
		ring1="Mummu Ring",
		ring2="Epona's Ring",
        back="Toutatis's Cape",
		waist="Sailfi Belt +1",
		legs="Meghanada Chausses +2",
		feet="Plunderer's Poulaines +1"
	}
    -- Mod set for trivial mobs (Skadi+1)
    sets.engaged.Mod = {
		ammo="Thew Bomblet",
        head="Felistris Mask",
		neck="Asperity Necklace",
		ear1="Dudgeon Earring",
		ear2="Heartseeker Earring",
        body="Skadi's Cuirie +1",
		hands="Pillager's Armlets +1",
		ring1="Meghanada Ring",
		ring2="Epona's Ring",
        back="Atheling Mantle",
		waist="Patentia Sash",
		legs=gear.AugQuiahuiz,
		feet="Plunderer's Poulaines +1"
	}
--[[	-- Mod set for CP+
	sets.engaged.Mod = {
		ammo="Aurgelmir Orb",
        head="Mummu Bonnet +2",
		neck="Asperity Necklace",
		ear1="Brutal Earring",
		ear2="Eabani Earring",
        body="Mummu Jacket +2",
		hands="Mummu Wrists +2",
		ring1="Mummu Ring",
		ring2="Epona's Ring",
        back="Mecistopins Mantle",
		waist="Sailfi Belt +1",
		legs="Mummu Kecks +2",
		feet="Mummu Gamashes +2"
	}--]]

    -- Mod set for trivial mobs (Thaumas)
    sets.engaged.Mod2 = {
		ammo="Aurgelmir Orb",
        head="Felistris Mask",
		neck="Asperity Necklace",
		ear1="Dudgeon Earring",
		ear2="Heartseeker Earring",
        body="Thaumas Coat",
		hands="Pillager's Armlets +1",
		ring1="Meghanada Ring",
		ring2="Epona's Ring",
        back="Atheling Mantle",
		waist="Patentia Sash",
		legs="Pillager's Culottes +1",
		feet="Plunderer's Poulaines +1"
	}

    sets.engaged.Evasion = {
		ammo="Aurgelmir Orb",
        head="Felistris Mask",
		neck="Ej Necklace",
		ear1="Dudgeon Earring",
		ear2="Heartseeker Earring",
        body="Qaaxo Harness",
		hands="Pillager's Armlets +1",
		ring1="Beeline Ring",
		ring2="Epona's Ring",
        back="Canny Cape",
		waist="Patentia Sash",
		legs="Kaabnax Trousers",
		feet="Qaaxo Leggings"
	}
    sets.engaged.Acc.Evasion = {
		ammo="Honed Tathlum",
        head="Whirlpool Mask",
		neck="Ej Necklace",
		ear1="Dudgeon Earring",
		ear2="Heartseeker Earring",
        body="Pillager's Vest +1",
		hands="Pillager's Armlets +1",
		ring1="Beeline Ring",
		ring2="Epona's Ring",
        back="Canny Cape",
		waist="Hurch'lan Sash",
		legs="Kaabnax Trousers",
		feet="Qaaxo Leggings"
	}

    sets.engaged.PDT = {
		ammo="Aurgelmir Orb",
        head="Felistris Mask",
		neck="Twilight Torque",
		ear1="Dudgeon Earring",
		ear2="Heartseeker Earring",
        body="Iuitl Vest",
		hands="Pillager's Armlets +1",
		ring1="Defending Ring",
		ring2="Epona's Ring",
        back="Iximulew Cape",
		waist="Patentia Sash",
		legs="Iuitl Tights",
		feet="Qaaxo Leggings"
	}
    sets.engaged.Acc.PDT = {
		ammo="Honed Tathlum",
        head="Whirlpool Mask",
		neck="Twilight Torque",
		ear1="Dudgeon Earring",
		ear2="Heartseeker Earring",
        body="Iuitl Vest",
		hands="Pillager's Armlets +1",
		ring1="Defending Ring",
		ring2="Epona's Ring",
        back="Canny Cape",
		waist="Hurch'lan Sash",
		legs="Iuitl Tights",
		feet="Qaaxo Leggings"
	}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
        equip(sets.TreasureHunter)
    elseif spell.english=='Sneak Attack' or spell.english=='Trick Attack' or spell.type == 'WeaponSkill' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
    end
end

-- Run after the general midcast() set is constructed.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.TreasureMode.value ~= 'None' and spell.action_type == 'Ranged Attack' then
        equip(sets.TreasureHunter)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end
end

-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
    check_buff('Feint', eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    local wsmode

    if state.Buff['Sneak Attack'] then
        wsmode = 'SA'
    end
    if state.Buff['Trick Attack'] then
        wsmode = (wsmode or '') .. 'TA'
    end

    return wsmode
end


-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)
    -- Check that ranged slot is locked, if necessary
    check_range_lock()

    -- Check for SATA when equipping gear.  If either is active, equip
    -- that gear specifically, and block equipping default gear.
    check_buff('Sneak Attack', eventArgs)
    check_buff('Trick Attack', eventArgs)
end


function customize_idle_set(idleSet)
    if player.hpp < 80 then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end

    return idleSet
end


function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end


-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    th_update(cmdParams, eventArgs)
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
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
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
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
    
    msg = msg .. ', TH: ' .. state.TreasureMode.value

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end


-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end


-- Function to lock the ranged slot if we have a ranged weapon equipped.
function check_range_lock()
    if player.equipment.range ~= 'empty' then
        disable('range', 'ammo')
    else
        enable('range', 'ammo')
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(2, 5)
    elseif player.sub_job == 'WAR' then
        set_macro_page(3, 5)
    elseif player.sub_job == 'NIN' then
        set_macro_page(4, 5)
    else
        set_macro_page(2, 5)
    end
end


