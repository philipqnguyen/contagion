module Contagion
  class SSH
    def self.passphrase=(passphrase)
      @passphrase = passphrase.length.zero? ? nil : passphrase
    end

    def self.passphrase
      @passphrase
    end

    attr_reader :host, :username, :content

    def initialize(host:, username:)
      @host = host
      @username = username
      @content = nil
    end

    def download(remote_file_path)
      net_ssh.exec!("sudo cat #{remote_file_path}") do |_ch, stream, data|
        if stream == :stderr
          puts "ERROR: #{data}"
        else
          @content = data
        end
      end
      content
    end

    def upload(source_file, to:)
      file_path = to
      print "Uploading to #{host} ... "
      net_ssh.exec! "sudo cp #{file_path} #{file_path_backup_for(file_path)}"
      net_ssh.exec! "sudo sh -c \"echo '#{source_file.read}' > #{file_path}\""
      puts 'Completed'
    rescue => e
      puts 'Failed'
      raise e
    end

  private

    def passphrase
      self.class.passphrase
    end

    def net_ssh
      Net::SSH.start host, username, passphrase: passphrase
    end

    def file_path_backup_for(file_path)
      timestamp = Time.now.utc.strftime "%Y_%b_%e_%H_%M_%S"
      "#{file_path}.#{timestamp}.bak"
    end
  end
end
