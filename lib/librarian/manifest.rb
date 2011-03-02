require 'librarian/helpers/debug'
require 'librarian/support/abstract_method'

module Librarian
  class Manifest

    include Support::AbstractMethod
    include Helpers::Debug

    attr_reader :source, :name

    abstract_method :cache_version!, :cache_dependencies!
    abstract_method :install!

    def initialize(source, name)
      @source = source
      @name = name
      @version = nil
      @dependencies = nil
    end

    def version
      @version ||= _normalize_version(cache_version!)
    end

    def dependencies
      @dependencies ||= _normalize_dependencies(cache_dependencies!)
    end

  private

    def root_module
      source.root_module
    end

    def _normalize_version(version)
      Gem::Version.new(version)
    end

    def _normalize_dependencies(dependencies)
      case dependencies
      when Hash
        dependencies.map{|k, v| Dependency.new(k, v, nil)}
      else
        dependencies
      end
    end

  end
end