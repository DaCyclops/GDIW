

GDIWworklistIn = {}
GDIWworklistOut = {}
GDIWworklistBoth = {}
GDIWproductivity = {}

for kr, vr in pairs(data.raw.recipe) do
  --For each recipie
  GDIWfincount = 0
  if vr.ingredients then
    for _, vri in pairs(vr.ingredients) do
      --Search for Inputs with Fluids
      if vri.type == "fluid" then
        GDIWfincount = GDIWfincount + 1
      end
    end
  end  
  GDIWfoutcount = 0
  if vr.results then
    for _, vri in pairs(vr.results) do
      --Search for Outputs with Fluids
      if vri.type == "fluid" then
        GDIWfoutcount = GDIWfoutcount + 1
      end
    end
  end
  
  --and if they will be touched by this mod
  thisProduc = false
  if GDIWfincount > 1 or GDIWfoutcount > 1 then
    --determine if they have productivity support anywhere
    for _, vm in pairs(data.raw.module) do
      if vm.name:find("productivity%-module") and vm.limitation and vm.limitation[kr] then
          --And mark them as having it
          thisProduc = true
      end
    end
  end
    
  
  --And generate a list
  if GDIWfincount > 1 then
    --of Input flipping
    table.insert(GDIWworklistIn,{r=kr, prod=thisProduc})
  end
  if GDIWfoutcount > 1 then
    --of Output flipping
    table.insert(GDIWworklistOut,{r=kr, prod=thisProduc})
  end
  if GDIWfincount > 1 and GDIWfoutcount > 1 then
    --of Input and Output flipping
    table.insert(GDIWworklistBoth,{r=kr, prod=thisProduc})
  end
  
end


for _, vin in pairs(GDIWworklistIn) do
  -- Determine new names
  newName = vin.r .. "-GDIW-IR"
  -- copy table
  data.raw.recipe[newName] = util.table.deepcopy(data.raw.recipe[vin.r])
  
  vro = data.raw.recipe[vin.r]
  vrn = data.raw.recipe[newName]
  -- fix names (and enabled for testing)  
  vrn.name = newName
  localised_name = {{"recipe-name." .. vro.name},"GDIW.input-reversed"}
  vrn.enabled = true
  
  ingbuild = {}
  newing = {}
  fluidflip = {}
  
  sortcount = 0
  for _, vri in pairs(vrn.ingredients) do
    --Flip Input fluids
    sortcount = sortcount + 1
    vri.sortorder = sortcount
    if vri.type == "fluid" then
      vri.sortorder = 1000 - sortcount
    end
  end  
  table.sort(vrn.ingredients, function(a,b) return a.sortorder<b.sortorder end)
  
  newicons = {}
  --grab old icon(s)
  if vro.icon then
    table.insert(newicons,{icon=vro.icon})
    oldicon = vro.icon
  elseif vro.icons then
    newicons = util.table.deepcopy(vro.icons)
  else
    table.insert(newicons,{icon="__GDIW__/graphics/placeholder.png"})  
  end
  -- add overlay and use
  table.insert(newicons,{icon = "__GDIW__/graphics/reverse-overlay-input.png"})
  vrn.icons = newicons
  
  -- handle productivity modules
  if vin.prod then
    table.insert(GDIWproductivity,newName)
  end
  
end

for _, vin in pairs(GDIWworklistOut) do
  -- Determine new names
  newName = vin.r .. "-GDIW-OR"
  -- copy table
  data.raw.recipe[newName] = util.table.deepcopy(data.raw.recipe[vin.r])
  
  vro = data.raw.recipe[vin.r]
  vrn = data.raw.recipe[newName]
  -- fix names (and enabled for testing)  
  vrn.name = newName
  localised_name = {{"recipe-name." .. vro.name},"GDIW.output-reversed"}
  vrn.enabled = true
  
  ingbuild = {}
  newing = {}
  fluidflip = {}
  
  sortcount = 0
  for _, vrr in pairs(vrn.results) do
    --Flip Output fluids
    sortcount = sortcount + 1
    vrr.sortorder = sortcount
    if vrr.type == "fluid" then
      vrr.sortorder = 1000 - sortcount
    end
  end  
  table.sort(vrn.results, function(a,b) return a.sortorder<b.sortorder end)
  
  
  newicons = {}
  --grab old icon(s)
  if vro.icon then
    table.insert(newicons,{icon=vro.icon})
    oldicon = vro.icon
  elseif vro.icons then
    newicons = util.table.deepcopy(vro.icons)
  else
    table.insert(newicons,{icon="__GDIW__/graphics/placeholder.png"})  
  end
  -- add overlay and use
  table.insert(newicons,{icon = "__GDIW__/graphics/reverse-overlay-output.png"})
  vrn.icons = newicons
  
  -- handle productivity modules
  if vin.prod then
    table.insert(GDIWproductivity,newName)
  end
  
end

for _, vin in pairs(GDIWworklistBoth) do
  -- Determine new names
  newName = vin.r .. "-GDIW-BR"
  -- copy table
  data.raw.recipe[newName] = util.table.deepcopy(data.raw.recipe[vin.r])
  
  vro = data.raw.recipe[vin.r]
  vrn = data.raw.recipe[newName]
  -- fix names (and enabled for testing)  
  vrn.name = newName
  localised_name = {{"recipe-name." .. vro.name},"GDIW.both-reversed"}
  vrn.enabled = true
  
  ingbuild = {}
  newing = {}
  fluidflip = {}
  
  sortcount = 0
  for _, vri in pairs(vrn.ingredients) do
    --Flip Input fluids
    sortcount = sortcount + 1
    vri.sortorder = sortcount
    if vri.type == "fluid" then
      vri.sortorder = 1000 - sortcount
    end
  end  
  table.sort(vrn.ingredients, function(a,b) return a.sortorder<b.sortorder end)
  
  sortcount = 0
  for _, vrr in pairs(vrn.results) do
    --Flip Output fluids
    sortcount = sortcount + 1
    vrr.sortorder = sortcount
    if vrr.type == "fluid" then
      vrr.sortorder = 1000 - sortcount
    end
  end  
  table.sort(vrn.results, function(a,b) return a.sortorder<b.sortorder end)
  
  
  
  newicons = {}
  --grab old icon(s)
  if vro.icon then
    table.insert(newicons,{icon=vro.icon})
    oldicon = vro.icon
  elseif vro.icons then
    newicons = util.table.deepcopy(vro.icons)
  else
    table.insert(newicons,{icon="__GDIW__/graphics/placeholder.png"})  
  end
  -- add overlay and use
  table.insert(newicons,{icon = "__GDIW__/graphics/reverse-overlay-both.png"})
  vrn.icons = newicons
  
  -- handle productivity modules
  if vin.prod then
    table.insert(GDIWproductivity,newName)
  end
  
end






for km, vm in pairs(data.raw.module) do
  if vm.name:find("productivity%-module") and vm.limitation then
    for _, recipe in ipairs(GDIWproductivity) do
      table.insert(vm.limitation, recipe)
    end
  end
end


