require 'securerandom'

module Contagion
  class SourceFile
    def initialize
      @tempfile = Tempfile.new SecureRandom.hex(6)
    end

    def copy_from(source_dna)
      ssh = SSH.new source_dna
      content = ssh.download
      tempfile.write content
    end

    def paste_to(target_dna)
      ssh = SSH.new target_dna
      ssh.upload self
    end

    def read
      tempfile.rewind
      tempfile.read
    end

    def close
      tempfile.close
    end

    def unlink
      tempfile.unlink
    end

    def rewind
      tempfile.rewind
    end

    def path
      tempfile.path
    end

  private

    attr_reader :tempfile
  end
end
