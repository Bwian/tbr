require 'csv'

class ParseFiles
	
	SERVICE_NUMBER			= 0
	SERVICE_GROUP				= 1
	SERVICE_NAME				= 2
	SERVICE_CC					= 3
	
	DH_INVOICE_DATE			= 2
	OBR_SERVICE_NUMBER	= 6
		
	def self.parse_services_file(services_file)
    out = []
    begin				
			CSV.foreach(services_file) do |fields|
        out << fields if valid_fields(fields)
			end
      LogIt.instance.warn("Empty or invalid services file: #{services_file}. All services will be classified as unassigned") if out.empty?
		rescue Errno::ENOENT
      message = "Error accessing services file: #{services_file}"
			LogIt.instance.error(message)
      raise IOError, message
		end
    out
	end
  
  def self.map_services(groups,services,services_list)			
		services_list.each do |fields|
			next if !valid_fields(fields)
			
			group = groups.group(fields[SERVICE_GROUP])
			service = services.service(fields[SERVICE_NUMBER])
			service.name = fields[SERVICE_NAME]
			service.cost_centre = fields[SERVICE_CC]
			group.add_service(service)
		end
    LogIt.instance.warn("Empty services list. All services will be classified as unassigned") if services.size == 0
	end
	
	def self.parse_bill_file(services,call_type,bill_file)
		invoice_date = ''
		
		begin
			file = File.new(bill_file)
			
			file.each_line do |line|
				fields = line.split(',')
				service_number = fields[OBR_SERVICE_NUMBER]
	
				case fields[0]
					when "DH"
						invoice_date = fields[DH_INVOICE_DATE]
			
					when "DS"
						service = services.service(service_number)
						service_summary = ServiceSummary.new(line,call_type)   
						service.add_service_summary(service_summary)
			
					when "DC"
						service = services.service(service_number)
						call_detail = CallDetail.new(line,call_type)   
						service.add_call_detail(call_detail)
				end	
			end
      
      if invoice_date.empty?
  			message = "Invalid billing file: #{bill_file}"
  			LogIt.instance.fatal(message)
        raise ArgumentError, message
      end
      
		rescue Errno::ENOENT
			message = "Error accessing billing file: #{bill_file}"
			LogIt.instance.fatal(message)
      raise IOError, message
      
		rescue ArgumentError => e
      message = "Error parsing billing file: #{bill_file}"
			LogIt.instance.fatal(message) unless e.message.start_with?('Invalid')
      raise ArgumentError, message
    end
		
		invoice_date
	end
	
	def self.valid_fields(fields)
    return false if fields.size == 0
		
		if fields.size < 4
			LogIt.instance.warn("Invalid services.csv record: - #{fields.to_s}")
			return false
		end
    
    return false if fields[0].nil? or fields[0].empty? or fields[1].nil? or fields[1].empty?
		
    return false unless fields[0].match(/[0-9]/)
    
    return true
	end
	
	private_class_method :valid_fields
end
