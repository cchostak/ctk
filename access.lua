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
local string_format = string.format
local cjson_encode = cjson.encode
local ipairs = ipairs
local request = ngx.request

local _M = {}

local function retrieve_token(request, conf)
    file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
    io.input(file)
    file:write("--- RUNNING RETRIEVE TOKEN ---")  
    local uri_parameters = request.get_uri_args()
  
    for _, v in ipairs(conf.uri_param_names) do
      if uri_parameters[v] then
        return uri_parameters[v]
      end
    end
  
    local ngx_var = ngx.var
    for _, v in ipairs(conf.cookie_names) do
      local jwt_cookie = ngx_var["cookie_" .. v]
      if jwt_cookie and jwt_cookie ~= "" then
        return jwt_cookie
      end
    end
  
    local authorization_header = request.get_headers()["authorization"]
    if authorization_header then
      local iterator, iter_err = ngx_re_gmatch(authorization_header, "\\s*[Bb]earer\\s+(.+)")
      if not iterator then
        return nil, iter_err
      end
  
      local m, err = iterator()
      if err then
        return nil, err
      end
  
      if m and #m > 0 then
        return m[1]
      end
    end
  end
  
  local function do_authentication(conf)
    file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
    io.input(file)
    file:write("--- RUNNING DO_AUTHENTICATION ---")  
    local token, err = retrieve_token(ngx.req, conf)
    if err then
      return responses.send_HTTP_INTERNAL_SERVER_ERROR(err)
    end
  
    local ttype = type(token)
    if ttype ~= "string" then
      if ttype == "nil" then
        return false, {status = 401}
      elseif ttype == "table" then
        return false, {status = 401, message = "Multiple tokens provided"}
      else
        return false, {status = 401, message = "Unrecognizable token"}
      end
      append_uri(token)
      return true
    end
  end
  
  local function append_uri(token)
    file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
    io.input(file)
    file:write("--- FUNCTION APPEND_URL ---")
    -- local uri = ngx.get_uri_args
    ngx.var.upstream_uri(ngx.var.unescape_uri("/" .. token))
  end

  return _M
  