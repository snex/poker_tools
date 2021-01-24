require_relative '../../config/environment'
require 'google_drive'

namespace :data do
  task :import, [:paths] do |t, args|
    filename = args.paths.first
    stats_sheet = ENV['SHEET']
    HandHistory.import(filename, stats_sheet)
  end
end
