#!/usr/bin/env ruby

require 'rest_client'
require 'json'
require 'yaml'
require 'thor'
require 'sif'

class Glub < Sif::Loader

  config_file '.glub'

  class_option :config, :default => "#{ENV['HOME']}/.glub", :aliases => ['-c']
  class_option :host, :aliases => ['-h']
  class_option :api_key, :aliases => ['-k']

  desc "create NAME (GROUP_ID/NAMESPACE_ID optional)", "Creates a new Gitlab project"
  def create(project_name, namespace_id=nil)

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

    unless namespace_id.nil?
      command[:namespace_id] = namespace_id
    end


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

  desc "list", "Lists all projects"
  def list

    response = RestClient.get(
       "#{@api_endpoint}/projects?private_token=#{@api_key}"
    )

    response = JSON.parse response.body

    projects = []
    response.each { |project| projects << "Name:#{project['name']} / ID:#{project['id']}" }
    puts "Projects: "
    projects.each { |project| puts "  #{project}" }
    "#{projects}"

  end

  desc "list_groups", "Lists all groups"
  def list_groups

    response = RestClient.get(
       "#{@api_endpoint}/groups?private_token=#{@api_key}"
    )

    response = JSON.parse response.body

    groups = []
    response.each { |group| groups << "Name:#{group['name']} / ID:#{group['id']}" }
    puts "Groups: "
    groups.each { |group| puts "  #{group}" }
    "#{groups}"
  end

  desc "create_group NAME", "Creates a new group"
  def create_group(group_name)

    puts "Creating Gitlab group #{group_name}"
    command = {
      name: group_name,
      path: group_name.downcase.gsub(' ', '-')
    }

    response = RestClient.post(
       "#{@api_endpoint}/groups?private_token=#{@api_key}",
       command.to_json,
       content_type: 'application/json'
    )

    response = JSON.parse response.body

    puts "Group #{group_name} created."
    # add root user by default
    add_user_to_group(response['id'], 1, 'owner')
  end

  desc "add_user_to_group GROUP_ID USER_ID PERMISSION", "Add a user to a group"
  def add_user_to_group(group_id, user_id, permission=nil)
    if permission.nil?
      access_level = 30
    else
      access_level = determine_access_level(permission)
    end

    group_response = RestClient.get(
      "#{@api_endpoint}/groups/#{group_id}?private_token=#{@api_key}"
    )

    group_response = JSON.parse group_response.body

    group_name = group_response['name']


    puts "Adding user to group #{group_name}"
    command = {
      id: group_id,
      user_id: user_id,
      access_level: access_level
    }

    response = RestClient.post(
       "#{@api_endpoint}/groups/#{group_id}/members?private_token=#{@api_key}",
       command.to_json,
       content_type: 'application/json'
    )

    response = JSON.parse response.body

    puts "User added to group #{group_name}"
  end

  desc 'move_project_to_group GROUP_ID PROJECT_ID', 'Move a project to a group'
  def move_project_to_group(group_id, project_id)

    group_response = RestClient.get(
      "#{@api_endpoint}/groups/#{group_id}?private_token=#{@api_key}"
    )
    group_response = JSON.parse group_response.body
    group_name = group_response['name']

    project_response = RestClient.get(
      "#{@api_endpoint}/projects/#{project_id}?private_token=#{@api_key}"
    )
    project_response = JSON.parse project_response.body
    project_name = project_response['name']

    puts "Moving project #{project_name} to group #{group_name}"
    command = {
      id: group_id,
      project_id: project_id
    }

    response = RestClient.post(
       "#{@api_endpoint}/groups/#{group_id}/projects/#{project_id}?private_token=#{@api_key}",
       command.to_json,
       content_type: 'application/json'
    )

    response = JSON.parse response.body

    puts "Project #{project_name} moved to group #{group_name}"
  end

  no_tasks do
    def load_configuration
      super
      protocol = @secure ? 'https' : 'http'
      @api_endpoint = "#{protocol}://#{@gitlab_host}/api/v3"
    end
  end

end
