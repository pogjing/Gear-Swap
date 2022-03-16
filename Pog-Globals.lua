------------------------------------------------------------------------------
-- An example of setting up user-specific global handling of certain events.
-- This is for personal globals, as opposed to library globals.
-- name it (Yourcharactername)-Globals.lua. Copy/Paste the code below and place it with the rest of your (You)_JOB.lua files.
------------------------------------------------------------------------------

-- ! = alt
-- ^ = ctrl
-- @ = win
-- ~ = shift
-- # = apps
 
send_command('bind !w input /equip ring2 "Warp Ring"; /echo "Warping"; wait 11; input /item "Warp Ring" <me>;')
send_command('bind !t input /equip ring2 "Dim. Ring (Holla)"; /echo "Warping"; wait 11; input /item "Dim. Ring (Holla)" <me>;')
send_command('bind !m input /mount "Raptor";')
send_command('bind !d input /dismount;')
send_command('bind !, input /item "forbidden key" <t>;')
send_command('bind @r input //gs reload;')
send_command('bind @m input /map;')
send_command('bind !z input /item "Remedy" <me>;')
send_command('bind !c input /item "Panacea" <me>;')

    sets.reive = {neck="Adoulin's Refuge +1"}
	sets.trust = {body="Apururu Unity Shirt"}
	CP_CAPE = "Mecisto. Mantle"
 
-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)
    if buffactive['Reive Mark'] and player.inventory["Adoulin's Refuge +1"] or player.wardrobe["Adoulin's Refuge +1"] then
       equip(sets.reive)
    end
 
    if player.equipment.back == 'Mecisto. Mantle' then      
        disable('back')
    else
        enable('back')
    end
	
	-- Function to lock the ranged slot if we have a ranged weapon equipped.
    if player.equipment.range ~= 'empty' then
        disable('range', 'ammo')
    else
        enable('range', 'ammo')
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'Trust' then
        if spell.english == 'Apururu (UC)' then
			equip(sets.trust)
        end
	end
end

function auto_cp()
    if jobpoints ~= 2100 and jobpoints ~= nil then -- Basically if not master
        monsterToCheck = windower.ffxi.get_mob_by_target('t')
        if windower.ffxi.get_mob_by_target('t') then -- Sanity Check 
            if #monsterToCheck.name:split(' ') >= 2 then
                monsterName = T(monsterToCheck.name:split(' '))
                if monsterName[1] == "Apex" then
                    if monsterToCheck.hpp < 15 then --Check mobs HP Percentage if below 25 then equip CP cape 
                        equip({ back = CP_CAPE }) 
                        disable("back") --Lock back
                    else
                        enable("back") --Else make sure the back is enabled
                    end 
                end
            end
        else
            enable("back") --Else make sure the back is enabled
        end
    else
        enable("back") --Else make sure the back is enabled
    end
end

-----------------------------------------------------------
-- Test function to use to avoid modifying library files.
-----------------------------------------------------------
 
function user_test(params)
 
end