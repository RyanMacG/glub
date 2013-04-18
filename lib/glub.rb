#!/usr/bin/env ruby

require 'rest_client'
require 'json'
require 'yaml'
require 'thor'
require_relative 'sif'

class Glub < Sif::Loader

  config_file '.glub'

  class_option :config, :default => "#{ENV['HOME']}/.glub", :aliases => ['-c']
  class_option :host, :aliases => ['-h']
  class_option :api_key, :aliases => ['-k']
  
  desc "create NAME", "Creates a new Gitlab project"
  def create(project_name)
 
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
       "#{@api_endpoint}/projects?private_token=#{@api_key}",
       command.to_json,
       :content_type => 'application/json'
    ) 

    response = JSON.parse response.body

    puts "Repository #{project_name} created. Add it as a remote using: "
    setup_repo = "git remote add origin git@#{@gitlab_host}:#{response['path_with_namespace']}.git"
    puts "  #{setup_repo}"
    setup_repo
  end

  desc "list projects", "Lists all projects"
  def list
  
    response = RestClient.get( 
       "#{@api_endpoint}/projects?private_token=#{@api_key}"
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
      super
      protocol = @secure ? 'https' : 'http'
      @api_endpoint = "#{protocol}://#{@gitlab_host}/api/v3"
    end
  end
 
end


