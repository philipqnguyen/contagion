module Contagion
  class SSH
    attr_reader :content, :location_dna

    def initialize(location_dna)
      @location_dna = location_dna
      @content = nil
    end

    def download
      net_ssh.exec!(file_cat_command) do |_ch, stream, data|
        if stream == :stderr
          puts "ERROR: #{data}"
        else
          @content = data
        end
      end
      content
    ensure
      net_ssh.close
    end

    def upload(source_file)
      print "Uploading to #{location_dna.host} ... "
      net_ssh.exec! file_backup_command
      net_ssh.exec! file_write_command_for(source_file)
      puts 'Completed'
    rescue => e
      puts 'Failed'
      raise e
    ensure
      net_ssh.close
    end

  private

    def net_ssh
      @session ||= Net::SSH.start location_dna.host,
                                  location_dna.username,
                                  passphrase: location_dna.passphrase
    end

    def file_backup_path
      timestamp = Time.now.utc.strftime "%Y_%b_%e_%H_%M_%S"
      "#{location_dna.file_path}.#{timestamp}.bak"
    end

    def file_backup_command
      "#{location_dna.sudo} cp #{location_dna.file_path} #{file_backup_path}"
    end

    def file_write_command_for(source_file)
      sudo = location_dna.sudo
      file_path = location_dna.file_path
      "#{sudo} sh -c \"echo '#{source_file.read}' > #{file_path}\""
    end

    def file_cat_command
      "#{location_dna.sudo} cat #{location_dna.file_path}"
    end
  end
end
