require "tbr/version"
require "tbr/log_it"
require 'tbr/call_detail'
require 'tbr/call_type'
require 'tbr/group'
require 'tbr/groups'
require 'tbr/parse_files'
require 'tbr/service'
require 'tbr/services'
require 'tbr/service_summary'

module Tbr
  def self.parse_services_file(file)
    ParseFiles.parse_services_file(file)
  end
  
  def self.process(from,to,service_list,log)    
    LogIt.instance.to_file(log) if log      
    @log = LogIt.instance
    @log.info("Processing Telstra Bill File: #{from}")
    
    @service_list = service_list || []
    @log.warn("All services will be classified as unassigned") if @service_list.empty?
    
    @to = to || '/tmp'
    @to = '/tmp' unless Dir.exist?(@to)
    @log.warn("No output directory #{to}.  Files will be written to /tmp") if @to == '/tmp'  
  
    if from.nil? || !File.exist?(from)
      @log.error("Input file #{from} does not exist.")
    else
      @log.info("Extracting Call Types from #{from}")
      call_type = CallType.new
      call_type.load(from)
      
      services = Services.new
      groups = Groups.new

    end
  end
end
