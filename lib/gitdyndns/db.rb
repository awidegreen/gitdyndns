require "ostruct"
require "git"
require "json"

module Gitdyndns

  class DynEntry
    def initialize(commit, attributes = {})
      @attr = OpenStruct.new(attributes)
      @attr.send("commit=", commit)
    end

    def method_missing(method, *args, &block)
      @attr.send(method, *args, &block)
    end
  end


  class DdnsDb
    attr_reader :name
    def initialize(name, path)
      @name = name
      @git_repo = Git.open(path)
    end

    def get_entries
      pull_latest
      dyn_entries = []
      shas = @git_repo.log.map {|e| e.sha}
      shas.each do |commit|
        begin 
          dyndns_contents = @git_repo.object("#{commit}:#{JSON_FILE}").contents 
          json = JSON.parse(dyndns_contents)
          json.each do |j_entry|
            entry =  DynEntry.new(commit, j_entry)
            yield entry if block_given?
            dyn_entries << entry
          end
        rescue JSON::ParserError => e
          puts "#{e.class.to_s} occured in commit #{commit}"
        end
      end
      dyn_entries
    end

    def get_latest
      pull_latest
      dyn_entries = []
      dyndns_contents = @git_repo.object("HEAD^:#{JSON_FILE}").contents 
      json = JSON.parse(dyndns_contents)
      json.each do |j_entry|
        entry =  DynEntry.new("HEAD", j_entry)
        yield entry if block_given?
        dyn_entries << entry
      end
      rescue JSON::ParserError => e
        puts "#{e.class.to_s} occured in commit HEAD"
    end

    def update(details = {})
      arr = Array.new
      arr << details
      dir = @git_repo.dir

      File.open(dir.to_s + "/" + JSON_FILE, "w") do |f|
        j = JSON.pretty_generate(arr)
        f.write(j + "\n")
        puts "#{JSON_FILE} has been written/updated" 
      end
    end

    def update!(details = {})
      update(details)
      commit(details[:wan_ip])
      push
    end

    def commit(ip)
      @git_repo.add(:all => true)
      @git_repo.commit("update ddns (#{ip})")
      puts "Update has been commited (git)"
    end

    def push
      @git_repo.push(@git_repo.remote(GIT_REMOTE))
      puts "Update has been pushed to #{GIT_REMOTE}"
    end
    
    ### private section
    private
    JSON_FILE = "dyndns.json"
    GIT_REMOTE = "origin"

    def pull_latest
      @git_repo.pull
    end
  end

end

