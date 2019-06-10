require 'metainspector'

# This job returns the title of the page in the MetaInspector gem, which allows 
# to extract data from a page by means of an Url.
class GetTitleJob < ApplicationJob

  	def get_title(new_url)
	
	    url = Url.find_by_short_url(new_url)
	    page = MetaInspector.new(url.original_url)
	    url.title = page.title
	    url.save
  	
  	end
end
