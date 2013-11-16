require "yaml"
require "gitdyndns/errors"

module Gitdyndns
  @@USER_CONFIG_FILE    = "~/.gitdyndns.yaml"

  class EnvironmentConfig
    def initialize
      @lan_name  = get_env_var("GITDYNDNS_LAN_NAME")
      @repo_path = get_env_var("GITDYNDNS_REPO_PATH")
    end

    def get_repo_path
      @repo_path
    end

    def get_lan_name
      @lan_name
    end

    private
    def get_env_var(env)
      if not ENV.has_key?(env)
        raise EnvironmentError, "#{env} is not defined in the current shell"
      else
        ENV[env] 
      end
    end
  end

  class FileConfig
    def initialize(file)
      @data = YAML.load_file(file)
      @data.fetch("lan_name")
      @data.fetch("repo_path")
    end

    def get_repo_path
      @data.fetch("repo_path")
    end

    def get_lan_name
      @data.fetch("lan_name")
    end
  end

  def self.Config()
    ex_f_path = File.expand_path @@USER_CONFIG_FILE
    if File.exists?(ex_f_path)
      FileConfig.new(ex_f_path)
    else
      EnvironmentConfig.new
    end
  end

end
