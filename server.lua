local function runChecks()
    local resourceList = {}
    local approvedList = {}
    for i = 0, GetNumResources() - 1 do
        local resource_name = GetResourceByFindIndex(i)
        if resource_name and GetResourceState(resource_name) == "started" then
            table.insert(resourceList, resource_name)
        end
    end

    PerformHttpRequest("https://raw.githubusercontent.com/Mustachedom/solaire-approval/refs/heads/main/list.lua", function(status,text,err)
        local chunk, loadErr = load(text)
        if chunk then
            local success, result = pcall(chunk)
            if success and type(result) == "table" then
                approvedList = result
                print("^2Successfully loaded approved resource list.^0")
            else
                print("^1ERROR: Failed to execute Lua chunk: " .. tostring(result) .. "^0")
            end
        else
            print("^1ERROR: Failed to load Lua chunk: " .. tostring(loadErr) .. "^0")
        end
    end)

    repeat
        Wait(10)
    until #approvedList > 0

    for _, resourceName in ipairs(resourceList) do
        if ps.tableContains(approvedList, resourceName) then
            print('^2 RESOURCE ' .. resourceName .. ' HAS SOLAIRES SEAL OF APPROVAL ^0')
        else
            print('^1 RESOURCE ' .. resourceName .. ' DOES NOT HAVE SOLAIRES SEAL OF APPROVAL ^0')
        end
    end
end

Wait(1000 * 60 * 0.2)
runChecks()
