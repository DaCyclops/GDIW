
for km, vm in pairs(data.raw.module) do
  if vm.name:find("productivity%-module") and vm.limitation then
    for _, recipe in ipairs({"basic-oil-processing-GDIW-3","advanced-oil-processing-GDIW","advanced-oil-processing-GDIW-2","advanced-oil-processing-GDIW-3","heavy-oil-cracking-GDIW","light-oil-cracking-GDIW","sulfur-GDIW"}) do
      table.insert(vm.limitation, recipe)
    end

    if data.raw["recipe"]["bob-oil-processing"] then
      table.insert(vm.limitation, "bob-oil-processing-GDIW")
    end
  end
end
