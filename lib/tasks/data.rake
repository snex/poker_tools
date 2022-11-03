require_relative '../../config/environment'

namespace :data do
  task :import, [:paths] do |t, args|
    filename = args.paths.first
    date = File.basename(filename.split('.')[0], '.*')
    HandHistory.import(date, filename)
  end
end
