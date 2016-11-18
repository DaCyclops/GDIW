

GDIWworklistIn = {}
GDIWworklistOut = {}
GDIWworklistBoth = {}
GDIWproductivity = {}
GDIWresearch = {}

-- function for doing prototypes
function GDIWdoprototype(GDIWwl, isIn, isOut )
  for _, vin in pairs(GDIWwl) do
    -- Determine new names
    if isIn and isOut then
    suffix = "GDIW-BR"
    elseif isIn then
    suffix = "GDIW-IR"
    elseif isOut then
    suffix = "GDIW-OR"
    else
    suffix = "GDIW-AR"
    end
    newName = vin.r .. "-" .. suffix
    -- copy table
    data.raw.recipe[newName] = util.table.deepcopy(data.raw.recipe[vin.r])
    
    vro = data.raw.recipe[vin.r]
    vrn = data.raw.recipe[newName]
    -- fix names (and make enabled for testing)  
    vrn.name = newName
    vrn.localised_name = {"recipe-name." .. vro.name,{"gdiw-tags." .. suffix}}
    --vrn.enabled = true
    
    ingbuild = {}
    newing = {}
    fluidflip = {}
    
    if isIn then
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
    end
    
    if isOut then
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
    end
  
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
    if isIn and isOut then
      table.insert(newicons,{icon = "__GDIW__/graphics/reverse-overlay-both.png"})
    elseif isIn then
      table.insert(newicons,{icon = "__GDIW__/graphics/reverse-overlay-input.png"})
    elseif isOut then
      table.insert(newicons,{icon = "__GDIW__/graphics/reverse-overlay-output.png"})
    else
      table.insert(newicons,{icon = "__GDIW__/graphics/reverse-overlay-both.png"})
    end
    
    vrn.icons = newicons
    
    -- handle productivity modules
    if vin.prod then
      table.insert(GDIWproductivity,newName)
    end
  
  if not GDIWresearch[vin.r] then
    GDIWresearch[vin.r] = {}
  end
  
  table.insert(GDIWresearch[vin.r], newName)
  
  end

end --end function



-- Find what needs to be done
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



-- Add all prototypes via function
-- GDIWdoprototype(GDIWwl, isIn, isOut )
GDIWdoprototype(GDIWworklistIn, true, false )
GDIWdoprototype(GDIWworklistOut, false, true )
GDIWdoprototype(GDIWworklistBoth, true, true )


-- parse research, find unlocks and add new recipe
for _, rv in pairs(data.raw["technology"]) do
  if rv.effects then
    for _, rev in pairs(rv.effects) do
      if rev.type == "unlock-recipe" then
        for wlk, wlv in pairs(GDIWresearch) do
          if rev.recipe == wlk then
            for _, newrecipe in ipairs(wlv) do
              table.insert(rv.effects,{type = "unlock-recipe", recipe = newrecipe})
            end
          end
        end
      end
    end
  end
end





for km, vm in pairs(data.raw.module) do
  if vm.name:find("productivity%-module") and vm.limitation then
    for _, recipe in ipairs(GDIWproductivity) do
      table.insert(vm.limitation, recipe)
    end
  end
end


