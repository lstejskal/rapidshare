require 'test_helper'

class ApiTest < Test::Unit::TestCase

  def setup
    @cookie = 'F0EEB41B38363A41F0D125102637DB7236468731F8DB760DC57934B4714C8D13'

    FakeWeb.register_uri(:get,
      'https://api.rapidshare.com/cgi-bin/rsapi.cgi?sub=getaccountdetails&login=valid_login&password=valid_password&withcookie=1&cookie=',
      :body => read_fixture('getaccountdetails_valid.txt')
    )

    FakeWeb.register_uri(:get,
      "https://api.rapidshare.com/cgi-bin/rsapi.cgi?sub=getaccountdetails&withcookie=1&cookie=#{@cookie}",
      :body => read_fixture('getaccountdetails_valid.txt')
    )
    
    @rs = Rapidshare::Account.new('valid_login','valid_password')
  end

  context "Checkfiles method" do
    setup do
      FakeWeb.register_uri(:get,
        "https://api.rapidshare.com/cgi-bin/rsapi.cgi?sub=checkfiles&files=829628035&filenames=HornyRhinos.jpg&cookie=#{@cookie}",
        :body => read_fixture('checkfiles_single.txt')
      )

      FakeWeb.register_uri(:get,
        "https://api.rapidshare.com/cgi-bin/rsapi.cgi?sub=checkfiles&files=829628035%2C428232373%2C766059293&filenames=HornyRhinos.jpg%2CHappyHippos.jpg%2CElegantElephants.jpg&cookie=#{@cookie}",
        :body => read_fixture('checkfiles_multi.txt')
      )

      FakeWeb.register_uri(:get,
        "https://api.rapidshare.com/cgi-bin/rsapi.cgi?sub=checkfiles&files=&filenames=&cookie=#{@cookie}",
        :body => 'ERROR: Files invalid. (1dd3841d)'
      )

      @files = %w{
        https://rapidshare.com/files/829628035/HornyRhinos.jpg
        https://rapidshare.com/files/428232373/HappyHippos.jpg
        https://rapidshare.com/files/766059293/ElegantElephants.jpg
      }
    end
    
    should "return information about file" do
      file_info = @rs.api.checkfiles(@files.first)
      assert_instance_of Array, file_info 
      assert_equal 1, file_info.size
      assert_equal :ok, file_info.first[:file_status]
      assert_equal file_info.first,
        {:file_id=>"829628035", :file_name=>"HornyRhinos.jpg",
        :file_size=>"272288", :server_id=>"370", :file_status=>:ok,
        :short_host=>"l33", :md5=>"8700146036606454677EFAFB4A2AC52E"}
    end

    should "accept single file or array" do
      assert_equal 3, @rs.api.checkfiles(@files).size
      assert_equal 3, @rs.api.checkfiles(@files[0], @files[1], @files[2]).size
      assert_equal 1, @rs.api.checkfiles(@files.first).size
    end
    
    should "raise error if called without file parameters" do
      assert_raise(Rapidshare::API::Error) { @rs.api.checkfiles }
      assert_raise(Rapidshare::API::Error) { @rs.api.checkfiles('') }
    end

    should "raise error if called with obviously invalid files" do
      assert_raise(Rapidshare::API::Error) { @rs.api.checkfiles('http://server/file') }
    end
  end  

  # TODO move to checkfiles test
  # 
  context "Valid API request" do
    setup do
      FakeWeb.register_uri(:get,
        'https://api.rapidshare.com/cgi-bin/rsapi.cgi?sub=checkfiles&files=439727873&filenames=DT-02-DT.rar',
        :body => '439727873,DT-02-DT.rar,94615872,971,1,l3,F50F440C343749FD7C91286369BED105'
      )
    end
    
    should "return response" do
      response = Rapidshare::API.request(:checkfiles, {
        :files => "439727873",
        :filenames => "DT-02-DT.rar"
      })
      assert response.is_a?(String)
      assert response.length > 0
      assert !response.include?("ERROR: ")      
    end
  end

  context "Invalid routine call" do
    setup do
      FakeWeb.register_uri(:get,
        'https://api.rapidshare.com/cgi-bin/rsapi.cgi?sub=invalid_routine&param_1=value_1',
        :body => 'ERROR: Invalid routine called. (5b97895d)'
      )
    end

    should "raise InvalidRoutine error" do
      assert_raise Rapidshare::API::Error::InvalidRoutineCalled do
        Rapidshare::API.request(:invalid_routine, {:param_1 => "value_1"})
      end
    end
  end

end
