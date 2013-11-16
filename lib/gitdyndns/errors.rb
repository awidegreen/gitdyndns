# the error definition has been inspired by 
# http://globaldev.co.uk/2013/09/ruby-tips-part-3/#exceptions

module Gitdyndns
  class Error < StandardError
  end

  class EnvironmentError < Error
  end
end
