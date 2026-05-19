local HttpService = game:GetService("HttpService")

-- 1. Fetch the raw decimals from GitHub
local url = "https://raw.githubusercontent.com/grobshlob/funstuff-for-severe/refs/heads/main/some%20decimals"
local rawData = game:HttpGet(url)

-- 2. Convert space-separated decimals to a Lua String
local scriptChars = {}
for num in string.gmatch(rawData, "%d+") do
    table.insert(scriptChars, string.char(tonumber(num)))
end

local finalScript = table.concat(scriptChars)

-- 3. Execute the resulting script
print("Successfully converted script. Executing...")
local func, err = loadstring(finalScript)

if func then
    func()
else
    warn("Error loading the converted script: " .. tostring(err))
    -- If it fails, print the first bit of the script to see what it is
    print("Script Preview: " .. string.sub(finalScript, 1, 100))
end
