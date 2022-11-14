class FileImporter
  def self.import(date, filename)
    file_linenum = 0
    file_line = ''
    data = File.new(filename).readlines.join.split("\n\n")

    ActiveRecord::Base.transaction do
      new_ps = nil

      data.each_with_index do |d, i|
        file_linenum = i
        file_line = d
        d.strip!

        if d.match?(/^session .*/i)
          new_ps = PokerSession.import(date, d)
          next
        end

        HandHistory.import(new_ps, d)
      end
    end
  end
end
