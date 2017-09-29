json.data do
  json.customer do
    json.(@customer,:id,:user_name,:email)
  end
end

json.status do
  json.code '200'
  json.message 'OK'
end

