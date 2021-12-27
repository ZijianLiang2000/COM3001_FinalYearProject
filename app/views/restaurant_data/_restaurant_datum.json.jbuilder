json.extract! restaurant_datum, :id, :city, :name, :rating, :created_at, :updated_at
json.url restaurant_datum_url(restaurant_datum, format: :json)
