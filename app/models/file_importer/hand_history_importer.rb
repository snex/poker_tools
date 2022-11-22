# frozen_string_literal: true

class FileImporter
  class HandHistoryImporter
    def self.import(poker_session, data)
      HandHistoryParser.new(poker_session, data).call

      poker_session
    end
  end
end
