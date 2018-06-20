module Contagion
  class SSH
    def self.passphrase=(passphrase)
      @passphrase = passphrase.length.zero? ? nil : passphrase
    end

    def self.passphrase
      @passphrase
    end

    attr_reader :content, :config

    def initialize(config)
      @config = config
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
      print "Uploading to #{config['host']} ... "
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

    def passphrase
      self.class.passphrase
    end

    def net_ssh
      Net::SSH.start config['host'], config['username'], passphrase: passphrase
    end

    def file_backup_path
      timestamp = Time.now.utc.strftime "%Y_%b_%e_%H_%M_%S"
      "#{config['file_path']}.#{timestamp}.bak"
    end

    def file_backup_command
      "sudo cp #{config['file_path']} #{file_backup_path}"
    end

    def file_write_command_for(source_file)
      "sudo sh -c \"echo '#{source_file.read}' > #{config["file_path"]}\""
    end

    def file_cat_command
      "sudo cat #{config['file_path']}"
    end
  end
end
