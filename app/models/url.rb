require 'metainspector'
require 'urls_controller'
require 'base64'

class Url < ApplicationRecord

  @@URL = "https://fullstackchallenge2019.herokuapp.com/"

  # This algorithm takes the original domain of the page, codifies it in a base 64. It 
  # concatenates to a string formed by 2 characters chosen at random from the same base.
  # After that, join them and verify if this new URL exists in the database. If it exists,
  # recalculate the URL but take one more character.
  def short_url_algorithm()

    unique_id_length = 2
    
    loop do 
      self.short_url = @@URL + (Base64.encode64(self.original_url).split('')).sample(unique_id_length).join()
      
      if Url.find_by_short_url(self.short_url).nil?
        break
      else
        unique_id_length = unique_id_length + 1
      end
      
    end
    
  end

  # Find if the Url already exists in the base 
  def find_duplicate
    Url.find_by_original_url(self.original_url)
  end

  # Find if the Url already exists trimmed in the base 
  def find_by_short_url(short_url)
    Url.find_by_short_url(short_url)
  end

  # Update the number of page views
  def update_visits(short_url)

    url = Url.find_by_short_url(short_url)
    url.visit_count = url.visit_count + 1
    url.save
  
  end

  # Check if the trimmed Url already exists
  def find?
    find_duplicate.nil?
  end

  # Check if the URL is in the correct format
  def sanitize?
    begin
      self.original_url.strip!
      page = MetaInspector.new(self.original_url)
      true
    rescue
      false
    end
  end

  # Returns the 100 Urls most visited by the application
  def top
    Url.order(visit_count: :desc).limit(100)
  end

  # Returns the last entered Url
  def date
    Url.order(created_at: :desc).limit(1)
  end
end
