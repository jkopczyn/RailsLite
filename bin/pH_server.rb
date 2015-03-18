require 'webrick'
require_relative '../lib/phaseHigher/controller_base'
require_relative '../lib/phaseHigher/router'
require_relative 'classes.rb'


router = Phase6::Router.new
router.draw do
  get Regexp.new("^/cats$"), Cats2Controller, :index
  get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
