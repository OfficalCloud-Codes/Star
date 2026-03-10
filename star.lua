local Variables = {}
local functions = {}


-- /////////// ESSENTIAL FUNCTIONS ///////////

local function expectType(given, expected)
    local typeofvalue = type(given)
    if type(expected) == "table" then
        for _, t in ipairs(expected) do
            if typeofvalue == t then return true end
        end
        error("Expected type "..table.concat(expected," or ")..", got "..typeofvalue)
    end
    if typeofvalue ~= expected then
        error("Expected type "..expected..", got "..typeofvalue)
    end
    return true
end



local function fixType(value)
    if value == nil then
        return nil
    end
    if type(value) == "number" or type(value) == "boolean" then
        return value
    end

    local str = tostring(value)

    if str:sub(1,1) == '"' and str:sub(-1) == '"' then
        return str:sub(2,-2)
    end

    if str:lower() == "true" then
        return true
    end
    if str:lower() == "false" then
        return false
    end

    local n = tonumber(str)
    if n then
        return n
    end

    return str
end

local function getVariable(name)
    local findvariable = Variables[name]
    if not findvariable then
        return nil
    end
    return findvariable[2]
end

local function stringise(text)
    local clean = text:gsub('"', '')
    if clean == text then
        local getvar = getVariable(text)
        return getvar
    else
        return clean
    end
end

-- /////////// RETURNING FUNCTIONS ///////////

local function resolveValue(tokens, i, line)
    local token = tokens[i]

    if token == "math" then
        
        local number1 = fixType(tokens[i+1])
        local arithmatic = tokens[i+2]
        local number2 = fixType(tokens[i+3])

        expectType(fixType(number1), {"number"})
        expectType(arithmatic, {"string"})
        expectType(fixType(number2), {"number"})

        number1 = tonumber(number1)
        number2 = tonumber(number2)

        if number1 == nil then
            return nil
        end
        if number2 == nil then
            return nil
        end

        if arithmatic == "+" then
            return number1 + number2, 3
        elseif arithmatic == "-" then
            return number1 - number2, 3
        elseif arithmatic == "/" then
            return number1 / number2, 3
        elseif arithmatic == "*" then
            return number1 * number2, 3
        end
    end

    if token == "random" then
        local min = fixType(tokens[i+1])
        local max = fixType(tokens[i+2])

        expectType(min, {"number"})
        expectType(max, {"number"})

        return math.random(min, max), 2
    end

    if token == "len" then
        local text = fixType(tokens[i+1])

        expectType(text, {"string"})

        return string.len(text), 1
    end

    if token == "input" then
        local prompt = fixType(tokens[i+1])
        expectType(prompt, {"string"})
        io.write(prompt.." ")
        local v = io.read()
        return v,1
    end

if token == "concat" then
    local a = resolveValue(tokens, i+1, line)
    local b = resolveValue(tokens, i+2, line)

    if type(a) == "table" then a = a[1] end
    if type(b) == "table" then b = b[1] end

    a = tostring(a)
    b = tostring(b)

    return a .. b, 2
end

    if token == "type" then
        local v = resolveValue(tokens,i+1,line)
        return type(v),1
    end

    if token == "equal" then
        local a = resolveValue(tokens,i+1,line)
        local b = resolveValue(tokens,i+2,line)
        return a == b,2
    end

    if token == "greater" then
        local a = resolveValue(tokens,i+1,line)
        local b = resolveValue(tokens,i+2,line)
        
        if tonumber(a) == nil then
            return nil
        end
        if tonumber(b) == nil then
            return nil
        end
        
        return a > b,2
    end

    if token == "less" then
        local a = resolveValue(tokens,i+1,line)
        local b = resolveValue(tokens,i+2,line)

        if tonumber(a) == nil then
            return nil
        end
        if tonumber(b) == nil then
            return nil
        end

        return a < b,2
    end

    if token == "and" then
        local a = resolveValue(tokens,i+1,line)
        local b = resolveValue(tokens,i+2,line)
        return a and b,2
    end

    if token == "or" then
        local a = resolveValue(tokens,i+1,line)
        local b = resolveValue(tokens,i+2,line)
        return a or b,2
    end

    if token == "not" then
        local a = resolveValue(tokens,i+1,line)
        return not a,1
    end

    local var = getVariable(token)
    if var ~= nil then
        return var, 0
    end

    return fixType(token), 0
end

-- /////////// ESSENTIAL FUNCTIONS CONT ///////////



local function tokenize(text)
    local tokens = {}
    local i = 1
    while i <= #text do
        local c = text:sub(i,i)
        if c == '"' then
            local j = i + 1
            while j <= #text and text:sub(j,j) ~= '"' do
                j = j + 1
            end
            if j > #text then
                error("Unclosed quote in line: "..text)
            end
            local token = text:sub(i,j)  -- include quotes
            table.insert(tokens, token)
            i = j + 1
        elseif c:match("%s") then
            i = i + 1
        else
            local j = i
            while j <= #text and not text:sub(j,j):match("%s") do
                j = j + 1
            end
            local token = text:sub(i,j-1)
            table.insert(tokens, token)
            i = j
        end
    end
    return tokens
end


local function createVariable(name,isConstant,value)
    Variables[name] = {isConstant,value}
end


local function setVariable(name,value,abletocreate)
    local findvariable = Variables[name]
    if not findvariable then
        if abletocreate then
            createVariable(name,false,value)
        else error("Error: Variable with name "..name.." does not exsist") return end
    end
    if findvariable[1] then
        error("Error: Variable "..name.." is a constant and cannot be changed")
        return
    end
    if type(value) == type(findvariable[2]) then
        findvariable[2] = value
    else error("Error: Cannot set "..name.." due to type mismatch") return end
end


-- /////////// EXECUTION ///////////

local function execute(tokens,line)
    local command = tostring(tokens[1])

    if not command then return end

    if command == "print" then
        local value = resolveValue(tokens,2,line)
        print(value)
        return
    end
    
    if command == "const" then
        if tokens[3] ~= "=" then
            error("Error: Must use = sign to set variables")
            return
        end
        local value = resolveValue(tokens,4,line)
        createVariable(tokens[2],true,value)
        return
    end

    if command == "let" then
        if tokens[3] ~= "=" then
            error("Error: Must use = sign to set variables")
            return
        end
        local value = resolveValue(tokens,4,line)
        createVariable(tokens[2],false,value)
        return
    end

    if command == "set" then
        if tokens[3] ~= "to" then
            error("Error: Must use 'to' to set variables")
            return
        end
        local value = resolveValue(tokens,4,line)
        setVariable(tokens[2],value,false)
        return
    end

    if command == "if" then
        local result = resolveValue(tokens,2,line)
        if not result then
            return "skip_if"
        end
        return
    end

    if command == "while" then
        local result = resolveValue(tokens,2,line)
        if not result then
            return "skip_while"
        end
        return "loop"
    end
    
    error("Error: "..command.." is not a valid function. Line: "..line)
end

-- /////////// FILE LOADING ///////////

local filename = arg[1] 
local file = io.open(filename, "r")
if not file then
    error("Cannot open file: " .. filename)
end

local lines = {}
for line in file:lines() do
    table.insert(lines,line)
end

local exline = 1
while exline <= #lines do
    local line = lines[exline]

    if line ~= "" and line ~= nil and not line:match("^#") then
        local tokens = tokenize(line)
        if tokens then
            local result = execute(tokens,exline)

            if result == "skip_if" then
                repeat
                    exline = exline + 1
                until lines[exline] == "conclude" or exline > #lines
            end

            if result == "skip_while" then
                repeat
                    exline = exline + 1
                until lines[exline] == "conclude" or exline > #lines
            end

            if result == "loop" then
                local startline = exline
                exline = exline + 1
                while true do
                    local l = lines[exline]
                    if l == "conclude" then
                        local condtokens = tokenize(lines[startline])
                        if not resolveValue(condtokens,2,startline) then
                            break
                        end
                        exline = startline
                    else
                        local t = tokenize(l)
                        execute(t,exline)
                    end
                    exline = exline + 1
                end
            end

        end
    end

    exline = exline + 1
end

file:close()