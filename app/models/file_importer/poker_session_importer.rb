# frozen_string_literal: true

class FileImporter
  class PokerSessionImporter
    def self.import(date, data)
      PokerSessionParser.new(date, data).call
    end
  end
end
