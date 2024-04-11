local QBCore = exports['qb-core']:GetCoreObject()

local timeout = false

CreateThread(function()
    local model = 's_m_y_cop_01'
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(1000) end

    local NPC = CreatePed(0, model, vector4(442.68, -981.93, 29.69, 95.4), 0.0, false, false)
    FreezeEntityPosition(NPC, true)
    SetEntityInvincible(NPC, true)
    SetBlockingOfNonTemporaryEvents(NPC, true)

    exports['qb-target']:AddTargetEntity(NPC, {
        options = {
        {
            type = 'client',
            event = 'edmNPCs:Menu',
            label = 'Miestný policajt',
            icon = 'fas fa-walking'
        }
        },
        distance = 1.5,
    })
end)

RegisterNetEvent('edmNPCs:Menu', function()
    exports['qb-menu']:openMenu({
        {
            header = 'Miestný policajt',
            icon = 'fas fa-walking',
            isMenuHeader = true,
        },
        {
            header = 'Zazvoniť na zvonček',
            txt = 'Jednotka sa Vám bude zachvíľu venovať..',
            icon = 'fas fa-bell',
            params = {
                event = 'edmNPCs:Dispatch',
                args = {}
            }
        },
        {
            header = 'Doklady',
            txt = 'Neviete, kde sa vybavujú doklady?',
            icon = 'fas fa-id-card',
            params = {
                event = '',
                args = {}
            }
        },
    })
end)

function Timer()
    Citizen.SetTimeout(300000, function()
        timeout = false
    end)
end

RegisterNetEvent('edmNPCs:Dispatch', function()
    if timeout == true then
        QBCore.Functions.Notify({text = 'Počkaj chvíľu, daj mu pokoj..', caption = 'Miestný policajt'}, 'police', 5000)
    else
        timeout = true
        Timer()
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = {'police'}, 
            coords = vector3(442.68, -981.93, 29.69),
            title = 'Recepcia | 10-65',
            message = ''..data.sex..' potrebuje pomôcť na recepcií na stanici Mission Row HQ.', 
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = 66, 
                scale = 0.8, 
                colour = 83,
                flashes = false, 
                text = 'Recepcia | 10-65',
                time = 3,
                radius = 0,
            }
        })
    end
end)