module Desuraify
  # base class to inherit, hopefully reducing duplicate code

  class Base

    attr_reader :id
    attr_reader :hydra
    attr_reader :callback
    attr_reader :error

    def initialize(id, options={})
      @id = id
      @hydra = options[:hydra] || Desuraify.hydra
      @request_opts = options[:request_opts] || {}
      @callback = nil
      @error = nil
    end

    def update
      resp = Typhoeus::Request.get(url, @request_opts)
      result = handle_response(resp)
      update_callback(result)

      self
    end

    def enqueue_update(&block)
      @callback = block
      @error = nil

      request = Typhoeus::Request.new(url, @request_opts)

      request.on_complete do |response|
        result = nil

        begin
          result = handle_response(response)
        rescue Exception => e
          @error = e
        end

        update_callback(result)
      end

      hydra.queue(request)

      self
    end

    def to_s
      "#{@title}" rescue self
    end

    private

    def handle_response(response)
      if response.success?
        self.class.parse(response.body)
      else
        raise Desuraify::ResponseError.new("Got unexpected response code: #{response.code}")
      end
    end

    def update_callback(result)
      unless @error
        self.attributes.each do |a|
          attr_name = "@#{a}"
          attr_value = result[a]
          instance_variable_set(attr_name, attr_value)
        end
      end

      @callback.call(self) if @callback
    end

  end
end