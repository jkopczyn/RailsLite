#require 'byebug'
require 'json'
require 'webrick'

module PhaseHigher
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      our_cookie = req.cookies.find do |cookie| 
        cookie.name == "_rails_lite_app"
      end
      if our_cookie
        @session = JSON.parse(our_cookie.value)
      else
        @session ||= {}
      end
    end

    def [](key)
      @session[key]
    end

    def []=(key, val)
      @session[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      cookie = WEBrick::Cookie.new("_rails_lite_app", @session.to_json)
      res.cookies << cookie
    end
  end
end
