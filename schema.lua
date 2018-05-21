local utils = require "kong.tools.utils"
local find = string.find

return {
  no_consumer = true,
  fields = {
    http_method = {type = "string", func = check_method},
    key_names = {type = "array", required = true, default = {"ctk"}},
    remove = {
      type = "table",
      schema = {
        fields = {
          body = {type = "array", default = {}}, -- does not need colons
          headers = {type = "array", default = {}}, -- does not need colons
          querystring = {type = "array", default = {}} -- does not need colons
        }
      }
    },
    rename = {
      type = "table",
      schema = {
        fields = {
          body = {type = "array", default = {}},
          headers = {type = "array", default = {}},
          querystring = {type = "array", default = {}}
        }
      }
    }
    -- replace = {
    --   type = "table",
    --   schema = {
    --     fields = {
    --       body = {type = "array", default = {}, func = check_for_value},
    --       headers = {type = "array", default = {}, func = check_for_value},
    --       querystring = {type = "array", default = {}, func = check_for_value}
    --     }
    --   }
    -- },
    -- add = {
    --   type = "table",
    --   schema = {
    --     fields = {
    --       body = {type = "array", default = {}, func = check_for_value},
    --       headers = {type = "array", default = {}, func = check_for_value},
    --       querystring = {type = "array", default = {}, func = check_for_value}
    --     }
    --   }
    -- },
    -- append = {
    --   type = "table",
    --   schema = {
    --     fields = {
    --       body = {type = "array", default = {}, func = check_for_value},
    --       headers = {type = "array", default = {}, func = check_for_value},
    --       querystring = {type = "array", default = {}, func = check_for_value}
    --     }
    --   }
    -- }
  }
}
