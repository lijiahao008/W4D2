# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birth_date  :date             not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string(1)        not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Cat < ActiveRecord::Base
  COLORS = ["black", "white", "green", "blue", "red", "grey"]

  validates :birth_date, :name, :description, presence: true
  validates :color, presence: true, inclusion: { :in => COLORS }
  validates :sex, presence: true, inclusion: {in: ["M", "F"]}

  def age
    ((Date.current - birth_date) / 360).to_i
  end
end
