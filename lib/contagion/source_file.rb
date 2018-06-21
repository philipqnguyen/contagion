require 'securerandom'

module Contagion
  class SourceFile < Tempfile
    def initialize
      super SecureRandom.hex(6)
    end

    def copy_from(source_dna)
      ssh = SSH.new source_dna
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

    def paste_to(target_dna)
      ssh = SSH.new target_dna
      ssh.upload self
    end

    def read
      rewind
      super
    end
  end
end
