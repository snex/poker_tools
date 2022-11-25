# frozen_string_literal: true

class SharedHandHistory < ApplicationRecord
  belongs_to :hand_history

  validates :expires_at, presence: true
  validates :uuid, uniqueness: true

  before_validation :set_uuid

  scope :expired, -> { where(expires_at: ..Time.zone.now) }

  def self.destroy_expired
    expired.destroy_all
  end

  private

  def set_uuid
    self.uuid = SecureRandom.hex(3) if uuid.blank?
  end
end
