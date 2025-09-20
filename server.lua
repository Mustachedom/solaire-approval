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
        local chunk = load(text)
        if chunk then
            local success, result = pcall(chunk)
            if success and type(result) == "table" then
                approvedList = result
            end
        end
    end)

    repeat
        Wait(10)
    until #approvedList > 0

    local function tableContains(tbl, val)
        for _, v in ipairs(tbl) do
            if v == val then
                return true
            end
        end
        return false
    end
    for _, resourceName in ipairs(resourceList) do
        if tableContains(approvedList, resourceName) then
            print('^2 RESOURCE ' .. resourceName .. ' HAS SOLAIRES SEAL OF APPROVAL ^0')
        else
            print('^1 RESOURCE ' .. resourceName .. ' DOES NOT HAVE SOLAIRES SEAL OF APPROVAL ^0')
        end
    end
end

Wait(1000 * 60 * 4)
runChecks()
