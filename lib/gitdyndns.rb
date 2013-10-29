require "gitdyndns/version"

module Gitdyndns

  def self.bootstrap_ddnsdb(name, repo_url, local_path)
    puts "Going initialize DdnsDb #{name} to #{local_path} from #{repo_url}"
    Git.clone(repo_url, name, :path => local_path)
  end
      
end
