require 'uri'

class Params
  # use your initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  #
  # You haven't done routing yet; but assume route params will be
  # passed in as a hash to `Params.new` as below:
  def initialize(req, route_params = {})
    @params = {}
    if req.query_string
      @params.merge!(parse_www_encoded_form(req.query_string))
    end
    if req.body
      @params.merge!(parse_www_encoded_form(req.body))
    end
    @params.merge!(make_sym_keys(route_params)) if route_params

    @params
  end

  def [](key)
    @params[key.to_s]
  end

  def to_s
    @params.to_json.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  # this should return deeply nested hash
  # argument format
  # user[address][street]=main&user[address][zip]=89436
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
  def parse_www_encoded_form(www_encoded_form)
    {}.tap do |hash| 
      URI.decode_www_form(www_encoded_form).each do |pair|
        hash.deep_merge!(parse_key_and_value(pair[0],pair[1]))
      end
    end
  end
  
  def make_sym_keys(hash)
    {}.tap { |new_hash| hash.each { |key,value| new_hash[key.to_s] =
    value } }
  end

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end

  def parse_key_and_value(key,value)
    keys = parse_key(key)
    raise ArgumentError.new("Must be a non-empty array") if keys.empty?
    nest = { keys.pop.to_s => value }
    until keys.empty?
      nest ={ keys.pop.to_s => nest }
    end
    nest
  end
end
