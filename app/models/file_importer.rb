# frozen_string_literal: true

class FileImporter
  def self.import(date, filename)
    data = File.new(filename).readlines.join.split("\n\n")
    poker_session = nil

    ActiveRecord::Base.transaction do
      data.each do |datum|
        poker_session = parse_datum(datum, date, poker_session)
      end
    end
  end

  private_class_method def self.parse_datum(datum, date, poker_session)
    datum.strip!

    if datum.match?(/^session .*/i)
      PokerSessionImporter.import(date, datum)
    else
      HandHistoryImporter.import(poker_session, datum)
    end
  end
end
