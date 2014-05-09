json.Ratings @ratings.each do |rating|
  json.Rating_Date rating.rating_date
  json.Rating_remark rating.remarks
  json.Total_rating rating.total_rating
  if rating.rating_details.present?
    json.Rating rating.rating_details.each do |details|
      json.Factor_id details.factor.id
      json.Factor_name details.factor.try(:name)
      json.rating details.rating_value
    end
  end
end