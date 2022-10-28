require_relative '../../config/environment'

namespace :data do
  task :import, [:paths] do |t, args|
    filename = args.paths.first
    HandHistory.import(filename)
  end
end
