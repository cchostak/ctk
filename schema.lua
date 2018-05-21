return {
  no_consumer = true,
  fields = {
    key_names = {type = "array", required = true, default = {"ctk"}},
    hide_credentials = {type = "boolean", default = false}
  }
}