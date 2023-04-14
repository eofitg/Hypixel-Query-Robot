


#uuid .*|#uuid
--lua编程
function main(m)
    --
    -- 查询玩家uuid
    --
    -- 外挂lua包存储路径
    package.path = "/storage/emulated/0/luaPackages/?.lua;" .. package.path
    -- 必需依赖
    local json = require "json"
    --
    n       = m
    msg     = n.msg                --获取发言人的消息
    sendid  = n.sendid             --获取发言人的QQ
    groupid = n.groupid            --获取机器人的群号
    robort  = n.robort             --获取机器人QQ
    nick    = n.nick               --获取机器人昵称
    zhu     = n.zhu                --获取主人
    ATQ     = n.ATQ                --获取艾特QQ
    --
    local input  = split(msg, " ")
    local NoI    = #input
    --
    if NoI == 1 then                                                            -- #uuid
        local res = "查询方式:\n#uuid <name>\n无效ID将不做回复"
        n:send(res)
        return
    end
    --
    local mojangAPI = "https://api.mojang.com/users/profiles/minecraft/"
    local name = input[NoI]
    n:send("Getting uuid ... (No reply:Invaild Player Name)")
    --
    local mjdata = n:get(mojangAPI..name)
    local t = json.decode(mjdata)
    local uuid = t["id"]
    n:send("Success.\n"..name.."\'s Unique User ID:\n"..uuid)
    --
end
--
-- 字符串分割
function split(str, reps)
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function (w)
        table.insert(resultStrList,w)
    end)
    return resultStrList
end

    

#hyp .*|#hyp
--lua编程
function main(m)
    --
    -- 查询Hypixel数据
    --
    -- 外挂lua包存储路径
    package.path = "/storage/emulated/0/luaPackages/?.lua;" .. package.path
    -- 必需依赖
    local json = require "json"
    --
    n       = m
    msg     = n.msg                --获取发言人的消息
    sendid  = n.sendid             --获取发言人的QQ
    groupid = n.groupid            --获取机器人的群号
    robort  = n.robort             --获取机器人QQ
    nick    = n.nick               --获取机器人昵称
    zhu     = n.zhu                --获取主人
    ATQ     = n.ATQ                --获取艾特QQ
    --
    local input  = split(msg, " ")
    local NoI    = #input
    local prefix = input[1]
    --
    local mojangAPI = "https://api.mojang.com/users/profiles/minecraft/"
    local hypkey    = ""                    -- Hypixel Key
    local askey     = ""                    -- AntiSniper Key
    --
    -- 映射信息代码的中文名称
    --
    local Online = {[true] = "在线", [false] = "离线"}
    local Color = {
        ["GOLD"] = "金色", ["BLACK"] = "黑色", ["DARK_GREEN"] = "深绿", 
        ["DARK_AQUA"] = "青色", ["YELLOW"] = "黄色"
    }
    local Language = {
        ["ENGLISH"] = "英语", ["CHINESE_SIMPLIFIED"] = "简中", 
        ["FRENCH"] = "法语", ["GERMAN"] = "德语"
    }
    local GameType = {
        ["BEDWARS"] = "起床战争", ["SKYWARS"] = "空岛战争", 
        ["DUELS"] = "决斗游戏", ["ARCADE"] = "街机游戏", 
        ["MURDER_MYSTERY"] = "密室杀手", ["SKYBLOCK"] = "空岛生存",  
        ["PIT"] = "天坑乱斗", ["HOUSING"] = "家园世界", 
        ["TNTGAMES"] = "TNT游戏", ["MCGO"] = "MCGO", 
        ["SURVIVAL_GAMES"] = "饥饿游戏", ["WALLS3"] = "超级战墙", 
        ["UHC"] = "UHC", ["PROTOTYPE"] = "游戏实验室", 
        ["BUILD_BATTLE"] = "建筑比赛"
    }
    local Practice = {
        ["BRIDGING"] = "搭路练习", ["FIREBALL_JUMPING"] = "火焰弹/TNT跳", ["MLG"] = "水桶/梯子自救"
    }
    local Bridging = {
        ["bridging_distance_30:elevation_NONE:angle_STRAIGHT:"] = "30格水平", 
        ["bridging_distance_50:elevation_NONE:angle_STRAIGHT:"] = "50格水平", 
        ["bridging_distance_100:elevation_NONE:angle_STRAIGHT:"] = "100格水平", 
        ["bridging_distance_30:elevation_SLIGHT:angle_STRAIGHT:"] = "30格向上", 
        ["bridging_distance_50:elevation_SLIGHT:angle_STRAIGHT:"] = "50格向上", 
        ["bridging_distance_100:elevation_SLIGHT:angle_STRAIGHT:"] = "100格向上", 
        ["bridging_distance_30:elevation_NONE:angle_DIAGONAL:"] = "30格斜向水平", 
        ["bridging_distance_50:elevation_NONE:angle_DIAGONAL:"] = "50格斜向水平", 
        ["bridging_distance_100:elevation_NONE:angle_DIAGONAL:"] = "100格斜向水平", 
        ["bridging_distance_30:elevation_SLIGHT:angle_DIAGONAL:"] = "30格斜向向上", 
        ["bridging_distance_50:elevation_SLIGHT:angle_DIAGONAL:"] = "50格斜向向上", 
        ["bridging_distance_100:elevation_SLIGHT:angle_DIAGONAL:"] = "100格斜向向上"
    }
    --
    -- 根据项数判断消息类型
    --
    if NoI == 1 then                                                            -- #hyp
        local res = "查询方式:\n#hyp <name>\n#hyp <category> <name>\n#hyp <category> <mode> <name>\n \n输入#hypall查询支持参数列表"
        n:send(res)
        return
    end
    --
    -- 查询公会信息
    --
    if input[2] == "gu" then
        local name = string.sub(msg, 9, #msg)
        local guildAPI     = "https://api.hypixel.net/guild?key=" .. hypkey .. "&name=" .. name
        local guildData    = json.decode(n:get(guildAPI))
        --
        local success = getBoolean(guildData, "success")
        --
        if success == true then
            --
            local guild = getTable(guildData, "guild")
            local name  = getString(guild, "name")
            local res   = name
            --
            -- 公会经验值转换为等级
            --
            local exp = getInt(guild, "exp")
            local level = 0
            local miniExp = exp / 50000
            local requireExp = {2, 3, 5, 10, 15, 20, 25, 30, 40, 50, 60}
            local i = 1
            --
            while miniExp > 0 do
                level = level + 1
                miniExp = miniExp - requireExp[i]
                if i < 11 then
                    i = i + 1
                end
            end
            --
            res = res .. "[LV." .. level .. "]"
            --
            if table.kIn(guild, "tag") then
                res = res .. "[" .. getString(guild, "tag") .. "]"
            end
            --
            res = res .. "\n| 创建时间:" .. limitTime(string.sub(getString(guild, "created"), 1, 10))
            res = res .. "\n| 总人数:" .. #getTable(guild, "members")
            res = res .. "\n| 最高在线人数:" .. getInt(getTable(guild, "achievements"), "ONLINE_PLAYERS")
            --
            if table.kIn(guild, "description") then
                res = res .. "\n| 公会介绍:" .. getString(guild, "description")
            end
            --
            n:send(res)
            delay(1000)
            res = ""
            if table.kIn(guild, "tagColor") then
                local tagColor = getString(guild, "tagColor")
                if table.kIn(Color, tagColor) then
                    tagColor = Color[tagColor]
                end
                res = res .. "| 标签颜色:" .. tagColor
            end
            --
            if table.kIn(guild, "preferredGames") then
                res = res .. "\n| 偏好游戏:"
                local preferredGames = getTable(guild, "preferredGames")
                for i, v in pairs(preferredGames) do
                    if table.kIn(GameType, v) then
                        preferredGames[i] = GameType[v]
                    end
                    res = res .. preferredGames[i] .. " "
                end
            end
            --
            n:send(res)
        end
        return
    end
    --
    local name = input[NoI]
    --
    -- 解析mojangAPI获取玩家uuid，解析失败会直接报错（mojang全责）
    --
    local mjdata = n:get(mojangAPI..name)
    --
    local t = json.decode(mjdata)
    --printTable(t)
    local uuid = t["id"]
    --
    -- 解析hypixelAPI获取那一大坨返回值
    --
    local playerAPI    = "https://api.hypixel.net/player?key=" .. hypkey .. "&uuid=" .. uuid
    local playerData   = json.decode(n:get(playerAPI))
    local statusAPI    = "https://api.hypixel.net/status?key=" .. hypkey .. "&uuid=" .. uuid
    local statusData   = json.decode(n:get(statusAPI))
    local guildAPI_    = "https://api.hypixel.net/guild?key=" .. hypkey .. "&player=" .. uuid
    local guildData_   = json.decode(n:get(guildAPI_))
    --
    -- 清洗hypixelAPI的返回值
    --
    local success = getBoolean(playerData, "success")
    --
    if success == true then
        --
        local player  = getTable(playerData, "player")
        local session = getTable(statusData, "session")
        local guild_  = getTable(guildData_, "guild")
        --
        local name = getString(player, "displayname")
        local rank = getRank(player)
        local res  = ""
        if table.kIn(player, "rank") then
            res = "[" .. getString(player, "rank") .. "]"
        end
        res = res .. rank .. name
        --
        if NoI == 2 then                                                        -- #hyp <name> 
            --
            res = res .. "[LV." .. getLevel(getInt(player, "networkExp")) .. "]"
            --
            if table.kIn(session, "online") and table.kIn(player, "lastLogin") then
                res = res .. "[" .. Online[getBoolean(session, "online")] .. "]"
            end
            --
            if table.kIn(guild_, "name") then
                res = res .. "\n| 所属公会:" .. getString(guild_, "name")
            end
            --
            if table.kIn(player, "userLanguage") then
                local userLanguage = getString(player, "userLanguage")
                if table.kIn(Language, userLanguage) then
                    userLanguage = Language[userLanguage]
                end
                res = res .. "\n| 用户语言:" .. userLanguage
            end
            if table.kIn(player, "firstLogin") and not table.kIn(player, "userLanguage") then
                res = res .. "\n| 用户语言:默认（英语）"
            end
            --
            if table.kIn(player, "mostRecentGameType") then
                local mostRecentGameType = getString(player, "mostRecentGameType")
                if table.kIn(GameType, mostRecentGameType) then
                    mostRecentGameType = GameType[mostRecentGameType]
                end
                res = res .. "\n| 最近游玩:" .. mostRecentGameType
            end
            --
            res = res .. "\n| 发言频道:" .. getString(player, "channel")
            res = res .. "\n| 成就点数:" .. getInt(player, "achievementPoints")
            res = res .. "\n| Rank赠送:" .. getInt(getTable(player, "giftingMeta"), "ranksGiven")
            res = res .. "\n| 人品值:" .. getInt(player, "karma")
            --
            if table.kIn(player, "firstLogin") then
                res = res .. "\n| 首次登录:" .. limitTime(string.sub(getString(player, "firstLogin"), 1, 10))
            end
            if table.kIn(player, "lastLogin") then
                res = res .. "\n| 最后登录:" .. limitTime(string.sub(getString(player, "lastLogin"), 1, 10))
            end
            if table.kIn(player, "lastLogout") then
                res = res .. "\n| 最后登出:" .. limitTime(string.sub(getString(player, "lastLogout"), 1, 10))
            end
            --
            n:send(res)
            delay(1000)
            res = "| 社交媒体:"
            if table.kIn(player, "socialMedia") then
                local socialMedia = getTable(player, "socialMedia")
                if table.kIn(socialMedia, "links") then
                    local links = getTable(socialMedia, "links")
                    if table.kIn(links, "YOUTUBE") then
                        res = res .. "\n| YouTube:" .. links["YOUTUBE"]
                    end
                    if table.kIn(links, "DISCORD") then
                        res = res .. "\n| Discord:" .. links["DISCORD"]
                    end
                    if table.kIn(links, "TWITTER") then
                        res = res .. "\n| Twitter:" .. links["TWITTER"]
                    end
                end
            end
            --
        end
        if NoI == 3 then                                                        -- #hyp <cls> <name>
            --
            cls = input[2]
            --
            if cls == "bw" then
                --
                -- 查询bedwars整体数据
                --
                local bedwars = player["stats"]["Bedwars"]
                local star    = getInt(player["achievements"], "bedwars_level")
                --
                local ewsAPI = "https://api.antisniper.net/v2/player/winstreak?key=" .. askey .. "&player=" .. uuid
                local ewsData = json.decode(n:get(ewsAPI))
                local ewinstreak = "获取失败"
                if getBoolean(ewsData, "success") then
                    ewinstreak = getInt(ewsData, "overall_winstreak")
                end
                --
                local coins         = getInt(bedwars, "coins")
                local challenges    = getInt(bedwars, "bw_unique_challenges_completed")
                local kills         = getInt(bedwars, "kills_bedwars")
                local deaths        = getInt(bedwars, "deaths_bedwars")
                local kdr           = keepDecimalTest(kills / deaths, 2)
                local final_kills   = getInt(bedwars, "final_kills_bedwars")
                local final_deaths  = getInt(bedwars, "final_deaths_bedwars")
                local fkdr          = keepDecimalTest(final_kills / final_deaths, 2)
                local beds_broken   = getInt(bedwars, "beds_broken_bedwars")
                local beds_lost     = getInt(bedwars, "beds_lost_bedwars")
                local bblr          = keepDecimalTest(beds_broken / beds_lost, 2)
                local wins          = getInt(bedwars, "wins_bedwars")
                local losses        = getInt(bedwars, "losses_bedwars")
                local wlr           = keepDecimalTest(wins / losses, 2)
                local emerald       = getInt(bedwars, "emerald_resources_collected_bedwars")
                local diamond       = getInt(bedwars, "diamond_resources_collected_bedwars")
                local gold          = getInt(bedwars, "gold_resources_collected_bedwars")
                local iron          = getInt(bedwars, "iron_resources_collected_bedwars")
                local winstreak = "获取失败"
                if table.kIn(bedwars, "winstreak") then
                    winstreak = bedwars["winstreak"]
                end
                --
                res = res .. "[" .. star .. "✫] Bedwars:"
                res = res .. "\n| 硬币:" .. coins .. " | WS:" .. winstreak
                res = res .. "\n| 完成挑战:".. challenges .. " | EWS:" .. ewinstreak
                res = res .. "\n| K:" .. kills .. " D:" .. deaths .. " K/D:" .. kdr
                res = res .. "\n| FK:" .. final_kills .. " FD:" .. final_deaths .. " FK/D:" .. fkdr
                res = res .. "\n| BB:" .. beds_broken .. " BL:" .. beds_lost .. " BB/L:" .. bblr
                res = res .. "\n| W:" .. wins .. " L:" .. losses .. " W/L:" .. wlr
                res = res .. "\n| 绿收集:" .. emerald .. " | 钻收集:" .. diamond
                res = res .. "\n| 金收集:" .. gold .. " | 铁收集:" .. iron
                --
            end
            if cls == "sw" then
                --
                -- 查询skywars整体数据
                --
                local skywars = player["stats"]["SkyWars"]
                --
                local star          = string.sub(getString(skywars, "levelFormatted"), 4)
                local coins         = getInt(skywars, "coins")
                local kills         = getInt(skywars, "kills")
                local deaths        = getInt(skywars, "deaths")
                local kdr           = keepDecimalTest(kills / deaths, 2)
                local wins          = getInt(skywars, "wins")
                local losses        = getInt(skywars, "losses")
                local wlr           = keepDecimalTest(wins / losses, 2)
                local heads         = getInt(skywars, "heads")
                local souls         = getInt(skywars, "souls")
                local assists       = getInt(skywars, "assists")
                local lastMode      = getInt(skywars, "lastMode")
                local winstreak = "获取失败"
                if table.kIn(skywars, "win_streak") then
                    winstreak = skywars["win_streak"]
                end
                --
                res = res .. "[" .. star .. "] SkyWars:"
                res = res .. "\n| 硬币:" .. coins .. " | WS:" .. winstreak
                res = res .. "\n| K:" .. kills .. " D:" .. deaths .. " K/D:" .. kdr
                res = res .. "\n| W:" .. wins .. " L:" .. losses .. " W/L:" .. wlr
                res = res .. "\n| 头颅:" .. heads .. " | 灵魂:" .. souls
                res = res .. "\n| 助攻:" .. assists .. " | 最近游玩:" .. lastMode
                --
            end
        end
        if NoI == 4 then                                                        -- #hyp <cls> <mode> <name>
            --
            cls = input[2]
            mode = input[3]
            --
            if cls == "bw" then
                --
                -- 查询bedwars某一模式的数据
                --
                local bedwars = player["stats"]["Bedwars"]
                local star    = getInt(player["achievements"], "bedwars_level")
                --
                local ewsAPI = "https://api.antisniper.net/v2/player/winstreak?key=" .. askey .. "&player=" .. uuid
                local ewsData = json.decode(n:get(ewsAPI))
                --
                if mode == "pra" then           -- 查询bedwars practice数据
                    if table.kIn(bedwars, "practice") then 
                        --
                        local practice = bedwars["practice"]
                        --
                        selected = practice["selected"]
                        if table.kIn(Practice, selected) then
                            selected = Practice[selected]
                        end
                        res = res .. "[" .. star .. "✫] Bedwars Practice" .. ":"
                        res = res .. "\n| 玩家所选模式:" .. selected
                        res = res .. "\n##搭路练习:"
                        res = res .. "\n| 方块放置:" .. getInt(practice["bridging"], "blocks_placed")
                        res = res .. "\n| 失败次数:" .. getInt(practice["bridging"], "failed_attempts")
                        res = res .. " | 成功次数:" .. getInt(practice["bridging"], "successful_attempts")
                        --
                        if table.kIn(practice, "records") then
                            local records = practice["records"]
                            for i, v in pairs(records) do
                                local mode = i
                                if table.kIn(Bridging, mode) then
                                    mode = Bridging[mode]
                                end
                                res = res .. "\n - " .. mode .. ":" .. v/1000 .. "s" 
                            end
                        end
                        --
                        if table.kIn(practice, "fireball_jumping") then
                            n:send(res)
                            delay(1000)
                            res = "##火焰弹/TNT跳:"
                            res = res .. "\n| 方块放置:" .. getInt(practice["fireball_jumping"], "blocks_placed")
                            res = res .. "\n| 失败次数:" .. getInt(practice["fireball_jumping"], "failed_attempts")
                            res = res .. " | 成功次数:" .. getInt(practice["fireball_jumping"], "successful_attempts")
                        end
                        --
                        if table.kIn(practice, "mlg") then
                            res = res .. "\n##水桶/梯子自救:"
                            res = res .. "\n| 方块放置:" .. getInt(practice["mlg"], "blocks_placed")
                            res = res .. "\n| 失败次数:" .. getInt(practice["mlg"], "failed_attempts")
                            res = res .. " | 成功次数:" .. getInt(practice["mlg"], "successful_attempts")
                        end
                        --
                    else
                        res = "*该玩家没有进行过练习！"
                    end
                end
                if mode == "81" then            -- 查询bedwars solo数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "eight_one", star)
                    --
                end
                if mode == "82" then            -- 查询bedwars double数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "eight_two", star)
                    --
                end
                if mode == "43" then            -- 查询bedwars 3v3v3v3数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "four_three", star)
                    --
                end
                if mode == "24" then            -- 查询bedwars 4v4数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "two_four", star)
                    --
                end
                if mode == "44" then            -- 查询bedwars 4v4v4v4数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "four_four", star)
                    --
                end
                if mode == "r2" then            -- 查询bedwars rush double数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "eight_two_rush", star)
                    --
                end
                if mode == "r4" then            -- 查询bedwars rush 4v4v4v4数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "four_four_rush", star)
                    --
                end
                if mode == "u1" then            -- 查询bedwars ultimate solo数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "eight_one_ultimate", star)
                    --
                end
                if mode == "u2" then            -- 查询bedwars ultimate double数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "eight_two_ultimate", star)
                    --
                end
                if mode == "u4" then            -- 查询bedwars ultimate 4v4v4v4数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "four_four_ultimate", star)
                    --
                end
                if mode == "c" then             -- 查询bedwars castle数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "castle", star)
                    --
                end
                if mode == "v2" then            -- 查询bedwars voidless double数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "eight_two_voidless", star)
                    --
                end
                if mode == "v4" then            -- 查询bedwars voidless 4v4v4v4数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "four_four_voidless", star)
                    --
                end
                if mode == "a2" then            -- 查询bedwars armed double数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "eight_two_armed", star)
                    --
                end
                if mode == "a4" then            -- 查询bedwars armed 4v4v4v4数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "four_four_armed", star)
                    --
                end
                if mode == "l2" then            -- 查询bedwars lucky double数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "eight_two_lucky", star)
                    --
                end
                if mode == "l4" then            -- 查询bedwars lucky 4v4v4v4数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "four_four_lucky", star)
                    --
                end
                if mode == "s2" then            -- 查询bedwars swap double数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "eight_two_swap", star)
                    --
                end
                if mode == "s4" then            -- 查询bedwars swap 4v4v4v4数据
                    --
                    res = getBedwarsData(bedwars, ewsData, res, "four_four_swap", star)
                    --
                end
            end
            if cls == "sw" then
                --
                if mode == "solo" then          -- 查询skywars solo 数据
                    --
                    --
                end
            end
        end
        n:send(res)
    end
end
--
--
-- 检验工具:
--
--
-- 查看某值是否为表中的key值
function table.kIn(tbl, key)
    if tbl == nil then
        return false
    end
    for k, v in pairs(tbl) do
        if k == key then
            return true
        end
    end
    return false
end
--
-- 查看某值是否为表中的value值
function table.vIn(tbl, value)
    if tbl == nil then
        return false
    end
 
    for k, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end
--
-- 打印table
--
-- log输出格式化
local function logPrint(str)
    str = os.date("\nLog output date: %Y-%m-%d %H:%M:%S \n", os.time()) .. str
    n:send(str)
end
--
-- key值格式化
local function formatKey(key)
    local t = type(key)
    if t == "number" then
        return "["..key.."]"
    elseif t == "string" then
        local n = tonumber(key)
        if n then
            return "["..key.."]"
        end
    end
    return key
end
--
-- 栈
local function newStack()
    local stack = {
        tableList = {}
    }
    function stack:push(t)
        table.insert(self.tableList, t)
    end
    function stack:pop()
        return table.remove(self.tableList)
    end
    function stack:contains(t)
        for _, v in ipairs(self.tableList) do
            if v == t then
                return true
            end
        end
        return false
    end
    return stack
end
--
-- 输出打印table表 函数
function printTable(...)
    local args = {...}
    for k, v in pairs(args) do
        local root = v
        if type(root) == "table" then
            local temp = {
                "------------------------ printTable start ------------------------\n",
                "local tableValue".." = {\n",
            }
            local stack = newStack()
            local function table2String(t, depth)
                stack:push(t)
                if type(depth) == "number" then
                    depth = depth + 1
                else
                    depth = 1
                end
                local indent = ""
                for i=1, depth do
                    indent = indent .. "    "
                end
                for k, v in pairs(t) do
                    local key = tostring(k)
                    local typeV = type(v)
                    if typeV == "table" then
                        if key ~= "__valuePrototype" then
                            if stack:contains(v) then
                                table.insert(temp, indent..formatKey(key).." = {检测到循环引用!},\n")
                            else
                                table.insert(temp, indent..formatKey(key).." = {\n")
                                table2String(v, depth)
                                table.insert(temp, indent.."},\n")
                            end
                        end
                    elseif typeV == "string" then
                        table.insert(temp, string.format("%s%s = \"%s\",\n", indent, formatKey(key), tostring(v)))
                    else
                        table.insert(temp, string.format("%s%s = %s,\n", indent, formatKey(key), tostring(v)))
                    end
                end
                stack:pop()
            end
            table2String(root)
            table.insert(temp, "}\n------------------------- printTable end -------------------------")
            logPrint(table.concat(temp))
        else
            logPrint("----------------------- printString start ------------------------\n"
                 .. tostring(root) .. "\n------------------------ printString end -------------------------")
        end
    end
end
--
--
-- 安全获取工具:
--
--
-- 获取布尔值:
function getBoolean(data, key)
    local res = false
    if table.kIn(data, key) then
        res = data[key]
    end
    return res
end
--
-- 获取整型值:
function getInt(data, key)
    local res = 0
    if table.kIn(data, key) then
        res = data[key]
    end
    return res
end
--
-- 获取字符串:
function getString(data, key)
    local res = "获取失败"
    if table.kIn(data, key) then
        res = data[key]
    end
    return res
end
--
-- 获取映射表:
function getTable(data, key)
    local res = {}
    if table.kIn(data, key) then
        res = data[key]
    end
    return res
end
--
--
-- 清洗工具:
--
--
-- 字符串分割
function split(str, reps)
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function (w)
        table.insert(resultStrList,w)
    end)
    return resultStrList
end
--
-- 保留n位小数
function keepDecimalTest(num, n)
    if type(num) ~= "number" then
        return num    
    end
    n = n or 2
    if num < 0 then
        return -(math.abs(num) - math.abs(num) % 0.1 ^ n)
    else
        return num - num % 0.1 ^ n
    end
end
--
-- 换算经验值为等级:
function getLevel(xp)
    local prefix = -3.5
    local onst = 12.25
    local divides = 0.0008
    return math.floor(math.sqrt(divides*xp+onst) + prefix + 1)
end
--
-- 时间戳转时间:
function limitTime(time)
    local localtime= os.date("*t", time)
    local year = localtime.year
    local mon = localtime.month
    local day = localtime.day
    local hour = localtime.hour
    local min = localtime.min
    local sec = localtime.sec
    return year .. "-" .. mon .. "-" .. day .. " " .. hour .. ":" .. min .. ":" .. sec
end
--
-- 获取rank状态:
function getRank(data)
    if table.kIn(data, "newPackageRank") then
        local rank = (data["newPackageRank"]) 
        if rank == "MVP_PLUS" then
            if table.kIn(data, "monthlyPackageRank") then
                local mvp_plus_plus = (data["monthlyPackageRank"]) 
                if mvp_plus_plus == "NONE" then
                    return ("[MVP+]")
                else
                    return("[MVP++]")
                end
            else
                return("[MVP+]")
            end
        end
        if rank == "MVP" then
            return ("[MVP]")
        end
        if rank == "VIP_PLUS" then
            return ("[VIP+]")
        end
        if rank == "VIP" then
            return ("[VIP]")
        end
    else
        return ("[NONE]")
    end
end
--
-- 获取bedwars数据:
function getBedwarsData(bedwars, ewsData, res, mode, star)
    --
    -- 映射Bedwars模式名称
    --
    local BedwarsMode = {
        ["eight_one"] = "Solo", ["eight_two"] = "Double", 
        ["four_three"] = "3v3v3v3", ["two_four"] = "4v4", 
        ["four_four"] = "4v4v4v4", 
        ["eight_two_rush"] = "Rush Double", ["four_four_rush"] = "Rush 4v4v4v4", 
        ["eight_one_ultimate"] = "Ultimate Solo", ["eight_two_ultimate"] = "Ultimate Double", 
        ["four_four_ultimate"] = "Ultimate 4v4v4v4", ["castle"] = "Castle", 
        ["eight_two_voidless"] = "Voidless Double", ["four_four_voidless"] = "Voidless 4v4v4v4", 
        ["eight_two_armed"] = "Armed Double", ["four_four_armed"] = "Armed 4v4v4v4", 
        ["eight_two_lucky"] = "Luckyblock Double", ["four_four_lucky"] = "Luckyblock 4v4v4v4", 
        ["eight_two_swap"] = "Swap Double", ["four_four_swap"] = "Swap 4v4v4v4"
    }
    --
    modeName = BedwarsMode[mode]
    --
    --
    -- 查询bedwars某一模式的数据
    --
    local ewinstreak = "获取失败"
    if getBoolean(ewsData, "success") then
        ewinstreak = getInt(ewsData, mode .. "_winstreak")
    end
    --
    local kills         = getInt(bedwars, mode .. "_kills_bedwars")
    local deaths        = getInt(bedwars, mode .. "_deaths_bedwars")
    local kdr           = keepDecimalTest(kills / deaths, 2)
    local final_kills   = getInt(bedwars, mode .. "_final_kills_bedwars")
    local final_deaths  = getInt(bedwars, mode .. "_final_deaths_bedwars")
    local fkdr          = keepDecimalTest(final_kills / final_deaths, 2)
    local beds_broken   = getInt(bedwars, mode .. "_beds_broken_bedwars")
    local beds_lost     = getInt(bedwars, mode .. "_beds_lost_bedwars")
    local bblr          = keepDecimalTest(beds_broken / beds_lost, 2)
    local wins          = getInt(bedwars, mode .. "_wins_bedwars")
    local losses        = getInt(bedwars, mode .. "_losses_bedwars")
    local wlr           = keepDecimalTest(wins / losses, 2)
    local emerald       = getInt(bedwars, mode .. "_emerald_resources_collected_bedwars")
    local diamond       = getInt(bedwars, mode .. "_diamond_resources_collected_bedwars")
    local gold          = getInt(bedwars, mode .. "_gold_resources_collected_bedwars")
    local iron          = getInt(bedwars, mode .. "_iron_resources_collected_bedwars")
    local winstreak = "获取被阻止"
    if table.kIn(bedwars, mode .. "_winstreak") then
        winstreak = bedwars[mode .. "_winstreak"]
    end
    --
    res = res .. "[" .. star .. "✫] Bedwars " .. modeName .. ":"
    res = res .. "\n| WS:" .. winstreak .. " | EWS:" .. ewinstreak
    res = res .. "\n| K:" .. kills .. " D:" .. deaths .. " K/D:" .. kdr
    res = res .. "\n| FK:" .. final_kills .. " FD:" .. final_deaths .. " FK/D:" .. fkdr
    res = res .. "\n| BB:" .. beds_broken .. " BL:" .. beds_lost .. " BB/L:" .. bblr
    res = res .. "\n| W:" .. wins .. " L:" .. losses .. " W/L:" .. wlr
    res = res .. "\n| 绿收集:" .. emerald .. " | 钻收集:" .. diamond
    res = res .. "\n| 金收集:" .. gold .. " | 铁收集:" .. iron
    --
    return res
end
--
-- 暴力延迟
function delay(n)
    local i = 0
    while i < n do
        i = i + 0.001
    end
end



#hypall
当前支持查询参数:\r
class: bw, sw, gu\r
mode: \r
    81, 82, 34, 42, 44\r
    r2, r4, u1, u2, u4\r
    c , v2, v4, l2, l4\r
    s2, s4, pra