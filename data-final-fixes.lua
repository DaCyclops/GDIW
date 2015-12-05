
for km, vm in pairs(data.raw.module) do
  if vm.name:find("productivity%-module") and vm.limitation then
    for _, recipe in ipairs({"advanced-oil-processing-GDIW","heavy-oil-cracking-GDIW","light-oil-cracking-GDIW","sulfur-GDIW"}) do
      table.insert(vm.limitation, recipe)
    end
  end
end
