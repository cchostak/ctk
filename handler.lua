local singletons = require "kong.singletons"
local BasePlugin = require "kong.plugins.base_plugin"
local responses = require "kong.tools.responses"
local constants = require "kong.constants"
local multipart = require "multipart"
local cjson = require "cjson"
local url = require "socket.url"
local basic_serializer = require "kong.plugins.log-serializers.basic"
string_format  = string.format
ngx_set_header = ngx.req.set_header
get_method     = ngx.req.get_method
req_set_uri_args = ngx.req.set_uri_args
req_get_uri_args = ngx.req.get_uri_args
req_set_header = ngx.req.set_header
req_get_headers = ngx.req.get_headers
req_clear_header = ngx.req.clear_header
req_set_method = ngx.req.set_method
ngx_decode_args = ngx.decode_args
ngx_re_gmatch  = ngx.re.gmatch
string_format = string.format
cjson_encode = cjson.encode
ipairs = ipairs
request = ngx.request

CtkHandler = BasePlugin:extend()

file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
io.input(file)
file:write("--- JUST EXTENDED THE BASE PLUGIN ---")


function CtkHandler:new()
CtkHandler.super.new(self, "ctk")
file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
io.input(file)
file:write("--- INSTACIATED ITSELF ---")  
end


function CtkHandler:access()
  CtkHandler.super.access(self)
  file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
  io.input(file)
  file:write("--- STARTED THE ACCESS PART ---")
  file:write("--- WILL RUN THE REQUEST FOR URI ---")
  
  local uri_parameters = request.get_uri_args()
  file:write(uri_parameters)

    for _, v in ipairs(conf.uri_param_names) do
      if uri_parameters[v] then
        return uri_parameters[v]
      else 
      return {status = 401, message = "Falha na busca por parâmetros URI"}
      end
    end

    file:write("-- Tried to read token in cookies")
    local ngx_var = ngx.var
    for _, v in ipairs(conf.cookie_names) do
      local jwt_cookie = ngx_var["cookie_" .. v]
      if jwt_cookie and jwt_cookie ~= "" then
        return jwt_cookie
      else
        return {status = 401, message = "Falha na busca por cookies"}
      end
    end

    file:write("-- Tried to read token in the header")
    local authorization_header = request.get_headers()["authorization"]
    if authorization_header then
      local iterator, iter_err = ngx_re_gmatch(authorization_header, "\\s*[Bb]earer\\s+(.+)")
      if not iterator then
        return nil, iter_err
      else
        return {status = 401, message = "Falha na busca pelo campo Autorização"}
      end
  
      local m, err = iterator()
      if err then
        return nil, err
      end
      -- Theoretically the token JWT is assigned to m
      if m and #m > 0 then
        return m[1]
      end
      ngx.req.set_uri(ngx.unescape_uri("/" .. m[1]))
      file:write("-- The URI should have the token now", m, m[1], err, iterator)
    end
end

file:close()

return CtkHandler