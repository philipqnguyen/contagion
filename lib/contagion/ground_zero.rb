module Contagion
  class GroundZero
    def initialize
      @source_file = SourceFile.new
      @prompt = Prompt.new
      @editor = Editor.new
    end

    def infect(raw_dna)
      main_dna = MainDNA.new raw_dna.merge({'passphrase' => prompt.passphrase})
      source_file.copy_from main_dna.source
      return unless editor.edit source_file
      main_dna.targets.each {|target| source_file.paste_to target}
    ensure
      source_file.close
      source_file.unlink
    end

  private

    attr_reader :source_file, :prompt, :editor
  end
end
