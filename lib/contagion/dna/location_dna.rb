module Contagion
  class LocationDNA < DNA
    attr_reader :host, :username, :sudo, :file_path, :passphrase,
      :proxy_command

    def initialize(raw_dna)
      @passphrase = raw_dna['passphrase']
      @host = raw_dna['host']
      @username = raw_dna['username']
      @sudo = raw_dna['sudo'] == true ? 'sudo' : nil
      @file_path = raw_dna['file_path']
      @proxy_command = raw_dna['proxy_command']
    end
  end
end
