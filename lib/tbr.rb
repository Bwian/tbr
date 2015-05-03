require "tbr/version"
require "tbr/parse_files"

module Tbr
  
  class TbrError < StandardError; end
  
  def self.parse_services_file(file)
    ParseFiles.parse_services_file(file)
  end

end

require "tbr/processor"
