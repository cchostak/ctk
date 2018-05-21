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
local jwt_hash = ngx_re_gmatch(authorization_header, "\\s*[Bb]earer\\s+(.+)")
local ngx_re_gmatch  = ngx.re.gmatch

local CONTENT_LENGTH = "content-length"
local CONTENT_TYPE = "content-type"
local HOST = "host"
local DEST = "192.168.50.172:3315/v1/usr/access"
local JSON, MULTI, ENCODED, JWT = "json", "multi_part", "form_encoded", "jwt"

-- local function get_content_type(content_type)
--     if content_type == nil then
--       return
--     end
--     if string_find(content_type:lower(), "application/json", nil, true) then
--       return JSON
--     elseif string_find(content_type:lower(), "multipart/form-data", nil, true) then
--       return MULTI
--     elseif string_find(content_type:lower(), "application/json; charset=utf-8", nil, true) then
--       return JWT
--     elseif string_find(content_type:lower(), "application/x-www-form-urlencoded", nil, true) then
--       return ENCODED
--     end
--   end

 
local function transform_headers(conf)
    -- Remove header(s)
    for _, name, value in iter(conf.remove.headers) do
      req_clear_header(name)
    end
  
    -- Rename headers(s)
    for _, old_name, new_name in iter(conf.rename.headers) do
      if req_get_headers()[old_name] then
        local value = req_get_headers()[old_name]
        req_set_header(new_name, "Authorization: Bearer " .. jwt_hash)
        req_clear_header(old_name)
      end
    end
  
  --   -- Replace header(s)
  --   for _, name, value in iter(conf.replace.headers) do
  --     if req_get_headers()[name] then
  --       req_set_header(name, value)
  --       if name:lower() == HOST then -- Host header has a special treatment
  --         ngx.var.upstream_host = value
  --       end
  --     end
  --   end
  
  --   -- Add header(s)
  --   for _, name, value in iter(conf.add.headers) do
  --     if not req_get_headers()[name] then
  --       req_set_header(name, value)
  --       if name:lower() == HOST then -- Host header has a special treatment
  --         ngx.var.upstream_host = value
  --       end
  --     end
  --   end
  
  --   -- Append header(s)
  --   for _, name, value in iter(conf.append.headers) do
  --     req_set_header(name, append_value(req_get_headers()[name], value))
  --     if name:lower() == HOST then -- Host header has a special treatment
  --       ngx.var.upstream_host = value
  --     end
  --   end
  -- end
  


  function _M.execute(conf)
    transform_headers(conf)
  end
  
  return _M