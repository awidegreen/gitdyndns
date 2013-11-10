module Gitdyndns::Config
  @@GITDYNDNS_REPO_PATH = "GITDYNDNS_REPO_PATH"
  @@GITDYNDNS_LAN_NAME  = "GITDYNDNS_LAN_NAME"

  def self.get_repo_path
    return get_env_var(@@GITDYNDNS_REPO_PATH)
  end

  def self.get_lan_name
    return get_env_var(@@GITDYNDNS_LAN_NAME)
  end

  def self.get_env_var(env)
    if not ENV.has_key?(env)
      abort "#{env} is not defined in the current shell"
    else
      ENV[env] 
    end
  end
end
