local singletons = require "kong.singletons"
local BasePlugin = require "kong.plugins.base_plugin"
local responses = require "kong.tools.responses"
local constants = require "kong.constants"

local ipairs         = ipairs
local string_format  = string.format
local ngx_re_gmatch  = ngx.re.gmatch
local ngx_set_header = ngx.req.set_header
local get_method     = ngx.req.get_method
local multipart = require "multipart"
local cjson = require "cjson"

local _M = {}

local table_insert = table.insert
local req_set_uri_args = ngx.req.set_uri_args
local req_get_uri_args = ngx.req.get_uri_args
local req_set_header = ngx.req.set_header
local req_get_headers = ngx.req.get_headers
local req_read_body = ngx.req.read_body
local req_set_body_data = ngx.req.set_body_data
local req_get_body_data = ngx.req.get_body_data
local req_clear_header = ngx.req.clear_header
local req_set_method = ngx.req.set_method
local encode_args = ngx.encode_args
local ngx_decode_args = ngx.decode_args
local type = type
local string_find = string.find
local pcall = pcall
local ngx_re_gmatch  = ngx.re.gmatch

local CONTENT_LENGTH = "content-length"
local CONTENT_TYPE = "content-type"
local HOST = "host"

local CtkHandler = BasePlugin:extend()

function CtkHandler:new()
  CtkHandler.super.new(self, "ctk")
  
end

function CtkHandler:access(conf)
  CtkHandler.super.access(self)

  local authorization_header = req_get_headers()["authorization"],
  local jwt_hash = ngx_re_gmatch(authorization_header, "\\s*[Bb]earer\\s+(.+)"),
  ngx.req.set_uri(ngx.unescape_uri("\\" .. jwt_hash))

end

return CtkHandler