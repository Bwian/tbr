require 'logger'
require "tbr/version"

module Tbr
  
	class << self
		def log
      @log || Logger.new(STDOUT)
    end
    
    def log=(logger)
      @log = logger
    end
	end	

end

require "tbr/processor"
