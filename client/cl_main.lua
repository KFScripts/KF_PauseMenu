ESX = Config.Framework == 'esx' and exports['es_extended']:getSharedObject() or nil
QBCore = Config.Framework == 'qbcore' and exports['qb-core']:GetCoreObject() or nil

isNuiReady = false
inPauseMenu = false
playerData = {}

if Config.EnableCommand then
  RegisterCommand(Config.Command, function()
    PauseMenu()
  end)
  
  TriggerEvent('chat:removeSuggestion', '/openpausemenu')

  if Config.EnableKeyMapping then
    RegisterKeyMapping(Config.Command, 'Open Pause Menu', 'keyboard', Config.KeyMapping)
  end
end


function PauseMenu()
  if IsPauseMenuActive() then 
    SetPauseMenuActive(true)
    SetNuiFocus(true, true)
    ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_LANDING_MENU'), 0, -1)
    return
  end

  if IsNuiFocused() then 
    return
  end

  if not isNuiReady then
    return
  end

  if inPauseMenu then
    SendNUIMessage({
      type = "close"
    })
    return
  end

  local playerData = lib.callback.await('KF_PauseMenu:GetPlayerData', false)
  inPauseMenu = true
  hasPlayerData = true
  SendNUIMessage({
    type = "open",
    data = playerData
  })
  SetNuiFocus(true, true)
  TriggerEvent('KF_PauseMenu:OpenPauseMenu', playerData)
  TriggerScreenblurFadeIn(5000)
end

RegisterNUICallback('ready', function(data, cb)
  isNuiReady = true
  TriggerEvent('KF_PauseMenu:NuiReady')
  cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
  inPauseMenu = false
  SetNuiFocus(false, false)
  SendNUIMessage({
    type = "close"
  })
  
  TriggerScreenblurFadeOut(5000)
  TriggerEvent('KF_PauseMenu:OnClose')
end)

RegisterNUICallback('settings', function()
  ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_LANDING_MENU'), 1, -1) 
  TriggerScreenblurFadeOut(5000)

  SetNuiFocus(false, false)
  TriggerEvent('KF_PauseMenu:OnButtonClicked', 'settings')

  SendNUIMessage({
    type = "close"
  })

  inPauseMenu = false
end)

RegisterNUICallback('exit', function()
  TriggerServerEvent('quitServer')
  SetNuiFocus(false, false)
end)

RegisterNUICallback('map', function()
  TriggerScreenblurFadeOut(5000)
  SetNuiFocus(false, false)

  TriggerEvent('KF_PauseMenu:OnButtonClicked', 'map')

  SendNUIMessage({
    type = "close"
  })
  inPauseMenu = false

  ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'), 1,- 1) 
end)

CreateThread(function()
  while true do 
    SetPauseMenuActive(false) 
    Citizen.Wait(Config.PauseMenuTick)
    if IsPauseMenuActive() then
      SetNuiFocus(false, false)
    end
  end
end)

RegisterNUICallback('GetDiscordAvatar', function(data, cb)
  local discord_avatar = lib.callback.await('KF_PauseMenu:GetDiscordAvatar', false)
  if not discord_avatar then
    return
  end
  cb({
    avatar = discord_avatar.avatar,
    discord_id = discord_avatar.discord_id,
  })
end)
