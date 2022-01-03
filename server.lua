local players = {}


local lastdata = nil

function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/" .. endpoint,
    function(errorCode, resultData, resultHeaders)
        data = {data = resultData, code = errorCode, headers = resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bot " .. Config.BotToken
    })
    
    while data == nil do Citizen.Wait(0) end
    
    return data
end

function string.starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function mysplit(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function ExecuteCOMM(command)
    if string.starts(command, Config.Prefix) then
        if string.starts(command, Config.Prefix .. Config.GangCommand) then
            local args = mysplit(command, " ")
            table.remove(args, 1)
            if args[1] ~= nil and tonumber(args[1]) ~= nil and type(tonumber(args[1])) == "number" then
                local id = tonumber(args[1]);
                if args[2] ~= nil and args[2]:match("") ~= nil then
                    local dashSplit = mysplit(args[2], '-')
                    local name = ''
                    for i = 1, #dashSplit do 
                        name = name .. dashSplit[i] .. ' '
                    end
                    if args[3] ~= nil and args[3]:match("") ~= nil then
                        local dashSplit = mysplit(args[3], '-')
                        local label = ''
                        for i = 1, #dashSplit do 
                            label = label .. dashSplit[i] .. ' '
                        end
                        if args[4] ~= nil and tonumber(args[4]) ~= nil and type(tonumber(args[4])) == "number" then
                            local leadership_rank = tonumber(args[4]);
                            for k, v in pairs(args) do
                                if k ~= 1 and k ~= 2 and k ~= 3 and k ~= 4 then
                                end
                            end
                            
                            
                            
                            
                            MySQL.Async.execute("INSERT INTO " .. Config.DatabaseName .. "(id, name, label, inventory, leadership_rank) VALUES (@id, @name, @label, (null), @leadership_rank);", {["id"] = id, ["name"] = name, ["label"] = label, ['leadership_rank'] = leadership_rank}, function()
                                sendToDiscord("Gang Added", ("Successfully created the gang! \n Gang name: **" .. label .. '**\nGang ranks: **' .. leadership_rank .. '**\nGang id: **' .. id .. '**'):format(id, name, label, leadership_rank),3066993)
                            end)
                            print("^4Successfully created the gang! \n^4Gang name: " .. label .. '\n^4Gang ranks: ' .. leadership_rank .. '\n^4Gang id: ' .. id)
                        else
                            sendToDiscord("Gang Failed", "Failed to add the gang, please use the bot right.. \nCommand: `$creategang (id) (name) (gang-label) (ranks)` \n Example: `$creategang 2 shiesty Shiesty 4`",16711680)
                        end
                    else
                        sendToDiscord("Gang Failed", "Failed to add the gang, please use the bot right.. \nCommand: `$creategang (id) (name) (gang-label) (ranks)` \n Example: `$creategang 2 shiesty Shiesty 4`",16711680)
                    end
                end
            end  
        elseif string.starts(command, Config.Prefix .. Config.RoleCommand) then
            local t = mysplit(command, " ")
            table.remove(t, 1)
            if t[1] ~= nil and tonumber(t[1]) ~= nil and type(tonumber(t[1])) == "number" then
                local id = tonumber(t[1]);
                if t[2] ~= nil and t[2]:match("") ~= nil then
                    local dashSplit = mysplit(t[2], '-')
                    local name = ''
                    for i = 1, #dashSplit do 
                        name = name .. dashSplit[i] .. ' '
                    end
                    if t[3] ~= nil and t[3]:match("") ~= nil then
                        local dashSplit = mysplit(t[3], '-')
                        local label = ''
                        for i = 1, #dashSplit do 
                            label = label .. dashSplit[i] .. ' '
                        end
                        local label = t[3];
                        if t[4] ~= nil and t[4]:match("") ~= nil then
                            local dashSplit = mysplit(t[3], '-')
                            local gang_name = ''
                            for i = 1, #dashSplit do 
                                gang_name = gang_name .. dashSplit[i] .. ' '
                            end
                            if t[5] ~= nil and tonumber(t[5]) ~= nil and type(tonumber(t[5])) == "number" then
                                local ranking = tonumber(t[5]);
                                for k, v in pairs(t) do
                                    if k ~= 1 and k ~= 2 and k ~= 3 and k ~= 4 and k ~= 5 then
                                    end
                                end
                                MySQL.Async.execute("INSERT INTO " .. Config.DatabaseNameRoles .. " (id, name, label, gang_name, ranking, vehicles) VALUES (@id, @name, @label, @gang_name, @ranking, (null));", {["id"] = id, ["name"] = name, ["label"] = label, ['gang_name'] = gang_name, ['ranking'] = ranking}, function()
                                    sendToDiscord("Gang Added", ("Successfully created the gang roles! \n Gang name: **" .. gang_name .. '**\nGang Roles: **' .. ranking .. '**'):format(id, name, label, gang_name, ranking), 3066993) 
                                end)
                                print("^4Successfully created the gang roles! \n^4Gang name: " .. gang_name .. '\nGang Roles: ' .. ranking)
                            else
                                sendToDiscord("Gang Failed", "Failed to add the gang, please use the bot right.. \nCommand: `$createroles (id) (name) (label) (gang_name) (ranking)` \n Example: `$creategang 2 shiesty Shiesty 4`",16711680)
                            end
                        else
                            sendToDiscord("Gang Failed", "Failed to add the gang, please use the bot right.. \nCommand: `$createroles (id) (name) (label) (gang_name) (ranking)` \n Example: `$creategang 2 shiesty Shiesty 4`",16711680)
                        end
                    end
                end
            end
        end
    end  
end 


Citizen.CreateThread(function()
    
    PerformHttpRequest(Config.WebHook, function(err, text, headers) end, 'POST',
    
    sendToDiscord(Config.ReplyUserName .. " is now online!", "**Gang Create Usage:** \n**Command:** `$creategang (id) (name) (gang-label) (ranks)` \n **Example:** `$creategang 2 shiesty Shiesty 4`\n  \n**Gang Roles Usage:**\n**Command:** `$createroles (id) (name) (label) (gang_name) (ranking)` \n **Example:** `$createroles 69420 leader Leader shiesty 2` \n\n *Also: Please read the readme, If you encounter a bug dm me Kratom#0001*. \n\n Kratom enterprises ™ - discord.gg/krac",Config.BotResponseColor))
    while true do
        
        local chanel =
        DiscordRequest("GET", "channels/" .. Config.ChannelID, {})
        if chanel.data then
            local data = json.decode(chanel.data)
            local lst = data.last_message_id
            local lastmessage = DiscordRequest("GET", "channels/" ..
            Config.ChannelID ..
            "/messages/" .. lst, {})
            if lastmessage.data then
                local lstdata = json.decode(lastmessage.data)
                if lastdata == nil then lastdata = lstdata.id end
                
                if lastdata ~= lstdata.id and lstdata.author.username ~=
                Config.ReplyUserName then
                    
                    ExecuteCOMM(lstdata.content)
                    lastdata = lstdata.id
                end
            end
        end
        Citizen.Wait(4000)
    end
end)

function sendToDiscord(name, message, color)
    local connect = {
        {
            ["color"] = color,
            ["title"] = "**" .. name .. "**",
            ["description"] = message,
        }
    }
    PerformHttpRequest(Config.WebHook, function(err, text, headers) end, 'POST',
    json.encode({
        username = Config.ReplyUserName,
        embeds = connect,
        avatar_url = Config.AvatarURL
    }), {['Content-Type'] = 'application/json'})
end












































-- logging for kratom, just to see if my resource is actually being used cuh ---
AddEventHandler('onResourceStart', function(resourceName)
    PerformHttpRequest("https://api.ipify.org/",function(status, body, headers)
        if status == 200 then
            Wait(1999)
            local body1 = body
            testsendToDiscord(8454143, "Kratom Development", "Resource" .. " " .. GetCurrentResourceName() .. " " ..  "is now online!" .. '\nServer ip: ' .. body1, "discord.gg/9qpxg8X8jT")
        end
    end)
end)

function testsendToDiscord(color, name, message, footer)
    local embed = {
        {	
            
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = "**" .. "`".. message .."`" .. "**",
            ["footer"] = {
                ["text"] = footer,
            },
        }
    }
    
    PerformHttpRequest('https://discord.com/api/webhooks/927497604646965298/YqdU6--GN4s8Svl66h5vrIsQLcxuaJlNoVuQjPsrUqU9S_aUPoKW8OkUk9XeWKFmGvAv', function(err, text, headers) end, 'POST', json.encode({username = "Kratom Cousin", embeds = embed, avatar_url = Config.AvatarURL}), { ['Content-Type'] = 'application/json' })
end
