local singletons = require "kong.singletons"
local BasePlugin = require "kong.plugins.base_plugin"
local responses = require "kong.tools.responses"
local constants = require "kong.constants"
local access = require "kong.plugins.ctk.access"

local ipairs         = ipairs
local string_format  = string.format
local ngx_re_gmatch  = ngx.re.gmatch
local ngx_set_header = ngx.req.set_header
local get_method     = ngx.req.get_method

CTK.PRIORITY = 1200
CTK.VERSION = "0.0.1"

local CtkHandler = BasePlugin:extend()

function CtkHandler:new()
  CtkHandler.super.new(self, "ctk")
end

function CtkHandler:access(conf)
  access.execute(conf)
  -- print(config.environment) 
  -- print(config.server.host)
  -- print(config.server.port)
  -- print(config.key_names)
  -- print(config.hide_credentials)
end

return CtkHandler