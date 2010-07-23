module Unfuddler
  class << self
    attr_accessor :username, :password, :subdomain, :http

    def authenticate(info)
      @username, @password, @subdomain = info[:username] || info["username"], info[:password] || info["password"], info[:subdomain] || info["subdomain"]
      @http = Net::HTTP.new("#{@subdomain}.unfuddle.com", 80)
    end

    def authenticated?
      true if @http
    end

    def request(type, url, data = nil)
      raise "Not authenticated!" unless authenticated?

      request = eval("Net::HTTP::#{type.to_s.capitalize}").new("/api/v1/#{url}", {'Content-type' => "application/xml"})
      request.basic_auth @username, @password

      request.body = data if data
      request = @http.request(request)

      handle_response(request.body, request.code)
    end

    def handle_response(body, code)
      valid_codes = [201, 200, 302]
      raise "Server returned response code: " + code unless valid_codes.include?(code.to_i)

      Crack::XML.parse(body)
    end

    [:get, :put, :post, :delete].each do |method|
      define_method(method) do |*args|
        # Ruby 1.8 fix, in 1.9 we could just do define.. do |url, data = nil|
        url, data = args
        request(method, url, data)
      end
    end

    def parse_specification(objects, specification)
      if specification.is_a?(String)
        finder(objects, {:short_name => specification})
      elsif specification.is_a?(Hash)
        finder(objects, specification)
      elsif specification.is_a?(Fixnum)
        finder(objects, {:id => specification})
      elsif specification == :all
        objects
      elsif specification == :first
        objects.first
      elsif specification == :last
        objects.last
      else
        objects
      end
    end

    def finder(objects, specifications)
      objects.select do |object|
        specifications.all? do |method, expected_value|
          object.send(method) == expected_value
        end
      end
    end
  end
end
