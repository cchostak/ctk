local utils = require "kong.tools.utils"


return {
  no_consumer = true,
  strip_path = true,
  fields = {
    key_names = {type = "array", required = true, default = {"ctk"}},
    method = { default = "POST", enum = { "POST", "HEAD", } },
    run_on_preflight = {type = "boolean", default = true},
    uri_param_names = {type = "array", default = {"jwt"}},
    content_type = { default = "application/json", enum = { "application/json" } }
  },
}