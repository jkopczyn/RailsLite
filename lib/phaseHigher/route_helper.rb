require_relative '../phase6/router'

module PhaseHigher
  class Route < Phase6::Route
    #include RouteHelpers
    #will take RouteHelpers module
  end

  module RouteHelpers
    def generate_path
    end

    def generate_regex(path_string)
      #should take  /tweets/:tweet_id/replies
        #and generate /\/tweets\/([^\/]*)\/replies
      names = path_string.scan(/\:(\w+)(\/|$)/).map { |match,term| match }
      string = path_string.gsub(/\:\w+/,).each_with_index do |match, index|
        '(?'+"#{names[index]}\\w+)"
      end
      @regex = %r[#{string}]
    end
  end
end

#link_to "Something", something_dark_path
#button_to "Something", something_the_path, method: :force
#These should hand a render fragment back to the controller
#So they belong in the controller

