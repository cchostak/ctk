return {
  no_consumer = true,
  fields = {
    key_names = {type = "array", required = true, default = {"ctk"}},
    method = { default = "POST", enum = { "POST", "PUT", "PATCH" } },
    run_on_preflight = {type = "boolean", default = true},
    uri_param_names = {type = "array", default = {"jwt"}},
    content_type = { default = "application/json", enum = { "application/json" } }
  }
}