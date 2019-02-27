function GetRayHitWithLayer(posInScreen, layerName)
    local ray = UnityEngine.Camera.main:ScreenPointToRay(Vector3(posInScreen.x, posInScreen.y, 0))
    local layerMask = math.pow(2, UnityEngine.LayerMask.NameToLayer(layerName))
    local ret, hit = UnityEngine.Physics.Raycast(ray, nil, 200, layerMask)
    return ret, hit 
end

function GetRayHit(posInScreen)
    local ray = UnityEngine.Camera.main:ScreenPointToRay(Vector3(posInScreen.x, posInScreen.y, 0))
    local ret, hit = UnityEngine.Physics.Raycast(ray, nil)
    return ret, hit
end

function GetDistanceSquare(pos1, pos2)
    return (pos1.x - pos2.x) * (pos1.x - pos2.x) + (pos1.y - pos2.y) * (pos1.y - pos2.y) + (pos1.z - pos2.z) * (pos1.z - pos2.z)
end

function GetMagnitude(vec3)
    return math.sqrt(vec3.x * vec3.x + vec3.y * vec3.y + vec3.z * vec3.z)
end

function GetFixedRaycastPos(posX, posZ)
    local posX = posX / 10
    local posZ = posZ / 10
    local layerMask = math.pow(2, UnityEngine.LayerMask.NameToLayer(GOLayers.Terrain))
    local ret, hit = UnityEngine.Physics.Raycast(Vector3(posX, 100, posZ), Vector3(0, -1, 0), nil, 200, layerMask)
    if ret then
        return hit.point
    else
        Log.LogError("GetFixedRaycastPos bug:"..posX..","..posZ.." "..debug.traceback())
    end
end

function CopyTableDeep(st, target)
    local tab = {}
    if target then tab = target end
    for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = CopyTableDeep(v)
        end
    end
    return tab
end

function CopyTableShallow(st, target)
    local tab = {}
    if target then tab = target end
    for k, v in pairs(st or {}) do
        tab[k] = v
    end
    return tab
end

function table.tostring(tbl, indent, limit, depth, jstack)
    limit = limit or 1000
    depth = depth or 7
    jstack = jstack or {name = "top"}
    local i = 0

    local output = {}
    if type(tbl) == "table" then
        -- very important to avoid disgracing ourselves with circular referencs...
        if depth <= 0 then
            return "{...}\n"
        end
        for i,t in pairs(jstack) do
            if tbl == t then
                return "<" .. i .. ">,\n"
            end
        end
        jstack[jstack.name] = tbl

        table.insert(output, "{\n")

        local name = jstack.name
        for key, value in pairs(tbl) do
            local innerIndent = (indent or " ") .. (indent or " ")
            table.insert(output, innerIndent .. tostring(key) .. " = ")
            jstack.name = name .. "." .. tostring(key)
            table.insert(output,
                value == tbl and "<parent>," or table.tostring(value, innerIndent, limit, depth - 1, jstack)
            )

            i = i + 1
            if i > limit then
                table.insert(output, (innerIndent or "") .. "...\n")
                break
            end
        end

        table.insert(output, indent and (indent or "") .. "},\n" or "}")
    else
        if type(tbl) == "string" then tbl = "\"" .. string.format("%q", tbl) .. "\"" end -- quote strings
        table.insert(output, tostring(tbl) .. ",\n")
    end

    return table.concat(output)
end

function table.indexOf(tbl, value)
    for i, t in pairs(tbl) do
        if t == value then
            return i
        end
    end
end

function ReverseTable(tbl)
    local reverse = {}
    for i = #tbl, 1, -1 do
        reverse[#reverse + 1] = tbl[i]
    end
    return reverse
end

function Unserialize(lua)  
    local t = type(lua)
    if t == "nil" or lua == "" then  
        return nil  
    elseif t == "number" or t == "string" or t == "boolean" then  
        lua = tostring(lua)  
    else  
        error("can not unserialize a " .. t .. " type.")  
    end  
    lua = "return " .. lua  
    local func = loadstring(lua)    
    if func == nil then  
        return nil  
    end  
    return func()  
end  

function Serialize(obj)  
    local lua = ""  
    local t = type(obj)  
    if t == "number" then  
        lua = lua .. obj  
    elseif t == "boolean" then  
        lua = lua .. tostring(obj)  
    elseif t == "string" then  
        lua = lua .. string.format("%q", obj)  
    elseif t == "table" then  
        lua = lua .. "{\n"  
    for k, v in pairs(obj) do  
        lua = lua .. "[" .. Serialize(k) .. "]=" .. Serialize(v) .. ",\n"  
    end  
    local metatable = getmetatable(obj)  
        if metatable ~= nil and type(metatable.__index) == "table" then  
        for k, v in pairs(metatable.__index) do  
            lua = lua .. "[" .. Serialize(k) .. "]=" .. Serialize(v) .. ",\n"  
        end  
    end  
        lua = lua .. "}"  
    elseif t == "nil" then  
        return nil  
    else  
        error("can not serialize a " .. t .. " type.")
    end  
    return lua  
end  

function RunInEditor()
    return (UnityEngine.Application.platform == UnityEngine.RuntimePlatform.OSXEditor) or (UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor)
end

--local sprite_path_prefix = "Sprite/"
function GetSprite(spriteName)
    --[[if not string.find(spriteName, sprite_path_prefix) then
        local segmentIndex = string.find(spriteName, "/")
        spriteName = spriteName:sub(1, segmentIndex) .. sprite_path_prefix .. spriteName:sub(segmentIndex + 1, string.len(spriteName))
    end]]
    return GameObjectPool.Instance:GetSprite(spriteName)
end

function GetMaterial(materialName)
    return GameObjectPool.Instance:GetMaterial(materialName)
end

function LoadSprite(spriteName, callback)
    --[[if not string.find(spriteName, sprite_path_prefix) then
        local segmentIndex = string.find(spriteName, "/")
        spriteName = spriteName:sub(1, segmentIndex) .. sprite_path_prefix .. spriteName:sub(segmentIndex + 1, string.len(spriteName))
    end]]
    local function onFinish()
        if callback then
            callback(GameObjectPool.Instance:GetSprite(spriteName))
        end
    end
    GameObjectPool.Instance:AddPoolTemplateLua({spriteName}, onFinish, function() end)
end

function IsRectIntersects(rect_1, rect_2)
    return not (rect_1.rt.x < rect_2.lb.x or rect_2.rt.x < rect_1.lb.x or rect_1.rt.y < rect_2.lb.y or rect_2.rt.y < rect_1.lb.y)
end

function RectDistance(rect_1, rect_2)
    local pos_1 = Vector2.New((rect_1.rt.x + rect_1.lb.x) / 2, (rect_1.rt.y + rect_1.lb.y) / 2)
    local pos_2 = Vector2.New((rect_2.rt.x + rect_2.lb.x) / 2, (rect_2.rt.y + rect_2.lb.y) / 2)
    return Vector2.Distance(pos_1, pos_2)
end

function string.utf8len(input)
    local len = string.len(input)
    local left = len
    local cnt = 0
    local arr = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        local i = #arr
        while arr[i] do
            if tmp > arr[i] then
                left = left - i
                break
            end
            i = i -1
        end
        cnt = cnt + 1
    end
    return cnt
end

function string.utf8sub(input, startIdx, endIdx)
    if startIdx > endIdx then
        local tmp = startIdx
        startIdx = endIdx
        endIdx = tmp
    end

    local len = string.len(input)
    local left = len
    local cnt = 0
    local arr = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    local sIdx = startIdx
    local eIdx = endIdx
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        local i = #arr
        while arr[i] do
            if tmp > arr[i] then
                left = left - i
                break
            end
            i = i -1
        end
        cnt = cnt + 1
        if cnt == startIdx then
            sIdx = len - (left + i) + 1
        end
        if cnt == endIdx then
            eIdx = len - left
            break
        end
    end
    return string.sub(input, sIdx, eIdx)
end

function FormatTime(timeStr)
    local splits = timeStr:split(":")
    local h = splits[1]
    local m = splits[2]
    return tonumber(h), tonumber(m)
end

---GetRemainTime
---@param timeStr string
---@param isZeroZone boolean
---@return number
function GetRemainTime(timeStr, isZeroZone)
    local h1, m1 = FormatTime(timeStr)
    local curTime = isZeroZone and os.date("!*t", PlayerDataManager.instance:GetClientTimeStamp(true))
            or os.date("*t", PlayerDataManager.instance:GetClientTimeStamp(true))
    if not curTime and not isZeroZone then
        Debugger.LogError("current time zone data is nil , time use zero zone data")
        curTime = os.date("*t", PlayerDataManager.instance:GetClientTimeStamp(true))
    end
    local curH = curTime.hour
    local curM = curTime.min

    local remainH = h1 - curH
    local remainM = m1 - curM
    local totalRemainSeCond = remainH * 3600 + remainM * 60
    if totalRemainSeCond < 0 then
        totalRemainSeCond = 24 * 60 * 60 + totalRemainSeCond
    end
    return totalRemainSeCond
end

function ProcessCSharpGC(t)
    if type(t) == "table" then
        for _, item in pairs(t) do
            ProcessCSharpGC(item)
        end
    else
        tolua.ExplicitGC(t)
    end
end