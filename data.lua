require("prototypes.style")

-- Fix for vanilla recipies that dont provide an icon....
data.raw.recipe["sulfur"].icon = data.raw.item["sulfur"].icon
data.raw.recipe["flame-thrower-ammo"].icon = data.raw.ammo["flame-thrower-ammo"].icon