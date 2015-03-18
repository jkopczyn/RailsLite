require_relative '../phase6/controller_base'
require_relative '../phase6/router'

module PhaseHigher
  class ControllerBase < Phase6::ControllerBase
    attr_accessor :flash

    def initialize(req,res,route_params = {})
      @flash = Flash.new(req)
      super
    end
  end

  class Flash
    attr_writer :now

    def initialize(req)
      cookie = req.cookies.find do |cookie| 
        cookie.name == "_rails_lite_flash"
      end
      if cookie
        @now = JSON.parse(our_cookie.value)
      else
        @now ||= {}
      end

      @later = {}
    end

    def[](key)
      @now[key]
    end

    def[]=(key,value)
      @later[key]=value
      @now[key]=value
    end
#
#    def now[]=(key,value)
#      @now[key]=value
#    end
    
    def store_session(res)
      cookie = WEBrick::Cookie.new("_rails_lite_flash", @later.to_json)
      res.cookies << cookie
    end
  end
end
