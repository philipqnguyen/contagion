require 'securerandom'

module Contagion
  class SourceFile < Tempfile
    def initialize
      super SecureRandom.hex(6)
    end

    def copy(from:)
      source = from
      ssh = SSH.new source
      content = ssh.download
      write content
    end

    def edit
      rewind
      if ENV['EDITOR']
        system("#{ENV['EDITOR']} #{path}")
      else
        system("nano #{path}")
      end
    end

    def paste(to:)
      target = to
      ssh = SSH.new target
      ssh.upload self
    end

    def read
      rewind
      super
    end
  end
end
