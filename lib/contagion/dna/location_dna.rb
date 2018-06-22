module Contagion
  class LocationDNA < DNA
    attr_reader :host, :username, :sudo, :file_path, :passphrase

    def initialize(raw_dna)
      @passphrase = raw_dna['passphrase']
      @host = raw_dna['host']
      @username = raw_dna['username']
      @sudo = raw_dna['sudo'] == true ? 'sudo' : nil
      @file_path = raw_dna['file_path']
    end
  end
end
