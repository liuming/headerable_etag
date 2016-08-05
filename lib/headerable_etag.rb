require "headerable_etag/version"
require 'digest/sha2'

module HeaderableEtag
  def self.headers_string(current_headers, header_keys_for_etag)
    header_values_for_etag = current_headers.values_at(*header_keys_for_etag)
    headers_string = header_values_for_etag.sort.join
    return headers_string
  end

  def self.etag_with_headers(current_headers, header_keys_for_etag)
    headers_string_for_etag = headers_string(current_headers, header_keys_for_etag)
    new_etag = digest(headers_string_for_etag + current_headers['ETag'])
    return new_etag
  end

  def self.digest(string)
    Digest::SHA256.hexdigest(string).byteslice(0,32)
  end

  class Middleware
    def initialize(app, header_keys_for_etag=[], options={})
      @app = app
      @header_keys_for_etag = header_keys_for_etag
    end

    def call(env)
      status, headers, body = @app.call(env)
      if headers['ETag']
        headers['ETag'] = HeaderableEtag.etag_with_headers(headers, @header_keys_for_etag)
      end
      [status, headers, body]
    end
  end
end
