local singletons = require "kong.singletons"
local BasePlugin = require "kong.plugins.base_plugin"
local responses = require "kong.tools.responses"
local utils = require "kong.tools.utils"
local constants = require "kong.constants"
local multipart = require "multipart"
local cjson = require "cjson"
local url = require "socket.url"
local access = require "kong.plugins.ctk.access"

local CtkHandler = BasePlugin:extend()
CtkHandler.PRIORITY = 3505
CtkHandler.VERSION = "0.1.0"
ngx.log(ngx.WARN, "--- ctk --- JUST EXTENDED THE BASE PLUGIN")

function CtkHandler:new()
  CtkHandler.super.new(self, "ctk")
  ngx.log(ngx.WARN, "--- ctk --- INSTACIATED ITSELF")
end

function CtkHandler:access(conf)
  CtkHandler.super.access(self)
  ngx.log(ngx.WARN, "--- ctk --- STARTED THE ACCESS PROCESS")
  access.execute(conf)
end

return CtkHandler