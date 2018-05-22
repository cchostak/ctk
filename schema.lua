return {
  no_consumer = true,
  fields = {
    key_names = {type = "array", required = true, default = {"ctk"}},
    http_endpoint = { required = true, type = "url" },
    method = { default = "POST", enum = { "POST", "PUT", "PATCH" } },
    run_on_preflight = {type = "boolean", default = true},
    uri_param_names = {type = "array", default = {"jwt"}},
    cookie_names = {type = "array", default = {}},
    key_claim_name = {type = "string", default = "iss"},
    secret_is_base64 = {type = "boolean", default = false},
    claims_to_verify = {type = "array", enum = {"exp", "nbf"}},
    anonymous = {type = "string", default = "", func = check_user},
    run_on_preflight = {type = "boolean", default = true},
    content_type = { default = "application/json; charset=utf-8", enum = { "application/json; charset=utf-8" } }
  }
}