-- No Button Styles yet...
--require("prototypes.style")

-- Fix for vanilla recipies that dont provide an icon....
data.raw.recipe["sulfur"].icon = data.raw.item["sulfur"].icon
data.raw.recipe["sulfur"].icon_size = data.raw.item["sulfur"].icon_size
data.raw.recipe["flamethrower-ammo"].icon = data.raw.ammo["flamethrower-ammo"].icon
data.raw.recipe["flamethrower-ammo"].icon_size = data.raw.ammo["flamethrower-ammo"].icon_size