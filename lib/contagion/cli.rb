require 'thor'

module Contagion
  class CLI < Thor

    desc "infect DNA_FILE_PATH", "Load, Edit, and Spread the file to target servers."
    def infect(dna)
      Contagion::GroundZero.new(dna).infect
    end
  end
end
