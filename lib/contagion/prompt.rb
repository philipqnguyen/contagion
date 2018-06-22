module Contagion
  class Prompt
    def passphrase
      msg = [
        'If you have a passphrase for your private ssh key, enter it here.',
        'Otherwise leave blank.'
      ].join(' ')
      puts msg
      nil_if_empty_from STDIN.noecho(&:gets).chomp
    end

    def edit_confirmation
      puts 'Ready to push the new file to all targets?'
      puts '  y - Yes! Push them all up!'
      puts '  n - No! Get me out of here!'
      puts '  e - Edit the file again.'
      nil_if_empty_from STDIN.gets.chomp.downcase
    end

  private

    def nil_if_empty_from(input)
      input.empty? ? nil : input
    end
  end
end
