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
        CtkHandler.super.access(self)
        ngx.log(ngx.WARN, "--- ctk --- STARTED THE ACCESS PROCESS")

        -- GET JWT FROM HEADER AND ASSIGN TO TOKEN VARIABLE
        token = ngx.req.get_headers()["Authorization"]
        -- CHECK WHETER THE JWT EXISTS OR NOT
        if token == nil then
                ngx.log(ngx.CRIT, "--- FORBIDDEN ---")
                return responses.send_HTTP_FORBIDDEN("You cannot consume this service")
        else
                ngx.log(ngx.WARN, token)
                                -- ngx.req.set_header("Content-Type", "application/json")
                                -- uri = "/" .. token
                -- SET THE UPSTREAM URI TO ANOTHER SERVICE
                ngx.var.upstream_uri = "http://localhost:8000/authenticate/" .. token
                                -- ngx.var.request_uri = tostring(uri) NOT CHANGEABLE
                                -- ngx.req.set_uri_args(uri) CHANGES NOTHING
                                -- url = "http://192.168.50.172:3315/v1/usr/access/" .. token
                -- ASSIGN THE NEW UPSTREAM URI TO ANOTHER VARIABLE
                url = ngx.var.upstream_uri
                ngx.log(ngx.WARN, tostring(ngx.var.upstream_uri))
                                --ngx.escape_uri(token)
                                --
                                -- redirect = ngx.redirect(url, ngx.HTTP_TEMPORARY_REDIRECT)
                -- TRY TO SEND IN A MYRIAD OF WAYS THE REQUEST TO ANOTHER SERVICE
                res1, res2, res3 = ngx.location.capture_multi{
                { "/authenticate", { method = ngx.HTTP_POST, body = token} },
                { "/access", { method = ngx.HTTP_POST, uri = token} },
                { ngx.redirect(url, ngx.HTTP_TEMPORARY_REDIRECT)}
                }
                        if res1.status == ngx.HTTP_OK then
                                ngx.log(ngx.CRIT, "--- AUTHENTICATE COM BODY = TOKEN FUNCIONOU  ---")
                        else
                                ngx.log(ngx.CRIT, "--- AUTHENTICATE COM BODY NÃO FUNCIONOU ---")
                        end
                        if res2.status == ngx.HTTP_OK then
                                ngx.log(ngx.CRIT, "--- ACCESS COM URI = TOKEN FUNCIONOU  ---")
                        else
                                ngx.log(ngx.CRIT, "--- ACCESS COM URI NÃO FUNCIONOU ----")
                        end
                        if res3.status == ngx.HTTP_OK then
                                ngx.log(ngx.CRIT, "--- REDIRECT COM RETORNO FUNCIONOU  ---")
                        else
                                ngx.log(ngx.CRIT, "--- REDIRECT COM RETORNO NÃO FUNCIONOU ---")
                        end
                ngx.log(ngx.WARN, tostring(res1.status))

        end
     end

return CtkHandler