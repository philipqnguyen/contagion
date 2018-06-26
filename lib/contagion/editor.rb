module Contagion
  class Editor
    def initialize
      @prompt = Prompt.new
    end

    def edit(source_file)
      source_file.rewind
      system "#{ENV.fetch('EDITOR', 'vi')} #{source_file.path}"
      confirmed_changes_for? source_file
    end

  private

    attr_reader :prompt

    def confirmed_changes_for?(source_file)
      case prompt.edit_confirmation
      when 'y'
        true
      when 'n'
        false
      when 'e'
        edit source_file
      else
        confirmed_changes_for? source_file
      end
    end
  end
end
