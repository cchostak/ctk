return {
  no_consumer = true,
  fields = {
    key_names = {type = "array", required = true, default = {"ctk"}},
    http_endpoint = { required = true, type = "url" },
    method = { default = "POST", enum = { "POST", "PUT", "PATCH" } },
    run_on_preflight = {type = "boolean", default = true},
    content_type = { default = "application/json; charset=utf-8", enum = { "application/json; charset=utf-8" } }
  }
}