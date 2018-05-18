local plugin_config_iterator = require("kong.dao.migrations.helpers").plugin_config_iterator

return {
  {
    name = "2015-06-09-ctk-auth",
    up = [[
      CREATE TABLE IF NOT EXISTS ctk_secrets(
        id uuid,
        consumer_id uuid,
        key text,
        secret text,
        created_at timestamp,
        PRIMARY KEY (id)
      );

      CREATE INDEX IF NOT EXISTS ON ctk_secrets(key);
      CREATE INDEX IF NOT EXISTS ON ctk_secrets(secret);
      CREATE INDEX IF NOT EXISTS ON ctk_secrets(consumer_id);
    ]],
    down = [[
      DROP TABLE ctk_secrets;
    ]]
  },
  {
    name = "2016-03-07-ctk-alg",
    up = [[
      ALTER TABLE ctk_secrets ADD algorithm text;
      ALTER TABLE ctk_secrets ADD rsa_public_key text;
    ]],
    down = [[
      ALTER TABLE ctk_secrets DROP algorithm;
      ALTER TABLE ctk_secrets DROP rsa_public_key;
    ]]
  },
  {
    name = "2017-07-31-120200_ctk-auth_preflight_default",
    up = function(_, _, dao)
      for ok, config, update in plugin_config_iterator(dao, "jwt") do
        if not ok then
          return config
        end
        if config.run_on_preflight == nil then
          config.run_on_preflight = true
          local _, err = update(config)
          if err then
            return err
          end
        end
      end
    end,
    down = function(_, _, dao) end  -- not implemented
  },
  {
    name = "2017-10-25-211200_ctk_cookie_names_default",
    up = function(_, _, dao)
      for ok, config, update in plugin_config_iterator(dao, "jwt") do
        if not ok then
          return config
        end
        if config.cookie_names == nil then
          config.cookie_names = {}
          local _, err = update(config)
          if err then
            return err
          end
        end
      end
    end,
    down = function(_, _, dao) end  -- not implemented
  },
}
