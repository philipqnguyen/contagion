require 'net/ssh/proxy/command'

module Contagion
  class SSH
    attr_reader :content, :location_dna

    def initialize(location_dna)
      @location_dna = location_dna
      @content = nil
      @command = Command.new location_dna
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
    rescue Net::SSH::Exception => e
      puts 'Failed'
      puts "#{e.class}: #{e.message}"
    ensure
      net_ssh.close
    end

  private

    attr_reader :command

    def net_ssh
      @session ||= Net::SSH.start location_dna.host,
                                  location_dna.username,
                                  passphrase: location_dna.passphrase,
                                  proxy: proxy_command
    end

    def proxy_command
      if location_dna.proxy_command
        @_proxy ||= Net::SSH::Proxy::Command.new location_dna.proxy_command
      end
    end
  end
end
