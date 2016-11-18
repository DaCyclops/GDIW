function recheck_all_recipes (rf) 

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


 -- Start OnLoad/OnInit/OnConfig events
script.on_configuration_changed( function(data)
  if data.mod_changes ~= nil and data.mod_changes["GDIW"] ~= nil and data.mod_changes["GDIW"].old_version == nil then
   -- Mod added 
    for _,force in pairs(game.forces) do
      force.reset_recipes()
      force.reset_technologies()

      recheck_all_recipes(force)
    end
    
  end 

  if data.mod_changes ~= nil and data.mod_changes["GDIW"] ~= nil and data.mod_changes["GDIW"].old_version ~= nil then
   -- Mod updated or removed
    for _,force in pairs(game.forces) do
      force.reset_recipes()
      force.reset_technologies()
      
      recheck_all_recipes(force)
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


