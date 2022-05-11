json.extract! user_rest_loc_datum, :id, :lsoa_name, :lad_name, :cluster_name, :lat, :long, :rest_cat, :score, :user, :created_at, :updated_at
json.url user_rest_loc_datum_url(user_rest_loc_datum, format: :json)
