require 'metainspector'

class GetTitleJob < ApplicationJob

  	def get_title(new_url)
	
	    url = Url.find_by_short_url(new_url)
	    page = MetaInspector.new(url.original_url)
	    url.title = page.title
	    url.save
  	
  	end
end
