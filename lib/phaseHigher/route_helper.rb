module PhaseHigher
  module RouteHelpers
    def generate_path(path_string)
      generate_regex(path_string)
      @path = path_string
    end

    def generate_regex(path_string)
      #should take  /tweets/:tweet_id/replies
        #and generate /\/tweets\/([^\/]*)\/replies
      names = path_string.scan(/\:(\w+)(\/|$)/).map { |match,term| match }
      prepped_string = path_string.gsub(/\:\w+/,).each_with_index do |match, index|
        match = match.gsub(/\W/,"")
        '(?<'+"#{match}>\\w+)"
      end
      @path = path_string
      @pattern = %r[#{prepped_string}]
    end

    def correct_url
      if @path.match(%r[#{single_name}])
        single_url
      elsif @path.match(%r[#{plural_name}])
        plural_url
      else
        raise "Can't Find That Automatically"
      end
    end

    private
    def single_name 
      @single_name ||= @controller_class.to_s.underscore.gsub(/_controller/,"")
    end

    def plural_name
      @plural_name ||= @single_name.pluralize
    end

    def single_url
      @single_url ||= "#{single_name}_url"
    end

    def plural_url
      @plural_url ||= "#{plural_name}_url"
    end
    #define_method("#{single_name}_url", &{ @path })
  end
end

#link_to "Something", something_dark_path
#button_to "Something", something_the_path, method: :force
#These should hand a render fragment back to the controller
#So they belong in the controller

if true && __FILE__ == $PROGRAM_NAME
  class Dummy < Object
    include PhaseHigher::RouteHelpers
    
    def initialize(string)
      @pattern = generate_regex(string)
    end

    def match(string)
      @pattern.match(string)
    end
  end
end
