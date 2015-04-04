require_relative '../phase6/router'
require_relative 'route_helper'

module PhaseHigher
  class Route
    include RouteHelpers
    def initialize(params)
      debugger
      @pattern = params[:regex] || generate_regex(params[:string])
      @path ||= params[:string] 
      @http_method = params[:method]
      @controller_class = params[:controller]
      @action_name = params[:action]
      single_url
      plural_url
    end

    def matches?(req)
      debugger
      !!(@pattern =~ req.path) && 
          req.request_method.downcase.to_sym == http_method
    end

    # use pattern to pull out route params (save for later?)
    # instantiate controller and call controller action
    def run(req, res)
      route_match = @pattern.match(req.path)
      route_params = {}
      route_match.names.each do |name|
        route_params[name] = route_match[name]
      end
      control = @controller_class.new(req, res, route_params)
      control.invoke_action(@action_name)
    end
  end

  class Router
    def initialize
      @routes = []
    end

    # simply adds a new route to the list of routes
    def add_route(params)
      @routes << Route.new(params)
      new_route = @routes.last
      define_method(new_route.correct_url.to_sym) &(Proc.new {
      new_route.path } )
    end

    # evaluate the proc in the context of the instance
    # for syntactic sugar :)
    def draw(&proc)
      instance_eval(&proc)
    end

    [:get, :post, :put, :delete].each do |http_method|
      define_method(http_method) do |route, controller_class, action_name|
        route_string = (route.is_a?(String) ? route : nil)
        pattern = (route.is_a?(Regexp) ? pattern : nil)
        add_route(regex: pattern, string: route_string, method: http_method, 
                  controller: controller_class, action: action_name)
      end
    end

    def match(req)
      @routes.find { |route| route.matches?(req) } 
    end

    # either throw 404 or call run on a matched route
    def run(req, res)
      route = match(req)
      if route.nil?
        res.status = 404
      else
        route.run(req,res)
      end
    end

  end
end
