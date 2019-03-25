
-- According to the following website: http://browsercookielimits.squawky.net/
-- The limit for cookies should be 4093 bytes including containing name, value, expiry.

function xpatransform(str)
   return "xpa="..str.."; Path=/; Domain=walmart.com; Expires=Mon, 25 Mar 2019 06:54:05 GMT; Max-Age=1800" 
end

local specs = {}
for i=1,668 do 
    local res = ""
	for i = 1, 5 do
		res = res..string.char(math.random(97, 122))
	end
    specs[i] = res
end
local s = table.concat(specs, "|")
print(xpatransform(s)..":"..xpatransform(s):len())
print()

print("Original Size: "..s:len())
print(string.format("Algo\tSize(b)\tTime(ms)"))

--luarocks install lua-lz4
--https://lz4.github.io/lz4/
local lz4 = require("lz4")
local x = os.clock()
local cs = lz4.compress(s, {compression_level=16})
print(string.format("lz4\t%.0f\t%.6f", cs:len(), os.clock() - x))
print(xpatransform(cs)..":"..xpatransform(cs):len())

--[[
local lzw = require("lzw")
x = os.clock()
local nBeginCode = 6
local tbCode, tbChar = lzw.deflate(s, nBeginCode)
print('tbCode, tbChar = ', tbCode, tbChar)
print(string.format("lualzw\t%s\t%s\t%.6f", tbCode, tbChar, os.clock() - x))

local zlib = require "zlib"
-- input:  string
-- output: string compressed with gzip
function compress(str)
    local level = 5
    local windowSize = 15+16
    return zlib.deflate(level, windowSize)(str, "finish")
 end

x = os.clock()
cs = compress(s)
print(string.format("zlib\t%.0f\t%.6f", cs:len(), os.clock() - x))


smaz = require("smaz")
x = os.clock()
cs = smaz.compress(s)
print(string.format("smaz\t%.0f\t%.6f", cs:len(), os.clock() - x))
]]