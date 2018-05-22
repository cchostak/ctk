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
HTTP = "http"
HTTPS = "https"

CtkHandler = BasePlugin:extend()

file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
io.input(file)

local function retrieve_token(request, conf)
  file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
  io.input(file)
  file:write("-- Tried to read token in request")
    local uri_parameters = request.get_uri_args()
  
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
      ngx.req.set_uri(ngx.unescape_uri("/" .. request))
      file:write("-- The URI should have the token now", m, m[1], err, iterator)
    end
  end


function CtkHandler:new()
file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
io.input(file)
  CtkHandler.super.new(self, "ctk")
file:write("-- Instanciated itself")  
end



-- Generates the raw http message.
-- @param `method` http method to be used to send data
-- @param `content_type` the type to set in the header
-- @param `parsed_url` contains the host details
-- @param `body`  Body of the message as a string (must be encoded according to the `content_type` parameter)
-- @return raw http message
local function generate_post_payload(method, content_type, parsed_url, body)
file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
io.input(file)
file:write("--Function generate-post-payload")
  local url
  if parsed_url.query then
    url = parsed_url.path .. "?" .. parsed_url.query
  else
    url = parsed_url.path
  end
  local headers = string_format(
    "%s %s HTTP/1.1\r\nHost: %s\r\nConnection: Keep-Alive\r\nContent-Type: %s\r\nContent-Length: %s\r\n",
    method:upper(), url, parsed_url.host, content_type, #body)

  if parsed_url.userinfo then
    local auth_header = string_format(
      "Authorization: Basic %s\r\n",
      ngx.encode_base64(parsed_url.userinfo)
    )
    headers = headers .. auth_header
  end

  return string_format("%s\r\n%s", headers, body)
end

-- Parse host url.
-- @param `url` host url
-- @return `parsed_url` a table with host details like domain name, port, path etc
local function parse_url(host_url)
file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
io.input(file)
file:write("--Function generate-post-payload")
  local parsed_url = url.parse(host_url)
  if not parsed_url.port then
    if parsed_url.scheme == HTTP then
      parsed_url.port = 80
     elseif parsed_url.scheme == HTTPS then
      parsed_url.port = 443
     end
  end
  if not parsed_url.path then
    parsed_url.path = "/"
  end
  return parsed_url
end

function CtkHandler:access(conf)
  CtkHandler.super.access(self)
  file = io.open("/usr/local/kong/logs/ctk.lua", "a+")
  io.input(file)
  file:write("--Function: CtkHandler:access")

  retrieve_token(nil)
end

file:close()

return CtkHandler