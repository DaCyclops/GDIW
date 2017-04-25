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



