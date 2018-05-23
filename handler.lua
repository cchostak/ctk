local singletons = require "kong.singletons"
local BasePlugin = require "kong.plugins.base_plugin"
local responses = require "kong.tools.responses"
local constants = require "kong.constants"
local utils = require "kong.tools.utils"
local multipart = require "multipart"
local cjson = require "cjson"
local url = require "socket.url"
local basic_serializer = require "kong.plugins.log-serializers.basic"
local Router = require "kong.core.router"
local reports = require "kong.core.reports"
local balancer = require "kong.core.balancer"
local certificate = require "kong.core.certificate"
local string_format  = string.format
local ngx_set_header = ngx.req.set_header
local get_method     = ngx.req.get_method
local req_set_uri_args = ngx.req.set_uri_args
local req_get_uri_args = ngx.req.get_uri_args
local req_set_header = ngx.req.set_header
local req_get_headers = ngx.req.get_headers
local req_clear_header = ngx.req.clear_header
local req_set_method = ngx.req.set_method
local ngx_decode_args = ngx.decode_args
local ngx_re_gmatch  = ngx.re.gmatch
local cjson_encode = cjson.encode
local ipairs = ipairs
local request = ngx.request

local CtkHandler = BasePlugin:extend()
CtkHandler.PRIORITY = 3505
CtkHandler.VERSION = "0.1.0"
ngx.log(ngx.WARN, "--- ctk --- JUST EXTENDED THE BASE PLUGIN")

function CtkHandler:new()
  CtkHandler.super.new(self, "ctk")
  ngx.log(ngx.WARN, "--- ctk --- INSTACIATED ITSELF")
end

function CtkHandler:access(conf)
  function CtkHandler:access(conf)
    CtkHandler.super.access(self)
    ngx.log(ngx.WARN, "### ctk --- STARTED THE ACCESS PROCESS")
  
    token = tostring(ngx.req.get_headers()["Authorization"])
    ngx.log(ngx.WARN, token)
  
    --ngx.req.set_header("Content-Type", "application/json")
    --ngx.req.set_uri("/")
    url = "http://192.168.50.172:3315/v1/usr/access/" .. token
    --ngx.escape_uri(token)
    redirect = ngx.redirect(url, ngx.HTTP_TEMPORARY_REDIRECT)
    get = ngx.HTTP_GET
    ngx.log(ngx.WARN, get)
  
    if ngx.HTTP_GET == ngx.HTTP_OK then
            ngx.log(ngx.WARN, "### 200 ###")
            return
    else
            ngx.redirect("/authenticate", ngx.HTTP_UNAUTHORIZED)
            ngx.log(ngx.WARN, "### 401 ###")
    end
    if redirect == ngx.HTTP_OK then
            return
            ngx.log(ngx.WARN, "### STATUS 200 OK ###")
    else
            ngx.redirect("/authenticate", ngx.HTTP_UNAUTHORIZED)
            ngx.log(ngx.WARN, "### STATUS 401 UNAUTHORIZED ###")
    end
    --ngx.req.set_uri_args("/" .. token)
    --ngx.log(ngx.WARN, url)
  end
end

return CtkHandler