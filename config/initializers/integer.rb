class Integer
  def to_elapsed_time
    mins = (self / 60) % 60
    hrs  = (self / 3600)
    "#{hrs}:#{'%02d' % mins}"
  end
end
