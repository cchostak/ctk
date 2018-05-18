local crud = require "kong.api.crud_helpers"

return {
  ["/consumers/:username_or_id/jwt/"] = {
    before = function(self, dao_factory, helpers)
      crud.find_consumer_by_username_or_id(self, dao_factory, helpers)
      self.params.consumer_id = self.consumer.id
    end,

    GET = function(self, dao_factory)
      crud.paginated_set(self, dao_factory.ctk_secrets)
    end,

    PUT = function(self, dao_factory, helpers)
      crud.put(self.params, dao_factory.ctk_secrets)
    end,

    POST = function(self, dao_factory, helpers)
      crud.post(self.params, dao_factory.ctk_secrets)
    end
  },

  ["/consumers/:username_or_id/jwt/:jwt_key_or_id"] = {
    before = function(self, dao_factory, helpers)
      crud.find_consumer_by_username_or_id(self, dao_factory, helpers)
      self.params.consumer_id = self.consumer.id

      local credentials, err = crud.find_by_id_or_field(
        dao_factory.ctk_secrets,
        { consumer_id = self.params.consumer_id },
        ngx.unescape_uri(self.params.jwt_key_or_id),
        "key"
      )

      if err then
        return helpers.yield_error(err)
      elseif next(credentials) == nil then
        return helpers.responses.send_HTTP_NOT_FOUND()
      end
      self.params.jwt_key_or_id = nil

      self.ctk_secret = credentials[1]
    end,

    GET = function(self, dao_factory, helpers)
      return helpers.responses.send_HTTP_OK(self.ctk_secret)
    end,

    PATCH = function(self, dao_factory)
      crud.patch(self.params, dao_factory.ctk_secrets, self.ctk_secret)
    end,

    DELETE = function(self, dao_factory)
      crud.delete(self.ctk_secret, dao_factory.ctk_secrets)
    end
  },
  ["/jwts/"] = {
    GET = function(self, dao_factory)
      crud.paginated_set(self, dao_factory.ctk_secrets)
    end
  },
  ["/jwts/:jwt_key_or_id/consumer"] = {
    before = function(self, dao_factory, helpers)
      local credentials, err = crud.find_by_id_or_field(
        dao_factory.ctk_secrets,
        nil,
        ngx.unescape_uri(self.params.jwt_key_or_id),
        "key"
      )

      if err then
        return helpers.yield_error(err)
      elseif next(credentials) == nil then
        return helpers.responses.send_HTTP_NOT_FOUND()
      end

      self.params.jwt_key_or_id = nil
      self.params.username_or_id = credentials[1].consumer_id
      crud.find_consumer_by_username_or_id(self, dao_factory, helpers)
    end,

    GET = function(self, dao_factory,helpers)
      return helpers.responses.send_HTTP_OK(self.consumer)
    end
  }
}
