--Button display code
--not used currently

function checkPlayerForce(pli)
  if not global.gdiwforce then global.gdiwforce = {} end
  if not global.gdiwforce[game.players[pli].force.name] then
    global.gdiwforce[game.players[pli].force.name] = {input = false, output = false}
  end

end

function redraw_button(pli)
  checkPlayerForce(pli)
  
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