

GDIWworklistIn = nil
GDIWworklistOut = nil
GDIWworklistBoth = nil
GDIWproductivity = nil

for kr, vr in pairs(data.raw.recipe) do
  --For each recipie
  GDIWfincount = 0
  for _, vri in pairs(vr.ingredients) do
    --Search for Inputs with Fluids
    if vri.type = "fluid" then
      GDIWfincount = GDIWfincount + 1
    end
  end  
  GDIWfoutcount = 0
  for _, vri in pairs(vr.results) do
    --Search for Outputs with Fluids
    if vri.type = "fluid" then
      GDIWfoutcount = GDIWfoutcount + 1
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
    GDIWworklistIn[] = {r=kr, prod=thisProduc}
  end
  if GDIWfoutcount > 1 then
    --of Output flipping
    GDIWworklistOut[] = {r=kr, prod=thisProduc}
  end
  if GDIWfincount > 1 and GDIWfoutcount > 1 then
    --of Input and Output flipping
    GDIWworklistBoth[] = {r=kr, prod=thisProduc}
  end
  
end


for _, vin in pairs(GDIWworklistIn) do
  
  newName = vin.r + "-GDIW-IR"
  data.raw.recipe[newName] = util.table.deepcopy(data.raw.recipe[vin.r])
  vro = data.raw.recipe[vin.r]
  vrn = data.raw.recipe[newName]
  
  for _, vri in pairs(vrn.ingredients) do
    --Search for Inputs with Fluids
    if vri.type = "fluid" then
      GDIWfincount = GDIWfincount + 1
    end
  end  



      vrn.icons =
      {
        {icon = vro.icon},
        {icon = "__GDIW__/graphics/reverse-overlay-input.png"}
      }
  
  GDIWproductivity[] = newName
  
end









for km, vm in pairs(data.raw.module) do
  if vm.name:find("productivity%-module") and vm.limitation then
    for _, recipe in ipairs(GDIWproductivity) do
      table.insert(vm.limitation, recipe)
    end
  end
end


