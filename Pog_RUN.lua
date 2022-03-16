-- NOTE: I do not play run, so this will not be maintained for 'active' use. 
-- It is added to the repository to allow people to have a baseline to build from,
-- and make sure it is up-to-date with the library API.


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


-- Setup vars that are user-independent.
function job_setup()
    -- Table of entries
    rune_timers = T{}
    -- entry = rune, index, expires
    
    if player.main_job_level >= 65 then
        max_runes = 3
    elseif player.main_job_level >= 35 then
        max_runes = 2
    elseif player.main_job_level >= 5 then
        max_runes = 1
    else
        max_runes = 0
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('Normal', 'DD', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.PhysicalDefenseMode:options('PDT')
    state.IdleMode:options('DT', 'RegenRegain', 'Refresh')
	
	send_command('bind !p input /ma "Phalanx" <me>;')
	send_command('bind !a input /ma "Aquaveil" <me>;')
	send_command('bind !s input /ma "Shock Spikes" <me>;')
	send_command('bind !b input /ma "Refresh" <me>;')
	send_command('bind !g input /ma "Regen IV" <me>;')
	send_command('bind !l input /ma "Stoneskin" <me>;')
	send_command('bind !k input /ma "Blink" <me>;')
	send_command('bind !x input /ma "Temper" <me>;')
	send_command('bind @1 input /ja "Ignis" <me>; input /echo ADD: enFire RESIST: Ice; input /echo eva dwn, para, frost, bind;')
	send_command('bind @2 input /ja "Gelus" <me>; input /echo ADD: enIce RESIST: Wind; input /echo def dwn, grav, silence, choke;')
	send_command('bind @3 input /ja "Tellus" <me>; input /echo ADD: enEarth RESIST: Lightning; input /echo mag def dwn, stun, shock;')
	send_command('bind @4 input /ja "Sulpor" <me>; input /echo ADD: enLightning RESIST: Water; input /echo atk dwn, poison, drown;')
	send_command('bind @5 input /ja "Flabra" <me>; input /echo ADD: enWind RESIST: Earth; input /echo acc dwn, petrify, rasp, slow;')
	send_command('bind @6 input /ja "Unda" <me>; input /echo ADD: enWater RESIST: Fire; input /echo mag atk dwn, amnesia, plague, addle, burn;')
	send_command('bind @7 input /ja "Lux" <me>; input /echo ADD: enLight RESIST: Dark; input /echo mag eva dwn, dispel, sleep, blind;')
	send_command('bind @8 input /ja "Tenebrae" <me>; input /echo ADD: enDark RESIST: Light; input /echo mag acc dwn, finale, lullaby, charm;')
	send_command('bind @0 input /item "Remedy" <me>;')
	send_command('bind @v input /ja "Vivacious Pulse" <me>;')
	send_command('bind @e input /ja "Embolden" <me>;')

	select_default_macro_book()
end

function user_unload()
    send_command('unbind !p')
    send_command('unbind !a')
    send_command('unbind !s')
    send_command('unbind !b')
	send_command('unbind !g')
	send_command('unbind !l')
	send_command('unbind !k')
	send_command('unbind !x')
	send_command('unbind @1')
    send_command('unbind @2')
    send_command('unbind @3')
    send_command('unbind @4')
	send_command('unbind @5')
	send_command('unbind @6')
	send_command('unbind @7')
	send_command('unbind @8')
	send_command('unbind @0')
	send_command('unbind @v')
	send_command('unbind @e')
end

function init_gear_sets()
    sets.enmity = {ammo="Charitoni Sling",
		head="Halitus Helm", neck={ name="Futhark Torque +2", augments={'Path: A',}},
		hands="Futhark Mitons", right_ring="Petrov Ring",
		waist="Sinew Belt", legs="Eri. Leg Guards +1", feet="Erilaz Greaves +1"}

	--------------------------------------
	-- Precast sets
	--------------------------------------

	-- Precast sets to enhance JAs
    sets.precast.JA['Vallation'] = {body="Runeist's Coat +2", back="Ogma's Cape", legs="Futhark trousers"}
    sets.precast.JA['Valiance'] = sets.precast.JA['Vallation']
    sets.precast.JA['Pflug'] = {feet="Runeist bottes"}
    sets.precast.JA['Battuta'] = {head="Futhark Bandeau +2"}
    sets.precast.JA['Liement'] = {body="Futhark Coat +3"}
    sets.precast.JA['Lunge'] = {head="Thaumas Hat", neck="Eddy Necklace", ear1="Novio Earring", ear2="Friomisi Earring",
            body="Vanir Cotehardie", ring1="Acumen Ring", ring2="Omega Ring",
            back="Evasionist's Cape", waist="Yamabuki-no-obi", legs="Iuitl Tights +1", feet="Qaaxo Leggings"}
    sets.precast.JA['Swipe'] = sets.precast.JA['Lunge']
    sets.precast.JA['Gambit'] = {hands="Runeist Mitons"}
    sets.precast.JA['Rayke'] = {feet="Futhark Bottes"}
    sets.precast.JA['Elemental Sforzo'] = {body="Futhark Coat +3"}
    sets.precast.JA['Swordplay'] = {hands="Futhark Mitons"}
    sets.precast.JA['Embolden'] = {}
    sets.precast.JA['Vivacious Pulse'] = {}
    sets.precast.JA['One For All'] = {}
    sets.precast.JA['Provoke'] = sets.enmity


	-- Fast cast sets for spells
    sets.precast.FC = {
        head="Runeist bandeau",
		ear1="Loquacious Earring",
		ear2="Eiolation Earring",
        body="Dread Jupon",
		hands="Thaumas gloves",
		ring2="Prolix Ring",
		waist="Rumination Sash",
        legs="Enif Cosciales"
	}
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {head="Erilaz Galea +1",waist="Siegel Sash", legs="Futhark Trousers"})
    sets.precast.FC['Utsusemi: Ichi'] = set_combine(sets.precast.FC, {neck='Magoraga beads', back="Mujin Mantle"})
    sets.precast.FC['Utsusemi: Ni'] = set_combine(sets.precast.FC['Utsusemi: Ichi'], {})


	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
		ammo="Floestone",
		head="Nyame Helm",
		neck="Anu Torque",
		ear1="Ishvara Earring",
		ear2="Moonshade Earring",
		body="Ayanmo Corazza +2",
		hands="Meghanada Gloves +2",
		ring1="Niqmaddu Ring",
		ring2="Karieyh Ring",
		back="Ogma's Cape",
		waist="Sinew Belt",
		legs="Meghanada Chausses +2",
		feet={ name="Herculean Boots", augments={'Attack+9','"Triple Atk."+3','STR+1','Accuracy+9',}}
	}
	-- Spinning Slash STR+INT 30% Fragmentation (Wind + Lightning)
    sets.precast.WS['Spinning Slash'] = set_combine(sets.precast['Lunge'], {hands="Umuthi Gloves"})
    --sets.precast.WS['Spinning Slash'].Acc = set_combine(sets.precast.WS['Herculean Slash'].Normal, {})
	-- Ground Strike STR+INT 50% Fragmentation/Distortion (Wind + Lightning, Water + Ice)
    sets.precast.WS['Ground Strike'] = set_combine(sets.precast['Lunge'], {hands="Umuthi Gloves"})
    --sets.precast.WS['Ground Strike'].Acc = set_combine(sets.precast.WS['Herculean Slash'].Normal, {})
	-- Resolution STR 85% (Light)/Fragmentation/Scission (Wind + Lightning, Earth)
    sets.precast.WS['Resolution'] = {
		ammo="Floestone",
		--head="Nyame Helm",
		head="Lustratio Cap",
		neck="Futhark Torque +2",
		ear1="Ishvara Earring",
		ear2="Moonshade Earring",
		--body="Ayanmo Corazza +2",
		body="Lustratio Harness",
		hands="Meghanada Gloves +2",
		ring1="Niqmaddu Ring",
		ring2="Epona's Ring",
		back="Ogma's Cape",
		waist="Fotia Belt",
		legs="Meghanada Chausses +2",
		--feet={ name="Herculean Boots", augments={'Attack+9','"Triple Atk."+3','STR+1','Accuracy+9',}}
		feet="Lustratio Leggings"
	}
    sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS['Resolution'].Normal, 
        {ammo="Honed Tathlum", body="Dread Jupon", hands="Umuthi Gloves", back="Evasionist's Cape", legs="Manibozho Legs"})
	-- Dimidiation DEX 80% Light/Fragmentation
    sets.precast.WS['Dimidiation'] = {
		ammo="Focal Orb",
        head="Ayanmo Zucchetto +1", neck="Light Gorget", ear1="Ishvara Earring", ear2="Moonshade Earring",
		body="Ayanmo Corazza +2", hands="Meghanada Gloves +2", ring1="Niqmaddu Ring", ring2="Karieyh Ring",
		back="Ogma's Cape", waist="Fotia Belt", legs="Lustratio Subligar", feet="Lustratio Leggings"}--legs="Meghanada Chausses +2", feet={ name="Herculean Boots", augments={'Attack+9','"Triple Atk."+3','STR+1','Accuracy+9',}}}
    sets.precast.WS['Dimidiation'].Acc = set_combine(sets.precast.WS['Dimidiation'].Normal, 
        {ammo="Honed Tathlum", head="Whirlpool Mask", hands="Buremte Gloves", back="Evasionist's Cape", waist="Fotia Belt"})
	-- Herculean Slash VIT 80% Induration/Impactation/Detonation
    sets.precast.WS['Herculean Slash'] = set_combine(sets.precast['Lunge'], {hands="Umuthi Gloves"})
    --sets.precast.WS['Herculean Slash'].Acc = set_combine(sets.precast.WS['Herculean Slash'].Normal, {})


	--------------------------------------
	-- Midcast sets
	--------------------------------------
	
    sets.midcast.FastRecast = {}
    sets.midcast['Enhancing Magic'] = {neck="Colossus's torque", ear1="Andoaa Earring", body="Manasa Chasuble", hands="Runeist mitons", waist="Olympus Sash", legs="Futhark Trousers"}
    sets.midcast['Phalanx'] = set_combine(sets.midcast['Enhancing Magic'], {head="Futhark Bandeau +2"})
    sets.midcast['Regen'] = {head="Runeist Bandeau", legs="Futhark Trousers"}
    sets.midcast['Stoneskin'] = {waist="Siegel Sash"}
    sets.midcast.Cure = {neck="Colossus's Torque", hands="Buremte Gloves", ring1="Ephedra Ring", feet="Futhark Boots"}
	sets.midcast['Flash'] = sets.enmity
	sets.midcast['Stun'] = sets.enmity
	sets.midcast['Foil'] = sets.enmity

	--------------------------------------
	-- Idle/resting/defense/etc sets
	--------------------------------------

    sets.idle = { -- -50DT
		ammo="Staunch Tathlum",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Ioskeha Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Karieyh Ring",
		right_ring="Moonlight Ring",
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Dbl.Atk."+10',}}
	}
	sets.idle.RegenRegain = set_combine(sets.idle, {neck="Sanctity Necklace",
		body="Futhark Coat +3", hands="Turms Mittens +1", ring1="Karieyh Ring",
		feet="Turms Leggings +1"})
    sets.idle.Refresh = set_combine(sets.idle, {body="Runeist's Coat +2", ring1="Karieyh Ring", legs="Rawhide Trousers"})
           
	sets.defense.PDT = { -- -50PDT
		ammo="Staunch Tathlum",
		head="Futhark Bandeau +2", neck="Loricate Torque +1", ear1="Ethereal Earring", ear2="Tuisto Earring",
		body="Futhark Coat +3", hands="Turms Mittens +1", ring1="Defending Ring", ring2="Gelatinous Ring +1",
		back="Ogma's Cape", waist="Flume Belt", legs="Erilaz Leg Guards +1", feet="Turms Leggings +1"
	}

	sets.defense.MDT = { -- resist all elements +61, -50MDT
		ammo="Staunch Tathlum",
		head="Nyame Helm",
		body="Runeist's Coat +2",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Erilaz Greaves +1",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Ioskeha Belt",
		left_ear="Etiolation Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Defending Ring",
		right_ring="Moonlight Ring",
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Dbl.Atk."+10',}}
	}

	sets.Kiting = {feet="Skadi's Jambeaux +1"}


	--------------------------------------
	-- Engaged sets
	--------------------------------------

    sets.engaged = { -- -40DT
		ammo="Staunch Tathlum",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Ioskeha Belt",
		left_ear="Assuage Earring",
		right_ear="Brutal Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Epona's Ring",
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Dbl.Atk."+10',}}
	}
    sets.engaged.DD = { -- -20MDT, -28PDT
		ammo="Coiste Bodhar",
		head="Nyame Helm",
		body="Ayanmo Corazza +2",
		hands="Turms Mittens +1",
		legs="Meg. Chausses +2",
		feet={ name="Herculean Boots", augments={'Attack+9','"Triple Atk."+3','STR+1','Accuracy+9',}},
		neck="Anu Torque",
		waist="Ioskeha Belt",
		left_ear="Assuage Earring",
		right_ear="Brutal Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Epona's Ring",
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Dbl.Atk."+10',}}
	}
    sets.engaged.Acc = set_combine(sets.engaged.DD, {ammo="Falcon Eye",
			neck="Sanctity Necklace",
			hands="Turms Mittens +1", ring1="Moonlight Ring", ring2="Moonlight Ring",
			feet="Turms Leggings +1"})
 --[[   sets.engaged.PDT = {ammo="Aqreqaq Bomblet",
            head="Futhark Bandeau +2", neck="Futhark Torque +2", ear1="Ethereal Earring", ear2="Tuisto Earring",
            body="Futhark Coat +3", hands="Turms Mittens +1", ring1="Defending Ring", ring2="Gelatinous Ring +1",
            back="Ogma's Cape", waist="Flume Belt", legs="Erilaz Leg Guards +1", feet="Turms Leggings +1"}
    sets.engaged.MDT = {
            head="Futhark Bandeau +2", neck="Futhark Torque +2", ear1="Ethereal Earring", ear2="Tuisto Earring",
            body="Runeist's Coat +2", hands="Turms Mittens +1", ring1="Dark Ring", ring2="Epona's Ring",
            back="Ogma's Cape", waist="Flume Belt", legs="Runeist Trousers +1", feet="Turms Leggings +1"}
	sets.engaged.DT = set_combine(sets.engaged, {neck="Futhark Torque +2", ear1="Ethereal Earring", ear2="Tuisto Earring", 
			ring1="Defending Ring",ring2="Gelatinous Ring +1", 
			back="Solemnity Cape", waist="Flume Belt", feet="Ayanmo Gambieras +2"})   ]]--
    sets.engaged.repulse = {back="Repulse Mantle"}

end

------------------------------------------------------------------
-- Action events
------------------------------------------------------------------

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.english == 'Lunge' or spell.english == 'Swipe' then
        local obi = get_obi(get_rune_obi_element())
        if obi then
            equip({waist=obi})
        end
    end
end


function job_aftercast(spell)
    if not spell.interrupted then
        if spell.type == 'Rune' then
            update_timers(spell)
        elseif spell.name == "Lunge" or spell.name == "Gambit" or spell.name == 'Rayke' then
            reset_timers()
        elseif spell.name == "Swipe" then
            send_command(trim(1))
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'WAR' then
		set_macro_page(3, 20)
	elseif player.sub_job == 'NIN' then
		set_macro_page(1, 20)
	elseif player.sub_job == 'SAM' then
		set_macro_page(2, 20)
	elseif player.sub_job == 'DRK' then
		set_macro_page(4, 20)
	elseif player.sub_job == 'RDM' then
		set_macro_page(6, 20)
	elseif player.sub_job == 'BLU' then
		set_macro_page(7, 20)
	elseif player.sub_job == 'PLD' then
		set_macro_page(8, 20)
	elseif player.sub_job == 'DRG' then
		set_macro_page(9, 20)
	else
		set_macro_page(5, 20)
	end
end

function get_rune_obi_element()
    weather_rune = buffactive[elements.rune_of[world.weather_element] or '']
    day_rune = buffactive[elements.rune_of[world.day_element] or '']
    
    local found_rune_element
    
    if weather_rune and day_rune then
        if weather_rune > day_rune then
            found_rune_element = world.weather_element
        else
            found_rune_element = world.day_element
        end
    elseif weather_rune then
        found_rune_element = world.weather_element
    elseif day_rune then
        found_rune_element = world.day_element
    end
    
    return found_rune_element
end

function get_obi(element)
    if element and elements.obi_of[element] then
        return (player.inventory[elements.obi_of[element]] or player.wardrobe[elements.obi_of[element]]) and elements.obi_of[element]
    end
end


------------------------------------------------------------------
-- Timer manipulation
------------------------------------------------------------------

-- Add a new run to the custom timers, and update index values for existing timers.
function update_timers(spell)
    local expires_time = os.time() + 300
    local entry_index = rune_count(spell.name) + 1

    local entry = {rune=spell.name, index=entry_index, expires=expires_time}

    rune_timers:append(entry)
    local cmd_queue = create_timer(entry).. ';wait 0.05;'
    
    cmd_queue = cmd_queue .. trim()

    add_to_chat(123,'cmd_queue='..cmd_queue)

    send_command(cmd_queue)
end

-- Get the command string to create a custom timer for the provided entry.
function create_timer(entry)
    local timer_name = '"Rune: ' .. entry.rune .. '-' .. tostring(entry.index) .. '"'
    local duration = entry.expires - os.time()
    return 'timers c ' .. timer_name .. ' ' .. tostring(duration) .. ' down'
end

-- Get the command string to delete a custom timer for the provided entry.
function delete_timer(entry)
    local timer_name = '"Rune: ' .. entry.rune .. '-' .. tostring(entry.index) .. '"'
    return 'timers d ' .. timer_name .. ''
end

-- Reset all timers
function reset_timers()
    local cmd_queue = ''
    for index,entry in pairs(rune_timers) do
        cmd_queue = cmd_queue .. delete_timer(entry) .. ';wait 0.05;'
    end
    rune_timers:clear()
    send_command(cmd_queue)
end

-- Get a count of the number of runes of a given type
function rune_count(rune)
    local count = 0
    local current_time = os.time()
    for _,entry in pairs(rune_timers) do
        if entry.rune == rune and entry.expires > current_time then
            count = count + 1
        end
    end
    return count
end

-- Remove the oldest rune(s) from the table, until we're below the max_runes limit.
-- If given a value n, remove n runes from the table.
function trim(n)
    local cmd_queue = ''

    local to_remove = n or (rune_timers:length() - max_runes)

    while to_remove > 0 and rune_timers:length() > 0 do
        local oldest
        for index,entry in pairs(rune_timers) do
            if oldest == nil or entry.expires < rune_timers[oldest].expires then
                oldest = index
            end
        end
        
        cmd_queue = cmd_queue .. prune(rune_timers[oldest].rune)
        to_remove = to_remove - 1
    end
    
    return cmd_queue
end

-- Drop the index of all runes of a given type.
-- If the index drops to 0, it is removed from the table.
function prune(rune)
    local cmd_queue = ''
    
    for index,entry in pairs(rune_timers) do
        if entry.rune == rune then
            cmd_queue = cmd_queue .. delete_timer(entry) .. ';wait 0.05;'
            entry.index = entry.index - 1
        end
    end

    for index,entry in pairs(rune_timers) do
        if entry.rune == rune then
            if entry.index == 0 then
                rune_timers[index] = nil
            else
                cmd_queue = cmd_queue .. create_timer(entry) .. ';wait 0.05;'
            end
        end
    end
    
    return cmd_queue
end


------------------------------------------------------------------
-- Reset events
------------------------------------------------------------------

windower.raw_register_event('zone change',reset_timers)
windower.raw_register_event('logout',reset_timers)
windower.raw_register_event('status change',function(new, old)
    if gearswap.res.statuses[new].english == 'Dead' then
        reset_timers()
    end
end)





