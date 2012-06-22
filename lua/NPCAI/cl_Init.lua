//File version 1.0

CreateClientConVar("NPC2_ai_Active", 1, false, true)
CreateClientConVar("NPC2_ai_Reuse", 1, false, true)
CreateClientConVar("NPC2_ai_Turn", 1, false, true)
CreateClientConVar("NPC2_ai_Manh", 0, false, true)
CreateClientConVar("NPC2_ai_Grenades", 1, false, true)
CreateClientConVar("NPC2_ai_ManhA", 2, false, true)
CreateClientConVar("NPC2_ai_GrenadesA", 5, false, true)
CreateClientConVar("NPC2_ai_SquadsA", 5, false, true)
CreateClientConVar("NPC2_ai_Squads", 1, false, true)
CreateClientConVar("NPC2_ai_SquadsP", 1, false, true)
CreateClientConVar("NPC2_ai_SquadsJ", 1500, false, true)
CreateClientConVar("NPC2_ai_SquadsF", 500, false, true)
CreateClientConVar("NPC2_ai_ChaseThink", 0.3, false, true)

/*-
AISetup.panel=nil
function AISetup.Build( panel )
panel:ClearControls()

  if !LocalPlayer():IsAdmin() then
  panel:AddControl( "Label", {Text = "You are not an Admin."})
  return
  end

  if !AISetup.panel then
  AISetup.panel=panel
  end
  
  panel:AddControl( "Label", {Text = "NPC AI addon Settings"})
  panel:AddControl( "CheckBox", { Label = "Activate/Disable AI", Command = "NPC2_ai_Active" })
  panel:AddControl( "CheckBox", { Label = "Reuse Array", Command = "NPC2_ai_Reuse" })
  panel:AddControl( "CheckBox", { Label = "Friendly fire on NPCs", Command = "NPC2_ai_Turn" })
  panel:AddControl( "Slider", { Label = "Next Think Time", Type	= "Float",Command = "NPC2_ai_ChaseThink", min = 0.1, max = 1 })
  panel:AddControl( "Label", {Text = "NPC Features"})
  panel:AddControl( "CheckBox", { Label = "Allow Metro Police Manhacks", Command = "NPC2_ai_Manh" })
  panel:AddControl( "Slider", { Label = "Amount of Manhacks", Command = "NPC2_ai_ManhA", min = 1, max = 10 })
  panel:AddControl( "CheckBox", { Label = "Allow Grenades", Command = "NPC2_ai_Grenades" })
  panel:AddControl( "Slider", { Label = "Amount of Grenades", Command = "NPC2_ai_GrenadesA", min = 1, max = 10 })
  panel:AddControl( "Label", {Text = "NPC Squads"})
  panel:AddControl( "CheckBox", { Label = "Allow Players to be Squad Leaders", Command = "NPC2_ai_SquadsP" })
  panel:AddControl( "CheckBox", { Label = "Allow Squads", Command = "NPC2_ai_Squads" })
  panel:AddControl( "Slider", { Label = "Max Members of a Squad", Command = "NPC2_ai_SquadsA", min = 1, max = 10 })
  panel:AddControl( "Slider", { Label = "Max Join Distance", Command = "NPC2_ai_SquadsJ", min = 50, max = 2000 })
  panel:AddControl( "Slider", { Label = "Max Follow Distance", Command = "NPC2_ai_SquadsF", min = 500, max = 2000 })
  panel:AddControl("Button", {Text = "Apply Settings", Command = "NPC2_ai_apply"})
  end
  
  function AISetup.npcmenuopen()
  if AISetup.panel then
  AISetup.Build(AISetup.panel)
  end
  end
  hook.Add("SpawnMenuOpen", "npcmenuopen", AISetup.npcmenuopen)

function ServerAI()
  spawnmenu.AddToolMenuOption( "Utilities", "AI", "NPC's AI Options", "NPC's AI Options", "", "", AISetup.Build )
end
hook.Add( "PopulateToolMenu", "AI_menu", ServerAI )
-*/