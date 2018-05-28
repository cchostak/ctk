package = "kong-plugin-ctk"
version = "1.0-1"              

local pluginName = package:match("^kong%-plugin%-(.+)$")  -- "ctk"

supported_platforms = {"linux", "macosx"}

source = {
   url = "https://github.com/cchostak/ctk"
}

description = {
   summary = "Retrieve a JWT from header and confront it against another service.",
   detailed = [[
   Retrieves a JWT in the Authorization field of the header and send a request
   to a known service that generated that JWT to check wheter or not it is
   valid
   ]],
   homepage = "https://github.com/cchostak/ctk2", 
   license = "MIT/X11" 
}

dependencies = {
   "lua >= 5.1, < 5.4"
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins."..pluginName..".handler"] = "kong/plugins/"..pluginName.."/handler.lua",
    ["kong.plugins."..pluginName..".schema"] = "kong/plugins/"..pluginName.."/schema.lua",
  }
}
