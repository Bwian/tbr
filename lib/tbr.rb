require "tbr/version"
require "tbr/log_it"

module Tbr
  def self.process(from,to,services,log)    
    LogIt.instance.to_file(log) if log      
    @log = LogIt.instance
    @log.info("Processing Telstra Bill File: #{from}")
    
    @services = services || []
    @log.warn("All services will be classified as unassigned") if @services.empty?
    
    @to = to || '/tmp'
    @to = '/tmp' unless Dir.exist?(@to)
    @log.warn("No output directory #{to}.  Files will be written to /tmp") if @to == '/tmp'  
  
    if from.nil? || !File.exist?(from)
      @log.error("Input file #{from} does not exist.")
    else
      
    end
  end
end
