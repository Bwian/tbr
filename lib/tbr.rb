require "tbr/version"
require "tbr/log_it"

module Tbr
  def self.process(from,to,services,log)
    if log
      LogIt.instance.to_file(log)
    else
      LogIt.instance.to_stdout
    end
  end
end
