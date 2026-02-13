local isEscorting = false
local isEscorted = false
local escorter = escorter
local escorted = escorted

local function escortPlayer()
    local targetPlayer = lib.getClosestPlayer(GetEntityCoords(PlayerPedId()), config.maxDistance, false)
    if not targetPlayer then return lib.notify({ type = 'error', description = 'No one nearby' }) end
    local targetId = GetPlayerServerId(targetPlayer)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
    if IsPedInAnyVehicle(targetPed, false) then return lib.notify({ type = 'error', description = 'Person is in a vehicle' }) end
    if isEscorted then return end
    if targetPlayer then
        lib.callback('corry_escort:server:escortPlayer', false, function(escort)
            if escort then
                isEscorting = true
                escorter = PlayerId()
                escorted = targetId
                lib.requestAnimDict("amb@world_human_drinking@coffee@female@base")
                TaskPlayAnim(cache.ped, "amb@world_human_drinking@coffee@female@base", "base", 8.0, 8.0, -1, 50, 0, false, false, false)
                CreateThread(function()
                    while isEscorting do
                        Wait(0)
                        if not IsEntityPlayingAnim(cache.ped, "amb@world_human_drinking@coffee@female@base", "base", 3) then
                            TaskPlayAnim(cache.ped, "amb@world_human_drinking@coffee@female@base", "base", 8.0, 8.0, -1, 50, 0, false, false, false)
                        end
                        if (IsPedRagdoll(cache.ped) and config.prevent.ragdoll) or (IsPedSprinting(cache.ped) and config.prevent.running) then
                            isEscorting = false
                            StopAnimTask(cache.ped, "amb@world_human_drinking@coffee@female@base", "base", -4.0)
                            TriggerServerEvent('corry_escort:server:stopEscort', targetId)
                            isEscorting = false
                        end
                    end
                end)
            else
                isEscorting = false
                StopAnimTask(cache.ped, "amb@world_human_drinking@coffee@female@base", "base", -4.0)
                TriggerServerEvent('corry_escort:server:stopEscort', targetId)
                Wait(500)
                StopAnimTask(cache.ped, "amb@world_human_drinking@coffee@female@base", "base", -4.0)
            end
        end, targetId, not isEscorting)
    end
end

exports('escortPlayer', escortPlayer)

RegisterNetEvent('corry_escort:client:getEscorted', function(escorter, escorted, escort)
    local dict = 'anim@move_m@prisoner_cuffed'
    local dict2 = 'anim@move_m@trash'
    escorter = escorter
    escorted = escorted

    if escort then
        isEscorted = true
        AttachEntityToEntity(GetPlayerPed(GetPlayerFromServerId(escorted)), GetPlayerPed(GetPlayerFromServerId(escorter)), 11816, 0.38, 0.4, 0.0, 0.0, 0.0, 0.0, false, false, false, true, 2, true)
    else
        isEscorted = false
        DetachEntity(GetPlayerPed(GetPlayerFromServerId(escorted)), true, false)
        if IsEntityPlayingAnim(GetPlayerPed(GetPlayerFromServerId(escorted)), dict, "walk", 3) then
            StopAnimTask(GetPlayerPed(GetPlayerFromServerId(escorted)), dict, "walk", -4.0)
        end
    end
    CreateThread(function()
        while isEscorted do
            local player = GetPlayerFromServerId(escorter)
            local ped = player > 0 and GetPlayerPed(player)
            if not ped then break end
            if IsPedWalking(ped) then
                if not IsEntityPlayingAnim(GetPlayerPed(GetPlayerFromServerId(escorted)), dict, "walk", 3) then
                    lib.requestAnimDict(dict)
                    TaskPlayAnim(GetPlayerPed(GetPlayerFromServerId(escorted)), dict, "walk", 8.0, 8.0, -1, 1, 0, false, false, false)
                end
            else
                if IsEntityPlayingAnim(GetPlayerPed(GetPlayerFromServerId(escorted)), dict, "walk", 3) then
                    StopAnimTask(GetPlayerPed(GetPlayerFromServerId(escorted)), dict, "walk", -4.0)
                end
            end
            Wait(0)
        end
    end)
end)

lib.onCache('vehicle', function()
    if isEscorting and config.prevent.vehicle then
        isEscorting = false
        StopAnimTask(cache.ped, "amb@world_human_drinking@coffee@female@base", "base", -4.0)
        TriggerServerEvent('corry_escort:server:stopEscort', escorted)
    end
end)


RegisterCommand(config.command.commandName, function()
    if not config.command.useCommand then return end
    escortPlayer()
end)

local keybind = lib.addKeybind({
    name = 'escort',
    description = 'Escort the closest player',
    defaultKey = config.keybind.key,
    onPressed = escortPlayer,
    disabled = function()
        if not config.keybind.useKeybind then print('false') return true end
        if IsPedRagdoll(PlayerPedId()) then print('ragdoll') return true end
        if isEscorting then print('escorting') return true end
        if isEscorted then print('escorted') return true end
        return false
    end,
})