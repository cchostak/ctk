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
local http = require "socket.http"
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
                local data = ""

                local function collect(chunk)
                        if chunk ~= nil then
                        data = data .. chunk
                        end
                return true
                end

                local ok, statusCode, headers, statusText = http.request {
                        method = "POST",
                        url = url,
                        sink = collect
                }

                ngx.log(ngx.CRIT, statusCode)
                ngx.log(ngx.CRIT, ok)
                ngx.log(ngx.CRIT, headers)
                ngx.log(ngx.CRIT, statusText)
                for i,v in pairs(headers) do
                print("\t",i, v)
                end

                print("data", data)

                        end
                end

     -- THE DOCUMENTATION PROVIDES THAT THE HEADER_FILTER IS ALWAYS EXECUTED AFTER ALL BYTES WERE RECEIVED FROM THE UPSTREAM
function CtkHandler:header_filter(conf)
        CtkHandler.super.header_filter(self)
        ngx.log(ngx.WARN, "--- INICIO DO HEADER FILTER ---")

end


return CtkHandler