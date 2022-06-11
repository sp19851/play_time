Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

local QBCore = exports['qb-core']:GetCoreObject()
local inUIPage = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    --print('QBCore:Player:OnPlayerLoaded')
    TriggerServerEvent('play_time:server:start')
end)


RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    --print('QBCore:Player:OnPlayerUnload')
    TriggerServerEvent('play_time:server:stop')
end)

RegisterNetEvent('play_time:clitn:openUI', function(data)
    --print('data', json.encode(data))
    if not inUIPage then
        choosenCat = nil 
        choosenSubCat = nil 
        _category = {}
        SendNUIMessage({
            action = "open",
            players = data.players,
            fractions = data.fractions,
            gangs = data.gangs
            
        })
        SetNuiFocus(true, true)
        inUIPage = true
    end
end)


RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
    inUIPage = false
    
end)

