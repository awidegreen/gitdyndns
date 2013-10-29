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
          #in commit #{commit} with json content:\n#{j_contents}"
        end
      end
      dyn_entries
    end

    def set_details(details = {})
      # nop

    end
    
    private
      JSON_FILE = "dyndns.json"
  end

end

