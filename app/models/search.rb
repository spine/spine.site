require "shellwords"

module Search
  module Grep
    def find(path, query)
      query  = Shellwords.escape(query)
      result = %x{grep -r -i #{query} #{path}}.split("\n")
      result.inject({}) do |hash, result| 
        name, context = result.split(":", 2)
        name = Pathname(name).relative_path_from(path)
        name, _ = name.to_s.split(".")
        hash[name.to_s] = context.lstrip
        hash
      end
    end
    
    extend self
  end
  
  def api(query)
    Grep.find(Rails.root.join(*%w{app views api}), query)
  end
  
  def docs(query)
    Grep.find(Rails.root.join(*%w{app views docs}), query)
  end
  
  extend self
end