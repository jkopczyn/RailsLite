require_relative '../active_record_lite/04_associatable2.rb'
require_relative 'router'
require_relative './params'
require_relative './session'

module PhaseHigher
  class ControllerBase 
    attr_reader :params, :req, :res

    # setup the controller
    def initialize(req, res, route_params = {})
      @req, @res = req, res
      @already_built_response = false
      @params= Params.new(req, route_params)
    end

    def already_built_response?
      @already_built_response
    end

    def session
      @session ||= Session.new(@req)
    end

    # Set the response status code and header
    def redirect_to(url)
      raise "Double Render" if self.already_built_response?
      
      session
      @res.status = 302
      @res["location"] = url
      @already_built_response = true
      session.store_session(@res)
    end

    def render(template_name)
      template = ERB.new(File.read(
        "views/#{self.class.to_s.underscore}/#{template_name}.html.erb"))
      render_content(template.result(binding),"text/html")
    end

    def render_content(content, content_type)
      raise "Double Render" if self.already_built_response?
      session
      @res.content_type = content_type
      @res.body = content
      @already_built_response = true
      session.store_session(@res)
    end

    # use this with the router to call action_name (:index, :show, :create...)
    def invoke_action(name)
      self.send(name.to_sym)
      render unless @already_built_response
    end
  end
end
