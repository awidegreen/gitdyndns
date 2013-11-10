require "net/http"
require "gitdyndns"

module Gitdyndns::WanProvider

  class IfconfigMe
    def get( filter = [:wan_ip, :wan_host] )
      filter.each do |i|
        yield i, Net::HTTP.get(URL, "/#{i.to_s}").delete("\n")
      end
    rescue 
      puts "Unable to receive wan details"
    end
    private 
    URL = "ifconfig.me"
  end

  class Akamai
    def get
      ip = Net::HTTP.get(URL, "/").delete("\n")
      yield :wan_ip, ip
    rescue 
      puts "Unable to receive wan details"
    end
    private
    URL = "whatismyip.akamai.com"
  end

end

