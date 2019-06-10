json.arry!(@top) do |url|
	json.extract! url, :original_url, :short_url, :title, :visit_count
	json.url url_url(url, format: :json)
end