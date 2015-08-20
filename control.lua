local mod_version="1.0.0"

local function onLoad()
  if global.GDIW==nil or global.GDIW.version ~= mod_version then
    --unlock if needed
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

local function onSave()
  global.GDIW={version=mod_version}
end


game.on_init(onLoad)
game.on_load(onLoad)

game.on_save(onSave)
