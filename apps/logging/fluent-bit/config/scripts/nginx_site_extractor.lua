
function extract_site(tag, timestamp, record)
    new_record = record
    
    if string.match(record["file"], "_ssl_") then
        new_record["nginx_ssl"] = 1
    else
        new_record["nginx_ssl"] = 0
    end
    new_record["nginx_site"] = string.gsub(record["file"], ".*/([^_]+)_.*", "%1")

    return 1, timestamp, new_record
end
