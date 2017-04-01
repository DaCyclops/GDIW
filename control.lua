local hideButton = true

function recheck_all_recipes(rf) 

      for _, research in pairs(rf.technologies) do
        if research.researched then
         if research.effects then
           for _, effect in pairs (research.effects) do
             if effect.type == "unlock-recipe" then
               rf.recipes[effect.recipe].enabled = true
             end
           end
         end
        end
      end

end

function checkPlayerForce(pli)
  if not global.gdiwforce then global.gdiwforce = {} end
  if not global.gdiwforce[game.players[pli].force.name] then
    global.gdiwforce[game.players[pli].force.name] = {input = false, output = false}
  end

end


function redraw_button(pli)
  checkPlayerForce(pli)
  if hideButton then return end  
  local pgt = game.players[pli].gui.top
  local fb = global.gdiwforce[game.players[pli].force.name]
  local bs = "NR"
  if fb.input == true and fb.output == true then
    bs = "BR"
  elseif fb.input == true and fb.output == false then
    bs = "IR"
  elseif fb.input == false and fb.output == true then
    bs = "OR"
  else
    bs = "NR"
  end
    if pgt.gdiw.gdiwsub then 
      pgt.gdiw.gdiwsub.gdiw_check_input.state = fb.input 
      pgt.gdiw.gdiwsub.gdiw_check_output.state = fb.output
    end
    pgt.gdiw.gdiwbf.gdiwbutton.style = string.sub(pgt.gdiw.gdiwbf.gdiwbutton.style.name, 1, -3)..bs
end

function createMainButton(pli)
  checkPlayerForce(pli) 
  if hideButton then return end  
  local pgt = game.players[pli].gui.top
  if not pgt.gdiw then 
    pgt.add{type = "flow", name = "gdiw", direction = "vertical"} 
    pgt.gdiw.add{type = "frame", name = "gdiwbf", style = "gdiw_button_frame"} 
    pgt.gdiw.gdiwbf.add{type = "button", name = "gdiwbutton", style = "gdiw_button_style_C-NR"} 
    redraw_button(pli)
  end
end


function onButtonClicked(event)
  local but = event.element
  if but.name == "gdiwbutton" then
    local pli = event.player_index
    local fb = global.gdiwforce[game.players[pli].force.name]
    local pgt = game.players[pli].gui.top
    if pgt.gdiw.gdiwsub then 
      pgt.gdiw.gdiwsub.destroy()
      pgt.gdiw.gdiwbf.gdiwbutton.style = string.sub(pgt.gdiw.gdiwbf.gdiwbutton.style.name, 1, -5).."C"..string.sub(pgt.gdiw.gdiwbf.gdiwbutton.style.name, -3, -1)
    else
      pgt.gdiw.add{type = "frame", name = "gdiwsub", direction = "vertical"} 
      pgt.gdiw.gdiwsub.add{type = "checkbox", name = "gdiw_check_input", caption = "Reverse Inputs", state = fb.input} 
      pgt.gdiw.gdiwsub.add{type = "checkbox", name = "gdiw_check_output", caption = "Reverse Outputs", state = fb.output} 
      pgt.gdiw.gdiwbf.gdiwbutton.style = string.sub(pgt.gdiw.gdiwbf.gdiwbutton.style.name, 1, -5).."O"..string.sub(pgt.gdiw.gdiwbf.gdiwbutton.style.name, -3, -1)
    end    
  end
end


local function onCheckedState(event)
  local cse = event.element
  if cse.name == "gdiw_check_input" or cse.name == "gdiw_check_output" then
    local pli = event.player_index
    local pfo = game.players[pli].force
    if not global.gdiwforce[pfo.name] then
      global.gdiwforce[pfo.name] = {input = false, output = false}
    end
    local fst = global.gdiwforce[pfo.name]
    if cse.name == "gdiw_check_input" then
      fst.input = cse.state
    end
    if cse.name == "gdiw_check_output" then
      fst.output = cse.state
    end    
    
    for i,_ in pairs (pfo.players) do
      redraw_button(i)
    end
    
  end
  
end


 -- Start OnLoad/OnInit/OnConfig events
script.on_configuration_changed( function(data)
  -- Do Any Mod Changes
     
  -- Setup for global list 
  -- wipe global list if any mod changes, not just GDIW   
  global.gdiwlist = {}
  if global.gdiwlist ~= nil then
    gdiwliststring = loadstring(game.entity_prototypes["gdiw_data_list_flying-text"].order)()
    global.gdiwlist = gdiwliststring
  end
    
   -- Do GDIW Mod added 
  if data.mod_changes ~= nil and data.mod_changes["GDIW"] ~= nil and data.mod_changes["GDIW"].old_version == nil then
    for _,force in pairs(game.forces) do
      force.reset_recipes()
      force.reset_technologies()
      
      recheck_all_recipes(force)
    end
    for idx, _ in pairs(game.players) do
			createMainButton(idx)
		end

  end 

   -- Do GDIW Mod updated or removed
  if data.mod_changes ~= nil and data.mod_changes["GDIW"] ~= nil and data.mod_changes["GDIW"].old_version ~= nil then
    for _,force in pairs(game.forces) do
      force.reset_recipes()
      force.reset_technologies()

      -- Re-disable all GDIW recipes (Useful when old save versions involved)
      for _, i in pairs(global.gdiwlist) do 
        for _, j in pairs(i) do
          force.recipes[j.name].enabled = false
        end
      end
      recheck_all_recipes(force)
    end      

    for idx, _ in pairs(game.players) do
			createMainButton(idx)
		end

	
  end
    


end)


script.on_init(function()
  -- Nothing to do now

end)   
  
script.on_load(function()
  --Nothing to Do Now  
  
end)
-- End OnLoad/OnInit/OnConfig events



local function onTick(event)
  if event.tick == 10 then
    
    for idx, _ in pairs(game.players) do
		 createMainButton(idx)
		end
  end
end

script.on_event(defines.events.on_tick,onTick)

script.on_event(defines.events.on_gui_checked_state_changed,onCheckedState)
script.on_event(defines.events.on_gui_click,onButtonClicked)
