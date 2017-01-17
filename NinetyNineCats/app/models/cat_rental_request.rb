class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, presence: true
  validates :status, presence: true, inclusion: { in: ["PENDING", "APPROVED", "DENIED"]}
  validate  :overlapping_approved_requests

  belongs_to :cat


  def overlapping_requests
    overlapping_requests = CatRentalRequest.find_by_sql([<<-SQL, cat_id, start_date, end_date])
      SELECT
        cat_rental_requests.*
      FROM
        cat_rental_requests
      WHERE
        cat_rental_requests.cat_id = ? AND NOT (cat_rental_requests.end_date < ?
        OR cat_rental_requests.start_date > ?)
    SQL
  end

  def overlapping_approved_requests
    overlapping_approved_requests = overlapping_requests.select do |request|
      request.status == "APPROVED"
    end

    unless overlapping_approved_requests.empty?
      errors[:overlapping] << "Cannot request an overlapping date."
    end
  end

  def approve!
    CatRentalRequest.transaction do
      self.status = "APPROVED"
      self.save!

      overlapping_pending_requests.each do |request|
        request.deny!
      end
    end
  end

  def overlapping_pending_requests
    overlapping_requests.select do |request|
      request.status == "PENDING" && self.id != request.id
    end
  end

  def deny!
    self.status =  "DENIED"
    self.save!
  end
end
