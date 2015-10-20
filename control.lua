


local function onConfigChange(cDat)
  
  if cDat.mod_changes ~= nil and cDat.mod_changes["GDIW"] ~= nil and cDat.mod_changes["GDIW"].old_version == nil then
   -- Mod added 
    for _,force in pairs(game.forces) do
      force.reset_recipes()
      force.reset_technologies()

      local techs=force.technologies
      local recipes=force.recipes

      if techs["advanced-oil-processing"].researched then
        recipes["advanced-oil-processing-GDIW"].enabled=true
        recipes["heavy-oil-cracking-GDIW"].enabled=true
        recipes["light-oil-cracking-GDIW"].enabled=true
      end
      if techs["sulfur-processing"].researched then
        recipes["sulfur-GDIW"].enabled=true
      end
      if techs["flame-thrower"].researched then
        recipes["flame-thrower-ammo-GDIW"].enabled=true
      end

    end
    
  end 

  if cDat.mod_changes ~= nil and cDat.mod_changes["GDIW"] ~= nil and cDat.mod_changes["GDIW"].old_version ~= nil then
   -- Mod updated or removed
    for _,force in pairs(game.forces) do
      force.reset_recipes()
      force.reset_technologies()

      local techs=force.technologies
      local recipes=force.recipes

      if techs["advanced-oil-processing"].researched then
        recipes["advanced-oil-processing-GDIW"].enabled=true
        recipes["heavy-oil-cracking-GDIW"].enabled=true
        recipes["light-oil-cracking-GDIW"].enabled=true
      end
      if techs["sulfur-processing"].researched then
        recipes["sulfur-GDIW"].enabled=true
      end
      if techs["flame-thrower"].researched then
        recipes["flame-thrower-ammo-GDIW"].enabled=true
      end      
      
    end

  end

end


local function onInit()
  -- Nothing to do now
end    

local function onLoad()
  -- Nothing to do now
end


script.on_init(onInit)
script.on_load(onLoad)

script.on_configuration_changed(onConfigChange(data))