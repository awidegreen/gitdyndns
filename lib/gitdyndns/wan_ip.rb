require "net/http"
require "gitdyndns"

module Gitdyndns::WanProvider

  class IfconfigMe
    def get_details( filter = [:wan_ip, :wan_host] )
      filter.each_with_object({}) do |i, result|
        result[i] = Net::HTTP.get(URL, "/#{i.to_s}").delete("\n")
      end
    rescue 
      puts "Unable to receive wan details"
    end
    private 
    URL = "ifconfig.me"
  end

  class Akamai
    def get_details
      result = {}
      result[:ip] = Net::HTTP.get(URL, "/").delete("\n")
      result
    end
    private
    URL = "whatismyip.akamai.com"
  end

end

