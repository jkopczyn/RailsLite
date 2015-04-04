require 'webrick'
require_relative '../lib/phaseHigher/controller_base'
require_relative '../lib/phaseHigher/router'
require_relative 'classes.rb'


router = PhaseHigher::Router.new
router.draw do
  get "/cats", CatsController, :index
  get "/cats/:cat_id/statuses", StatusesController, :index
  get "/", CatsController, :index
  get "/cat/:id", CatsController, :show
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
