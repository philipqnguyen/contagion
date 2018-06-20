require 'yaml'

module Contagion
  class GroundZero
    attr_reader :dna, :source, :targets

    def initialize(dna)
      @dna = YAML.load_file dna
      @source = @dna['source']
      @targets = @dna['targets']
    end

    def infect
      SSH.passphrase = private_key_passphrase
      source_file = SourceFile.new
      source_file.copy from: source
      return unless edited_and_confirmed_for? source_file
      targets.each { |target| source_file.paste to: target }
    ensure
      source_file.close
      source_file.unlink
    end

  private

    def private_key_passphrase
      msg = [
        'If you have a passphrase for your private ssh key, enter it here.',
        'Otherwise leave blank.'
      ].join(' ')
      puts msg
      STDIN.noecho(&:gets).chomp
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
