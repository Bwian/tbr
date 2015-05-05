require 'logger'

require "tbr/version"

module Tbr
  
	class << self
		def log
      @log || Logger.new(nil)
    end
    
    def log=(log)
      @log = Logger.new(log)
    end
	end	
  
  class TbrError < StandardError; end

end

require "tbr/processor"
