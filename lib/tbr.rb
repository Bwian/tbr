require "tbr/version"
require "tbr/log_it"
require 'tbr/call_detail'
require 'tbr/call_type'
require 'tbr/create_files'
require 'tbr/group'
require 'tbr/groups'
require 'tbr/parse_files'
require 'tbr/service'
require 'tbr/services'
require 'tbr/service_summary'

module Tbr
  
  UNASSIGNED	= 'Unassigned'
  USAGE       = 'usage: Tbr.process filename, [ output: output_filename, services: service_array, log: log_filename, replace: true/false, logo: logo_filename ]'
  
  def self.parse_services_file(file)
    ParseFiles.parse_services_file(file)
  end
  
  def self.process(*args)    
    input = args[0]
    raise ArgumentError, USAGE unless input.class == String
    
    options = args[1] || {}
    raise ArgumentError, USAGE unless options.class == Hash
    
    replace = options[:replace] || false
    logo    = options[:logo]
    
    LogIt.instance.to_file(options[:log]) if options[:log]      
    log = LogIt.instance
    log.info("Processing Telstra Bill File: #{input}")
    
    service_list = options[:services] || []
    log.warn("All services will be classified as unassigned") if service_list.empty?
    
    output = options[:output] || '/tmp'
    output = '/tmp' unless Dir.exist?(output)
    log.warn("No output directory #{options[:output] || 'nil'}.  Files will be written to /tmp") if output == '/tmp'  
  
    if input.nil? || !File.exist?(input)
      message = "Input file #{input || 'nil'} does not exist."
      log.error(message)
      raise IOError, message
    end

    log.info("Extracting Call Types from #{input}")
    call_type = CallType.new
    call_type.load(input)
    
    services = Services.new
    groups = Groups.new
    
    log.info("Extracting billing data from #{input}")
    ParseFiles.map_services(groups,services,service_list)
    invoice_date = ParseFiles.parse_bill_file(services,call_type,input)

    log.info("Building Unassigned group")
    group = groups.group(UNASSIGNED)
    services.each do |service|
    	group.add_service(service) if service.name == UNASSIGNED
    end
    
    cf = CreateFiles.new(invoice_date,output,replace)
    cf.logo = logo
    
    log.info("Creating group summaries")
    groups.each do |group|
      cf.group_summary(group)
    end

    log.info("Creating service details")
    services.each do |service|
      cf.call_details(service)
    end

    log.info("Creating service totals summary")
    cf.service_totals(services)
    
    log.info("PDF report files can be found in #{cf.dir_full_root}.") 
    log.info("Telstra billing data extract completed.") 
  end
end
