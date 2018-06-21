require 'thor'
require 'yaml'

module Contagion
  class CLI < Thor

    desc "infect DNA_FILE_PATH", "Load, Edit, and Spread the file to target servers."
    def infect(dna_file)
      raw_dna = YAML.load_file dna_file
      Contagion::GroundZero.new.infect raw_dna
    end
  end
end
