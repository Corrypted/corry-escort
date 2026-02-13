lib.callback.register('corry_escort:server:escortPlayer', function(source, targetId, escort)
    local targetPed = GetPlayerPed(targetId)
    if not targetPed or targetPed == 0 then return end
    TriggerClientEvent('corry_escort:client:getEscorted', targetId, source, targetId, escort)
    return escort
end)

RegisterNetEvent('corry_escort:server:stopEscort', function(targetId)
    TriggerClientEvent('corry_escort:client:getEscorted', targetId, source, targetId, false)
end)