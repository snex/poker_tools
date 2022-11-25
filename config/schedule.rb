# frozen_string_literal: true

every 1.minute do
  runner 'SharedHandHistory.destroy_expired'
end
