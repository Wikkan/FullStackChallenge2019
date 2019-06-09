require 'metainspector'
require 'urls_controller'

class Url < ApplicationRecord

  # This short_url generator is too simple, uses Base64 module and the initials chars of the original_url variable to generate a code.
  # Starts using the char number 1 of the string original_url to generate the Base64 code, and take another and another char to 
  # generate a new code if that code already exist on the database.
  def generate_short_url(domain_name)

    unique_id_length = 4
    condition = true
    
    while(condition)

      self.short_url = domain_name + ([*('a'..'z'),*('0'..'9')]).sample(unique_id_length).join
      
      if Url.find_by_short_url(self.short_url).nil?
        condition = false
      else
        unique_id_length = unique_id_length + 1
      end
      
    end
    
  end

  # Look if the url given already was shortened  
  def find_duplicate
    Url.find_by_original_url(self.original_url)
  end

  # Find duplicate using short_url
  def find_by_short_url(short_url)
    Url.find_by_short_url(short_url)
  end

  # Update count of visits
  def update_visits(short_url)

    url = Url.find_by_short_url(short_url)
    url.visit_count = url.visit_count + 1
    url.save
  
  end

  # Return true if the url given already was shortened
  def find?
    find_duplicate.nil?
  end

  # Sanitize and check if URL given has a valid format
  def sanitize?
    begin
      self.original_url.strip!
      page = MetaInspector.new(self.original_url)
      true
    rescue
      false
    end
  end

  # Gets the top 100
  def top
    Url.order(visit_count: :asc).limit(100).reverse
  end
end
