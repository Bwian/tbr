require 'logger'
require 'singleton'

class LogIt < Logger
	include Singleton

	def to_file(fname)
  	file = File.open(fname,'a')
    file.sync = true
  	@logdev = Logger::LogDevice.new(file)
  end

  def to_stdout
    @logdev = Logger::LogDevice.new(STDOUT)
  end

  def to_stderr
    @logdev = Logger::LogDevice.new(STDERR)
  end

  def to_null
  	file = File.open('/dev/null','a')
  	@logdev = Logger::LogDevice.new(file)
  end

  private
  
  def initialize
		super(STDOUT)
  end

end