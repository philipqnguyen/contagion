module Contagion
  class SSH
    attr_reader :content, :location_dna

    def initialize(location_dna)
      @location_dna = location_dna
      @content = nil
    end

    def download
      net_ssh.exec!(command.cat_file) do |_ch, stream, data|
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
      net_ssh.exec! command.backup_file
      net_ssh.exec! command.write_file_with(source_file)
      puts 'Completed'
    rescue => e
      puts 'Failed'
      raise e
    ensure
      net_ssh.close
    end

  private

    def command
      @command ||= Command.new location_dna
    end

    def net_ssh
      @session ||= Net::SSH.start location_dna.host,
                                  location_dna.username,
                                  passphrase: location_dna.passphrase
    end
  end
end
