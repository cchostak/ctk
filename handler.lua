-- local singletons = require "kong.singletons"
-- local BasePlugin = require "kong.plugins.base_plugin"
-- local responses = require "kong.tools.responses"
-- local utils = require "kong.tools.utils"
-- local constants = require "kong.constants"
-- local multipart = require "multipart"
-- local cjson = require "cjson"
-- local url = require "socket.url"
-- local access = require "kong.plugins.ctk.access"

-- local CtkHandler = BasePlugin:extend()

-- CtkHandler.PRIORITY = 3505
-- CtkHandler.VERSION = "0.1.0"

-- file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
-- io.input(file)
-- file:write("--- JUST EXTENDED THE BASE PLUGIN ---")


-- function CtkHandler:new()
--   CtkHandler.super.new(self, "ctk")
--   file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
--   io.input(file)
--   file:write("--- INSTACIATED ITSELF ---")  
-- end

-- function CtkHandler:access(conf)
--   CtkHandler.super.access(self)
--   file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
--   io.input(file)
--   file:write("--- STARTED THE ACCESS PART ---")
--   access.execute(conf)
-- end

-- file:close()

-- return CtkHandler


local BasePlugin = require "kong.plugins.base_plugin"
local access = require "kong.plugins.ctk.access"

local ChostakHandler = BasePlugin:extend()
file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
io.input(file)
file:write("--- JUST EXTENDED THE BASE PLUGIN ---")

function ChostakHandler:new()
  ChostakHandler.super.new(self, "basic-auth")
  file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
  io.input(file)
  file:write("--- INSTACIATED ITSELF ---")  
end

function ChostakHandler:access(conf)
  ChostakHandler.super.access(self)
  access.execute(conf)
  file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
  io.input(file)
  file:write("--- STARTED THE ACCESS PART ---")
end

ChostakHandler.PRIORITY = 1001
ChostakHandler.VERSION = "0.1.0"

return ChostakHandler