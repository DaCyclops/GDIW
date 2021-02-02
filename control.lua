--Button disable flag. True for now, because button CANT do what I want it to...
local disableButton = true
if disableButton == false then require("button") end

function recheck_all_recipes(rf) 

      for _, research in pairs(rf.technologies) do
        if research.researched then
         if research.effects then
           for _, effect in pairs (research.effects) do
             if effect.type == "unlock-recipe" then
               rf.recipes[effect.recipe].enabled = true
             end
           end
         end
        end
      end

end

-- Proxy so I can remove unneeded code without removing/commenting unneeded calls
function createMainButtonProxy(x)
  if disableButton then return end  
  createMainButton(x)
end


 -- Start OnLoad/OnInit/OnConfig events
script.on_configuration_changed( function(data)
  -- Do Any Mod Changes
  
  -- Setup for global list 
  -- wipe global list if any mod changes, not just GDIW   
  global.gdiwlist = {}
  
  --if global.gdiwlist ~= nil then
    --gdiwliststring = loadstring(game.entity_prototypes["gdiw_data_list_flying-text"].order)()
    --global.gdiwlist = gdiwliststring
  --end
    
   -- Do GDIW Mod added 
  if data.mod_changes ~= nil and data.mod_changes["GDIW"] ~= nil and data.mod_changes["GDIW"].old_version == nil then
    for _,force in pairs(game.forces) do
      force.reset_recipes()
      force.reset_technologies()
      
      recheck_all_recipes(force)
    end
    for idx, _ in pairs(game.players) do
			createMainButtonProxy(idx)
		end

  end 

   -- Do GDIW Mod updated or removed
  if data.mod_changes ~= nil and data.mod_changes["GDIW"] ~= nil and data.mod_changes["GDIW"].old_version ~= nil then
    for _,force in pairs(game.forces) do
      force.reset_recipes()
      force.reset_technologies()

      -- Re-disable all GDIW recipes (Useful when old save versions involved)
      for _, i in pairs(global.gdiwlist) do 
        for _, j in pairs(i) do
          force.recipes[j.name].enabled = false
        end
      end
      recheck_all_recipes(force)
    end      

    for idx, _ in pairs(game.players) do
			createMainButtonProxy(idx)
		end

	
  end
    


end)


script.on_init(function()
  -- Nothing to do now

end)   
  
script.on_load(function()
  --Nothing to Do Now  
  
end)
-- End OnLoad/OnInit/OnConfig events


function doGDIWRotate(ent, pl)
  --Function for triggering rotation of recipe.
  -- thank you GDIWHotkey mod
  curRec = ent.get_recipe()
  if curRec ~= nil then
    --doing
    if (string.find(curRec.name, "GDIW") == nil) then
			nextRec = curRec.name .. "-GDIW-OR"
			if ent.force.recipes[nextRec] then
				ent.set_recipe(nextRec)
			else
				nextRec = curRec.name .. "-GDIW-IR"
				if ent.force.recipes[nextRec] then
					ent.set_recipe(nextRec)
				else
					nextRec = curRec.name .. "-GDIW-BR"
					if ent.force.recipes[nextRec] then
						ent.set_recipe(nextRec)
					else
						nextRec = curRec.name .. "-GDIW-AR"
						if ent.force.recipes[nextRec] then
							ent.set_recipe(nextRec)
						else
							ent.set_recipe(curRec)
						end
					end
				end
			end
		elseif (string.find(curRec.name, "GDIW%-OR") ~= nil) then
			baseRec = string.gsub(curRec.name, "%-GDIW%-OR", "")
			nextRec = baseRec .. "-GDIW-IR"
			if ent.force.recipes[nextRec] then
				ent.set_recipe(nextRec)
			else
				nextRec = baseRec .. "-GDIW-BR"
				if ent.force.recipes[nextRec] then
					ent.set_recipe(nextRec)
				else
					nextRec = baseRec .. "-GDIW-AR"
					if ent.force.recipes[nextRec] then
						ent.set_recipe(nextRec)
					else
						ent.set_recipe(baseRec)
					end
				end
			end
		elseif (string.find(curRec.name, "GDIW%-IR") ~= nil) then
			baseRec = string.gsub(curRec.name, "%-GDIW%-IR", "")
			nextRec = baseRec .. "-GDIW-BR"
			if ent.force.recipes[nextRec] then
				ent.set_recipe(nextRec)
			else
				nextRec = baseRec .. "-GDIW-AR"
				if ent.force.recipes[nextRec] then
					ent.set_recipe(nextRec)
				else
					ent.set_recipe(baseRec)
				end
			end
		
		elseif (string.find(curRec.name, "GDIW%-BR") ~= nil) then
			baseRec = string.gsub(curRec.name, "%-GDIW%-BR", "")
			nextRec = baseRec .. "-GDIW-AR"
			if ent.force.recipes[nextRec] then
				ent.set_recipe(nextRec)
			else
				ent.set_recipe(baseRec)
			end
		else
			return
		end
	else
		return
	end


end

-- thank you GDIWHotkey mod
--When Hotkey is pressed...
script.on_event("GDIW-Rotate", function(event)
	--...check if player has a suitable machine selected and if they do...
	local pl = game.players[event.player_index]
	local ent = pl.selected
	if ent and ent.type == "assembling-machine" and pl.can_reach_entity(ent) and ent.get_recipe ~= nil then
		--...cycle to next recipe version.
		doGDIWRotate(ent, pl)
	end
end)


