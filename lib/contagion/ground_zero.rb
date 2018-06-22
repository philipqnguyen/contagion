module Contagion
  class GroundZero
    def infect(raw_dna)
      main_dna = MainDNA.new raw_dna.merge({'passphrase' => prompt.passphrase})
      source_file = SourceFile.new
      source_file.copy_from main_dna.source
      return unless edited_and_confirmed_for? source_file
      main_dna.targets.each {|target| source_file.paste_to target}
    ensure
      source_file.close
      source_file.unlink
    end

  private

    def prompt
      @prompt ||= Prompt.new
    end

    def edited_and_confirmed_for?(source_file)
      source_file.edit
      confirmed_changes_for? source_file
    end

    def confirmed_changes_for?(source_file)
      case prompt.edit_confirmation
      when 'y'
        true
      when 'n'
        false
      when 'e'
        edited_and_confirmed_for? source_file
      else
        confirmed_changes_for? source_file
      end
    end
  end
end
