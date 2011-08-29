
# this is slightly more advanced example of rapidshare download script

require 'rubygems'
require 'rapidshare'

# load rapidshare settings from YAML file
# 
# example of YAML config file:
#  :login: 'your_login'
#  :password: 'your_password'
#  :cookie: 'your_cookie'
#  :queue: 'path_to_queue/queue_file'
#  :downloads_dir: 'path_to_downloads_dir'
#
settings = YAML::load(File.read(File.join(ENV['HOME'],'.rs'))) rescue nil

# alternatively, if YAML file doesn't exists, set rapidshare manually through hash
settings ||= { :login => 'your_login', :password => 'your_password' }
 
rs = Rapidshare::Account.new(settings[:login], settings[:password])

# TODO integrate queue parsing into Rapidshare::Account
settings[:queue] ||= 'queue_example.txt'
files_to_download = File.read(settings[:queue]).split(/\s*\n\s*/).select do |line|
  line =~ /^https?\:\/\/rapidshare\.com\/files\/\d+\//
end

# FIXME downloads_dir doesn't work yet, everything is saved to current directory

files_to_download.each do |file|
  response = rs.api.check_files([file])
  
  unless (response.first[:file_status] == :ok)
    p "File not found: [#{file}]"
    next
  end
  
  rs.download(file)
end
