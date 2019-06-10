require 'metainspector'

# Job para retornar el título de la página en la gema MetaInspector, el cual permite sacar datos de una
# página por medio de una Url.
class GetTitleJob < ApplicationJob

  	def get_title(new_url)
	
	    url = Url.find_by_short_url(new_url)
	    page = MetaInspector.new(url.original_url)
	    url.title = page.title
	    url.save
  	
  	end
end
