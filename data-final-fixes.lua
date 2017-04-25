

GDIWworklistIn = {}
GDIWworklistOut = {}
GDIWworklistBoth = {}
GDIWproductivity = {}
GDIWresearch = {}
GDIWlist = {lout = {}, lin = {}, lboth = {}}


-- function for doing prototypes
function GDIWdoprototype(GDIWwl, isIn, isOut )
  for _, vin in pairs(GDIWwl) do
    -- Determine new names, suffixes
    if isIn and isOut then
    suffix = "GDIW-BR"
    ordersuffix = "-o3"
    elseif isIn then
    suffix = "GDIW-IR"
    ordersuffix = "-o2"
    elseif isOut then
    suffix = "GDIW-OR"
    ordersuffix = "-o1"
    else
    suffix = "GDIW-AR"
    ordersuffix = "-o4"
    end
    newName = vin.r .. "-" .. suffix
    -- copy table
    data.raw.recipe[newName] = util.table.deepcopy(data.raw.recipe[vin.r])
    
    --Logging Code (Dev Only)
    --log("-## Creating "..newName)
    
    vro = data.raw.recipe[vin.r]
    vrn = data.raw.recipe[newName]
    -- fix names (and make enabled for testing)  
    vrn.name = newName
    --vrn.enabled = true
    -- Resort by Normal, Output, Input, Both
    if vro.order then
      vrn.order = vro.order .. ordersuffix
      else
      vrn.order = newName .. ordersuffix
    end
    
    -- Result Count (for naming)
    rc = 0
    if vrn.results then
      for _, rcv in pairs(vrn.results) do
        rc = rc + 1
      end
    end
    
    -- calculate localised name
    if vro.localised_name then
    vrn.localised_name = util.table.deepcopy(vro.localised_name)
    elseif rc > 1 then
    vrn.localised_name = {"recipe-name." .. vro.name}
    else
   
    end
    
    --table.insert(vrn.localised_name,{"gdiw-tags." .. suffix})  
    
    
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
    for _, vri in pairs(vrn.ingredients) do
      --clear sortorder
      vri.sortorder = nil
    end  
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
    for _, vrr in pairs(vrn.results) do
      --clear sortorder
      vrr.sortorder = nil
    end
  end
  
    newicons = {}
    --grab old icon(s)
    if vro.icon then
      table.insert(newicons,{icon=vro.icon})
    elseif vro.icons then
      newicons = util.table.deepcopy(vro.icons)
    else
      -- Look through results for an icon
      local resultList = {}
      if vrn.results then -- Do we have a list of results?
        resultList = vrn.results -- Use it as-is
      elseif vrn.result then -- Is there a single result string?
        -- Check the raw table for an object of the given name and fake a sparse result object
        if data.raw.item[vrn.result] then
          table.insert(resultList, {type="item", name=vrn.result})
        elseif data.raw.fluid[vrn.result] then
          table.insert(resultList, {type="fluid", name=vrn.result})
        end
      end
      -- Now iterate over the list of results, until we either find an icon or checked all.
      for _, result in pairs(resultList) do
        if result.type == "item" or result.type == "fluid" then 
          local rawResult = data.raw[result.type][result.name]
          if rawResult.icon then
            table.insert(newicons,{icon=rawResult.icon})
          elseif rawResult.icons then
            newicons = util.table.deepcopy(rawResult.icons)
          end
          if #newicons > 0 then break end
        end
      end
    end
    if #newicons == 0 then
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

    if isIn and isOut then
      table.insert(GDIWlist.lboth, {name=newName, orig=vin.r})
      elseif isIn then
      table.insert(GDIWlist.lin, {name=newName, orig=vin.r})
      elseif isOut then
      table.insert(GDIWlist.lout, {name=newName, orig=vin.r})
    end

  
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
      if vm.effect.productivity and vm.limitation then
        for _, prr in pairs(vm.limitation) do
          if prr == kr then thisProduc = true end--And mark them as having it
        end
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

-- Old Productivity Limitation Code
-- for km, vm in pairs(data.raw.module) do
  -- if vm.name:find("productivity%-module") and vm.limitation then
    -- for _, recipe in ipairs(GDIWproductivity) do
      -- table.insert(vm.limitation, recipe)
    -- end
  -- end
-- end

for km, vm in pairs(data.raw.module) do
  if vm.effect.productivity and vm.limitation then
    for _, recipe in ipairs(GDIWproductivity) do
      table.insert(vm.limitation, recipe)
    end
  end
end


-- Output list data to Control.lua (thanks data-raw-prototypes)
--log("GDIWlist Length: "..string.len(serpent.dump(GDIWlist)))
--log(serpent.dump(GDIWlist))
--data:extend({{
--	type = "flying-text",
--	name = "gdiw_data_list_flying-text",
--	time_to_live = 0,
--	speed = 1,
--	resource_category = serpent.dump(GDIWlist)
--}})

