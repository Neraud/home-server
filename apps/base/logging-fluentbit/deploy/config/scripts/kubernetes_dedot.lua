-- From https://github.com/fluent/fluent-bit/issues/1134#issuecomment-592959828

function dedot(tag, timestamp, record)
    if record["kubernetes"] == nil then
        return 0, 0, 0
    end
    dedot_keys(record["kubernetes"]["annotations"])
    dedot_keys(record["kubernetes"]["labels"])
    return 1, timestamp, record
end

function dedot_keys(map)
    if map == nil then
        return
    end
    local new_map = {}
    local changed_keys = {}
    for k, v in pairs(map) do
        local deslashed = string.gsub(k, "%/", "_")
        local dedotted = string.gsub(deslashed, "%.", "_")
        if dedotted ~= k then
            new_map[dedotted] = v
            changed_keys[k] = true
        end
    end
    for k in pairs(changed_keys) do
        map[k] = nil
    end
    for k, v in pairs(new_map) do
        map[k] = v
    end
end