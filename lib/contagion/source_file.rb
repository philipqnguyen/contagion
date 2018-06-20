require 'securerandom'

module Contagion
  class SourceFile < Tempfile
    def initialize
      super SecureRandom.hex(6)
    end

    def copy(from:)
      source = from
      ssh = SSH.new host: source['host'], username: source['username']
      content = ssh.download source['file_path']
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
      ssh = SSH.new host: target['host'], username: target['username']
      ssh.upload self, to: target['file_path']
    end

    def read
      rewind
      super
    end
  end
end
