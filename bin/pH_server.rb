require 'webrick'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative 'classes.rb'


router = Router.new
router.draw do
  get Regexp.new("^/cats$"), CatsController, :index
  get Regexp.new("^/cats/new$"), CatsController, :new
  get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
  get Regexp.new("^/?$"), CatsController, :index
  get Regexp.new("^/cat/(?<id>\\d+)$"), CatsController, :show
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
