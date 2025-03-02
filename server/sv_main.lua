ESX = Config.Framework == 'esx' and exports['es_extended']:getSharedObject() or nil
QBCore = Config.Framework == 'qbcore' and exports['qb-core']:GetCoreObject() or nil

if ESX == nil and QBCore == nil then
  print('^1[ERROR]^1: Framework not set or not found. Please check your config.lua file. Current Config.Framework: ' .. tostring(Config.Framework) .. '^7')
end

lib.callback.register('KF_PauseMenu:GetPlayerData', function(src)
  if Config.Framework == 'esx' then
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier

    local playerData = {
      ['playerJob'] = Config.GetJob and Config.GetJob(src) or nil,
      ['playerJob2'] = Config.GetJob2 and Config.GetJob2(src) or nil,
      ['playerName'] = xPlayer.getName(),
      ['citizenId'] = Config.GetPlayerIdentifier(src),
      ['onlinePlayers'] = #ESX.GetPlayers(),
    }

    return playerData
  elseif Config.Framework == 'qbcore' then
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local identifier = xPlayer.PlayerData.citizenid

    local playerData = {
      ['playerJob'] = Config.GetJob and Config.GetJob(src) or nil,
      ['playerJob2'] = Config.GetJob2 and Config.GetJob2(src) or nil,
      ['playerName'] = xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname,
      ['citizenId'] = Config.GetPlayerIdentifier(src),
      ['onlinePlayers'] = #QBCore.Functions.GetPlayers(),
    }

    return playerData
  end
end)

function GetDiscordID(src)
  local identifiers = GetPlayerIdentifiers(src)
  local discord = nil

  for i = 1, #identifiers do
    if string.match(identifiers[i], 'discord:') then
      discord = identifiers[i]
      discord = string.gsub(discord, 'discord:', '')
      break
    end
  end

  return discord
end

function RequestDiscord(discord_id)
  local request_url = 'https://discord.com/api/v10/users/' .. discord_id
  local prom = promise:new()
  PerformHttpRequest(request_url, function(statusCode, response, headers)
    local data = response and json.decode(response) or nil
    prom:resolve(data)
  end, 'GET', '', { 
    ['Authorization'] = 'Bot ' .. Config.BotToken 
  })
  return Citizen.Await(prom)
end

lib.callback.register('KF_PauseMenu:GetDiscordAvatar', function(src)
  local discord_id = GetDiscordID(src)
  if not discord_id then return nil end
  local response = RequestDiscord(discord_id)
  if not response then 
    return { 
      avatar = nil,
      discord_id = discord_id
    }
  end
  
  return {
    avatar = response.avatar or nil,
    discord_id = discord_id
  }
end)
  
function milliseconds_to_date(ms)
  local timestamp = math.floor(ms / 1000)
  local date_string = os.date("%d/%m/%Y %H:%M:%S", timestamp)
  return date_string
end

RegisterServerEvent('quitServer')
AddEventHandler('quitServer', function()
  local src = source
  Config.ExitFunction(src)
end)

