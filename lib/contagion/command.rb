module Contagion
  class Command
    attr_reader :location_dna

    def initialize(location_dna)
      @location_dna = location_dna
    end

    def backup_file
      timestamp = Time.now.utc.strftime "%Y_%b_%e_%H_%M_%S"
      file_backup_path = "#{location_dna.file_path}.#{timestamp}.bak"
      "#{location_dna.sudo} cp #{location_dna.file_path} #{file_backup_path}"
    end

    def write_file_with(source_file)
      sudo = location_dna.sudo
      file_path = location_dna.file_path
      "#{sudo} sh -c \"echo '#{source_file.read}' > #{file_path}\""
    end

    def cat_file
      "#{location_dna.sudo} cat #{location_dna.file_path}"
    end
  end
end
