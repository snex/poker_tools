# frozen_string_literal: true

env :PATH, ENV.fetch('PATH')

every 1.minute do
  runner 'SharedHandHistory.destroy_expired'
end
