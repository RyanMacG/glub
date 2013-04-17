#!/usr/bin/env ruby

require 'rest_client'
require 'json'
require 'yaml'
require 'thor'

class Glub < Thor 

  config = YAML::load_file "#{ENV['HOME']}/.glub"
  @@api_key = config['api_key']
  @@gitlab_host = config['gitlab_host']
  @@api_endpoint = "http://#{@@gitlab_host}/api/v3" 

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
       "#{@@api_endpoint}/projects?private_token=#{@@api_key}",
       command.to_json,
       :content_type => 'application/json'
    ) 

    response = JSON.parse response.body

    puts "Repository #{project_name} created. Add it as a remote using: "
    puts "  git remote add origin git@#{@@gitlab_host}:#{response['path_with_namespace']}.git"
  end

end


