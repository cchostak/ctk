local singletons = require "kong.singletons"
local BasePlugin = require "kong.plugins.base_plugin"
local responses = require "kong.tools.responses"
local constants = require "kong.constants"
local multipart = require "multipart"
local cjson = require "cjson"
local url = require "socket.url"
local access = require "kong.plugins.ctk.access"

local CtkHandler = BasePlugin:extend()

CtkHandler.PRIORITY = 3505
CtkHandler.VERSION = "0.1.0"

file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
io.input(file)
file:write("--- JUST EXTENDED THE BASE PLUGIN ---")


function CtkHandler:new()
  CtkHandler.super.new(self, "ctk")
  file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
  io.input(file)
  file:write("--- INSTACIATED ITSELF ---")  
end

function CtkHandler:access(conf)
  CtkHandler.super.access(self)
  file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
  io.input(file)
  file:write("--- STARTED THE ACCESS PART ---")
  do_authentication()
  access.execute()
end

file:close()

return CtkHandler