local function runChecks()
    local resourceList = {}
    local approvedList
    PerformHttpRequestAwait("https://raw.githubusercontent.com/SolaireGaming/approved-resources/main/approved-resources.json", function(err, text, headers)
        if err == 200 then
            return json.decode(text)
        else
            print("^1ERROR: Unable to fetch approved resources list. Status code: " .. tostring(err) .. "^0")
            return {}
        end
    end)

    for i = 0, GetNumResources(), 1 do
      local resource_name = GetResourceByFindIndex(i)
      if resource_name and GetResourceState(resource_name) == "started" then
        table.insert(resourceList, resource_name)
      end
    end
    for k, v in pairs(resourceList) do
        if ps.tableContains(approvedList, v) then
            print('^2 RESOURCE ' .. v .. ' HAS SOLAIRES SEAL OF APPROVAL ^0')
        else
            print('^1 RESOURCE ' .. v .. ' DOES NOT HAVE SOLAIRES SEAL OF APPROVAL ^0')
        end
    end
    return resourceList
end

runChecks()