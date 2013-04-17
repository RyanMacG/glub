#!/usr/bin/env ruby

require 'rest_client'
require 'json'
require 'yaml'
require 'thor'

class Glub < Thor

  class_option :config, :default => "#{ENV['HOME']}/.glub", :aliases => ['-c']
  class_option :host, :aliases => ['-h']
  class_option :api_key, :aliases => ['-k']
  
  desc "create NAME", "Creates a new Gitlab project"
  def create(project_name)

    load_configuration

    puts "Creating Gitlab project #{project_name}"
    command = { 
        :name => project_name,
        :description  => 'this is a new project',
        :default_branch => 'master',
        :issues_enabled => 'true',
        :wiki_ebabled  => 'true',
        :wall_enabled  => 'true',
        :merge_requests_enabled => 'true'
    } 

    response = RestClient.post( 
       "#{@@api_endpoint}/projects?private_token=#{@@api_key}",
       command.to_json,
       :content_type => 'application/json'
    ) 

    response = JSON.parse response.body

    puts "Repository #{project_name} created. Add it as a remote using: "
    setup_repo = "git remote add origin git@#{@@gitlab_host}:#{response['path_with_namespace']}.git"
    puts "  #{setup_repo}"
    setup_repo
  end

  desc "list projects", "Lists all projects"
  def list
  
    load_configuration

    response = RestClient.get( 
       "#{@@api_endpoint}/projects?private_token=#{@@api_key}"
    ) 

    response = JSON.parse response.body

    projects = []
    response.each { |project| projects << project['name'] }
    puts "Projects: "
    projects.each { |project| puts "  #{project}" }
    "#{projects}"

  end
 
  no_tasks do
    def load_configuration
       config_file = options[:config]
       if (!File.exists?(config_file) ) 
         puts "Unable to find config file #{config_file} - can't continue"
         exit
       end
       config = YAML::load_file config_file
       @@api_key = config['api_key']
       @@gitlab_host = config['gitlab_host']
       @@api_endpoint = "https://#{@@gitlab_host}/api/v3"
    end
  end

end


