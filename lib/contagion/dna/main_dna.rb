require 'yaml'
require 'contagion/dna/dna'
require 'contagion/dna/location_dna'
require 'contagion/dna/source_dna'
require 'contagion/dna/target_dna'

module Contagion
  class MainDNA < DNA
    attr_reader :source, :targets

    def initialize(raw_dna)
      defaults = {'passphrase' => raw_dna['passphrase']}
      @source = SourceDNA.new defaults.merge(raw_dna["source"])
      @targets = raw_dna["targets"].map do |target|
        TargetDNA.new defaults.merge(target)
      end
    end
  end
end
