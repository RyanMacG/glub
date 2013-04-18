require 'thor'
require 'yaml'

module Sif
	class Loader < Thor

		def initialize(args=[], options={}, config={})
		     super
		    load_configuration
		end
		
		class_option :config, :aliases => ['-c']
		@config_file = '.config'

		no_tasks do
		    def load_configuration
		    	
		       config_file = options[:config] || "#{ENV['HOME']}/#{@config_file}"
		       if (!File.exists?(config_file) ) 
		         puts "Unable to find config file #{config_file} - can't continue"
		         exit
		       end
		       config = YAML::load_file config_file
		    
		       config.each do |k,v|
		       	  instance_variable_set "@#{k}",v
		       end
		       	
		    end

		    def self.config_file(filename)
		    	@config_file = filename
		    end

	  	end

	end
end