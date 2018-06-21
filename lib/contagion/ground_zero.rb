module Contagion
  class GroundZero
    def infect(raw_dna)
      main_dna = MainDNA.new raw_dna.merge({'passphrase' => passphrase})
      source_file = SourceFile.new
      source_file.copy_from main_dna.source
      return unless edited_and_confirmed_for? source_file
      main_dna.targets.each {|target| source_file.paste_to target}
    ensure
      source_file.close
      source_file.unlink
    end

  private

    def passphrase
      msg = [
        'If you have a passphrase for your private ssh key, enter it here.',
        'Otherwise leave blank.'
      ].join(' ')
      puts msg
      input = STDIN.noecho(&:gets).chomp
      input.length.zero? ? nil : input
    end

    def edited_and_confirmed_for?(source_file)
      source_file.edit
      confirmed_changes_for? source_file
    end

    def confirmed_changes_for?(source_file)
      puts 'Ready to push the new file to all targets?'
      puts '  y - Yes! Push them all up!'
      puts '  n - No! Get me out of here!'
      puts '  e - Edit the file again.'
      case STDIN.gets.chomp.downcase
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
