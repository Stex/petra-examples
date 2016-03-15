json.(@philosopher, :number, :name, :identifier, :avatar_url)

json.left_stick do
  json.(@philosopher.left_stick, :number, :taken_by)
end

json.right_stick do
  json.(@philosopher.right_stick, :number, :taken_by)
end
