class PageUpdate < ActiveRecord::Base
  belongs_to :user

  def time_string
    created_at.strftime('Date: %d %B, %Y  |  Time: %H:%M:%S')
  end
end
