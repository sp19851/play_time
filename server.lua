
local QBCore = exports['qb-core']:GetCoreObject()
local startTime = {}

local function updatetime(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    --local identifier = QBCore.Functions.GetIdentifier(src, 'license')
    local gametime = os.time() - startTime[src].entertime
    print('before sql',  GetPlayerName(src), startTime[src].timeingame, gametime)
    exports.oxmysql:insert('INSERT INTO play_time (citizenid, nick, license, timeingame, lastupdate) VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE citizenid = ?, nick= ?, license = ?, timeingame = ?, lastupdate = ?', {
        Player.PlayerData.citizenid,
        GetPlayerName(src),
        startTime[src].identifier,
        startTime[src].timeingame + gametime,
        os.time(),
        Player.PlayerData.citizenid,
        GetPlayerName(src),
        startTime[src].identifier,
        startTime[src].timeingame + gametime,
        os.time()
    })
    startTime[src] = nil
end

local function getData(source)
    local src = source
    local t = {}
    --local times = MySQL.prepare.await('SELECT * FROM play_time', {})
    local times = exports.oxmysql:fetchSync('SELECT * FROM play_time', {})
    --print('times', json.encode(times))
    if times ~= nil then
        for index, value in pairs(times) do
            --print('*', index, json.encode(value))
            local _citizenid = value.citizenid
            local ply = exports.oxmysql:fetchSync('SELECT * FROM players where citizenid = ?', {_citizenid})
            if ply ~= nil then
                local charinfo = json.decode(ply[1].charinfo)
                --print('ply', json.encode(ply.charinfo))
                --local charinfoT = json.decode(ply.charinfo)
                local name = charinfo.lastname .." "..charinfo.firstname
                local jobT = json.decode(ply[1].job)
                local job = jobT.name
                local isbossJob = jobT.isboss
                local gangT = json.decode(ply[1].gang)
                local gang = gangT.name
                local isbossGang = gangT.isboss
                --print(name, job, gang, isbossGang, isbossJob)
                --local tt = math.ceil(value.lastupdate)
                --print('date', value.lastupdate, os.date('%c', tt), os.date('%c', os.time()))
                t[#t+1] = {
                    id = #t+1,
                    citizenid = _citizenid,
                    name = name,
                    job = job,
                    isboss = isbossJob or isbossGang,
                    gang = gang,
                    timeingame = QBCore.Shared.Round(value.timeingame/3600, 2),
                    lastenter = os.date('%c',value.lastupdate)
                }
            end
        end

        local _jobs = {}
        for i, v in pairs(QBCore.Shared.Jobs) do
            _jobs[#_jobs+1] = {
                id = #_jobs+1,
                name = i,
                label = v.label,
               
            }
        end

        local _gangs = {}
        for i, v in pairs(QBCore.Shared.Gangs) do
            _gangs[#_gangs+1] = {
                id = #_gangs+1,
                name = i,
                label = v.label,
               
            }
        end
            
        local data = {}
        data = {
            players = t,
            fractions = _jobs,
            gangs = _gangs
        }
        --print('t', json.encode(t))
        TriggerClientEvent('play_time:clitn:openUI', source, data)
    end

end

AddEventHandler('playerDropped', function(reason)
    local src = source
    updatetime(src)
end)

--[[RegisterServerEvent('play_time:server:stop')
AddEventHandler('play_time:server:stop', function()
    local src = source
    --print('play_time:server:stop')
    updatetime(src)
end)]]
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    local src = source
    --print('play_time:server:stop')
    updatetime(src)
end)

RegisterServerEvent('play_time:server:start')
AddEventHandler('play_time:server:start', function()
   
    local src = source
   
    local Player = QBCore.Functions.GetPlayer(src)
    local identifier = QBCore.Functions.GetIdentifier(src, 'license')
    if startTime[src] == nil then
        local time = MySQL.prepare.await('SELECT * FROM play_time where citizenid = ?', { Player.PlayerData.citizenid })
        
        --print('times', json.encode(times), times)
        --print('timeingame', os.date('%X', time.timeingame))

        if time and time.timeingame> 0 then
            startTime[src] = {
                src = scr,
                identifier = identifier,
                entertime = os.time(),
                timeingame = time.timeingame,
                lastenter = time.lastenter
            }
        else
            startTime[src] = {
                src = scr,
                identifier = identifier,
                entertime = os.time(),
                timeingame = 0,
                lastenter = os.time(),
            }
        end
    else
        startTime[src] = {
            src = scr,
            identifier = identifier,
            entertime = os.time(),
            timeingame = startTime[src].timeingame,
            lastenter = os.time(),
        }
    end
    --print('play_time:server:start', startTime[src].time)
    --print('play_time:server:start',  os.date('%c', startTime[src].time))
    print('startTime', GetPlayerName(src), identifier, Player.PlayerData.citizenid, json.encode(startTime))
end)



QBCore.Commands.Add('play_time', 'Players playing time (Admin Only)', {}, false, function(source)
    local src = source
    getData(src)
end, 'curator')