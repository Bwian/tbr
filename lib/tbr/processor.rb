require 'tbr/call_detail'
require 'tbr/call_type'
require 'tbr/create_files'
require 'tbr/group'
require 'tbr/groups'
require 'tbr/parse_files'
require 'tbr/service'
require 'tbr/services'
require 'tbr/service_summary'
require 'tbr'

module Tbr

  class Processor  
    UNASSIGNED	 = 'Unassigned'
    USAGE        = 'usage: Tbr::Processor.new([ output: output_pathname, services: service_array, log: log_filename, replace: true/false, logo: logo_filename, original: original_filename ])'
    LOG_DEFAULT  = '/tmp/tbr.log'
    LOGO_DEFAULT = File.join(File.dirname(__FILE__), '../logo.jpg')
  
    attr_accessor :replace, :original
    attr_reader :logo, :logpath, :output, :services
    
    def initialize(options = {})
      raise ArgumentError, USAGE unless options.class == Hash
  
      @log = Tbr.log
      @log.info('Initialising Telstra Billing Reporter')
      
      self.output   = options[:output]
      self.logo     = options[:logo]
      self.services = options[:services]
      @replace      = options[:replace] || false
      @original     = options[:original] 
    end
    
    def import_services(services_file)
      @services = ParseFiles::parse_services_file(services_file)
    end
    
    def logo=(logopath) 
      @logo = logopath && File.exist?(logopath) ? logopath : LOGO_DEFAULT
      @log.warn("Logo #{logopath} could not be found.  Using default logo.") if logopath && @logo != logopath
    end
    
    def output=(out)
      if out.class == String && Dir.exist?(out) 
        @output = out
      else
        @output = '/tmp'
        @log.warn("No output directory #{out || 'provided'}.  Files will be written to /tmp")
      end
    end
    
    def output
      @output || '/tmp'
    end
    
    def services=(services)
      @services = services || []
      raise ArgumentError, "services argument must be an array" if @services.class != Array
    end
    
    def process(input)    
      fname = @original || input  # if anonymous tmp file used after upload
      @log.info("Processing Telstra Bill File: #{fname || 'nil'}")
      
      raise ArgumentError, 'Filename not provided' unless input.class == String

      unless File.exist?(input)
        message = "Input file #{input} does not exist."
        @log.error(message)
        raise IOError, message
      end    
    
      @log.warn("All services will be classified as unassigned") if @services.empty?
      @log.info("Files being written to #{output}")
  
      @log.info("Extracting Call Types from #{fname}")
      call_type = CallType.new
      call_type.load(input)
    
      services = Services.new
      groups = Groups.new
    
      @log.info("Extracting billing data from #{fname}")
      ParseFiles.map_services(groups,services,@services)
      invoice_date = ParseFiles.parse_bill_file(services,call_type,input)

      @log.info("Building Unassigned group")
      group = groups.group(UNASSIGNED)
      services.each do |service|
      	group.add_service(service) if service.name == UNASSIGNED
      end
      
      unassigned_count = groups.group(UNASSIGNED).size
      @log.warn("#{unassigned_count} unassigned services") if unassigned_count > 0
    
      cf = CreateFiles.new(invoice_date,output,replace)
      cf.logo = @logo
    
      @log.info("Creating group summaries")
      groups.each do |group|
        cf.group_summary(group)
      end

      @log.info("Creating service details")
      services.each do |service|
        cf.call_details(service)
      end

      @log.info("Creating service totals summary")
      cf.service_totals(services)
    
      @log.info("PDF report files can be found in #{cf.dir_full_root}.") 
      @log.info("Telstra billing data extract completed.") 
    end
    
    private
  
    def check_log(path)
      begin
        file = File.open(path,'w')
        file.close
        path
      rescue SystemCallError
        nil
      end
    end
  end
  
end
