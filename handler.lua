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
                -- SET THE UPSTREAM URI TO ANOTHER SERVICE
                ngx.var.upstream_uri = "http://localhost:8000/authenticate/" .. token
                -- ASSIGN THE NEW UPSTREAM URI TO ANOTHER VARIABLE
                url = ngx.var.upstream_uri
                ngx.log(ngx.WARN, tostring(ngx.var.upstream_uri))
                -- THE REDIRECT THAT I'M TRYING TO GET RID OFF
                redirect = ngx.redirect(url, ngx.HTTP_TEMPORARY_REDIRECT)
                -- THE IMPLEMENTATION OF SUBREQUEST TO LOCAL PROXY
                local authenticate = ngx.location.capture("/authenticate/" .. token)
                if authenticate.status >= 500 then
                        return responses.send_HTTP_FORBIDDEN("Server Error")
                end
                ngx.log(ngx.WARN, authenticate.status)
                ngx.say(authenticate.body)
                ngx.log(ngx.WARN, status)
                req_set_uri_args(token)
        end
     end

     -- THE DOCUMENTATION PROVIDES THAT THE HEADER_FILTER IS ALWAYS EXECUTED AFTER ALL BYTES WERE RECEIVED FROM THE UPSTREAM
function CtkHandler:header_filter(conf)
        CtkHandler.super.header_filter(self)
        ngx.log(ngx.WARN, "--- INICIO DO HEADER FILTER ---")
        status = ngx.var.status
        tamanho = ngx.var.content_length
        host = ngx.var.host
        local h = ngx.resp.get_headers()
        -- THE IDEA WAS TO ITERATE THROUGH TABLE, TRYING TO SEE WHAT FIELD WOULD DENOTE THE STATUS 200 OK
        for k, v in pairs(h) do
                ngx.log(ngx.WARN, tostring(k))
                ngx.log(ngx.WARN, tostring(v))
        end
        host = ngx.req.get_headers()
        for a, b in pairs(host) do
                ngx.log(ngx.WARN, tostring(a))
                ngx.log(ngx.WARN, tostring(b))
        end
end


return CtkHandler