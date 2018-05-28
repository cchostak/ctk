local singletons = require "kong.singletons"
local BasePlugin = require "kong.plugins.base_plugin"
local responses = require "kong.tools.responses"
local constants = require "kong.constants"
local utils = require "kong.tools.utils"
local cjson = require "cjson"
local url = require "socket.url"
local http = require "socket.http"
local ipairs = ipairs

local CtkHandler = BasePlugin:extend()
CtkHandler.PRIORITY = 3505
CtkHandler.VERSION = "0.1.0"

function CtkHandler:new()
  CtkHandler.super.new(self, "ctk")
end

function CtkHandler:access(conf)
        CtkHandler.super.access(self)
        uriRetrieved = ngx.var.uri
        host = ngx.var.host
        -- GET JWT FROM HEADER AND ASSIGN TO TOKEN VARIABLE
        token = ngx.req.get_headers()["Authorization"]
        -- CHECK WHETER THE JWT EXISTS OR NOT
        if token == nil then
                ngx.log(ngx.CRIT, "--- FORBIDDEN ---")
                ngx.log(ngx.CRIT, token)
                return responses.send_HTTP_FORBIDDEN("You cannot consume this service")
        else
                ngx.log(ngx.CRIT, "--- TOKEN ---")
                ngx.log(ngx.CRIT, token)
                -- SET THE URL THAT WILL BE USED TO VALIDADE THE JWT
                -- CONF.URL RECEIVES THE URL USED UPON INSTALLATION OF THE PLUGIN
                ura = conf.url .. token
                -- THE HTTP REQUEST THAT TEST IF JWT IS VALID OR NOT
                local data = ""

                local function collect(chunk)
                        if chunk ~= nil then
                        data = data .. chunk
                        end
                return true
                end

                local ok, statusCode, headers, statusText = http.request {
                        method = "POST",
                        url = ura,
                        sink = collect
                }

                -- THE STATUS CODE RETRIEVED FROM THE SERVICE
                if statusCode == 200 then
                        ngx.log(ngx.CRIT, "### STATUS 200 OK ###")
                        ngx.log(ngx.CRIT, uriRetrieved)
                else
                        ngx.log(ngx.CRIT, "### NÃO AUTORIZADO ###")
                        return responses.send_HTTP_FORBIDDEN("You cannot consume this service")
                end

        end
end

return CtkHandler