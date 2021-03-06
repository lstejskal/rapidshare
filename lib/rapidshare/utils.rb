# encoding: utf-8

module Rapidshare

  # Contains utility methods which can be called both as class and instance methods
  #
  module Utils

    # Provides interface for GET requests
    # 
    # PS: previously url.request_uri was escaped by URI::escape method,
    # but with params for url filtered by to_query method it's not necessary 
    # anymore and can actually cause bugs (already did in checkfiles method)
    #
    def get(url)
      url = URI.parse(url)
      http = Net::HTTP.new(url.host, url.port)
      if url.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      http.get url.request_uri
    end

    # Convert file status code (returned by checkfiles method) to +:ok+ or +:error+ symbol.
    #
    def decode_file_status(status_code)
      # TODO in checkfiles, return both file_status as is and decoded file status
      # or just boolean value if file is OK and can be downloaded
  
      case status_code
        when 0 then :error # File not found
        when 1 then :ok # File OK
        when 3 then :error # Server down
        when 4 then :error # File marked as illegal
        else :error # uknown status, this shouldn't happen
      end
    end
  
    # Extracts file id and file name from Rapidshare url. Returns both in array.
    #
    # Example:
    #   https://rapidshare.com/files/829628035/HornyRhinos.jpg -> [ '829628035', 'HornyRhinos.jpg' ] 
    #
    def fileid_and_filename(url)
      url.split('/').slice(-2,2) || ['', '']
    end
  
    # Converts rapidshare response (which is just a text in specific format) to hash.
    #
    # Example:
    #   "key1=value1\nkey1=value2" -> { :key1 => 'value1', :key2 => 'value2' }
    #
    def text_to_hash(response)
      Hash[ response.strip.split(/\s*\n\s*/).map { |param| param.split('=') } ].symbolize_keys
    end
  
  end

end
