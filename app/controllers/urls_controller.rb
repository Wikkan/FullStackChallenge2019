require 'get_title_job'

class UrlsController < ApplicationController

  @@URL = "https://fullstackchallenge2019.herokuapp.com/" # Url of heroku with connection

  # Redirect to the page with the created Url and return the query in json format
  def show

    begin
    
      url = Url.new
      original_url = url.find_by_short_url(@@URL + params[:short_url]).original_url
      url.update_visits(@@URL + params[:short_url])

      respond_to do |format|
          format.html { redirect_to original_url }
          format.json { render json: {status: 'SUCCESS', data:original_url}, status: :ok }
      end

    rescue

      respond_to do |format|
          format.html { redirect_to shortened_path(original_url: url.original_url, short_url: "", title: "", visit_count: "", obs: "\"" + @@URL + params[:short_url] + "\" -> Url doesn't exist in the base") }
          format.json { render json: {status: 'ERROR'}, status: :error }
      end
        
    end
  end

  # Create a new URL with the original URL and return the query in json format
  def create
    
    url = Url.new
    url.original_url = params[:original_url]

    if url.sanitize? # Check that the URL is in the correct format

      if url.find? # Check if the URL has already been shortened previously

        url.short_url_algorithm()
        url.visit_count = 0
        url.save
        
        job = GetTitleJob.new
        job.get_title(url.short_url)
        
        respond_to do |format|
          format.html { redirect_to shortened_path(original_url: url.original_url, short_url: url.short_url, title: url.find_duplicate.title, visit_count: url.visit_count, obs: "New Url") }
          format.json { render json: {status: 'SUCCESS', data:[{original_url: url.original_url, short_url: url.short_url, title: url.find_duplicate.title, visit_count: url.visit_count, obs: "New Url"}]}, status: :ok }
        end

      else

        respond_to do |format|
          format.html { redirect_to shortened_path(original_url: url.original_url, short_url: url.find_duplicate.short_url, title: url.find_duplicate.title, visit_count: url.find_duplicate.visit_count, obs: "The Url has already been shortened") }
          format.json { render json: {status: 'SUCCESS', data:[{original_url: url.original_url, short_url: url.find_duplicate.short_url, title: url.find_duplicate.title, visit_count: url.find_duplicate.visit_count, obs: "The Url has already been shortened"}]}, status: :ok }
        end

      end

    else

      respond_to do |format|
          format.html { redirect_to error_path(original_url: url.original_url, short_url: "", title: "", visit_count: "", obs: "Url format is invalid") }
          format.json { render json: {status: 'ERROR'}, status: :ok }
      end

    end
  end

  # Returns the top 100 of the most visited pages with the clipped link and returns the query in json format
  def top

    url = Url.new
    @top = url.top

    respond_to do |format|
      format.html { }
      format.json { render json: {status: 'SUCCESS', data:@top}, status: :ok }
    end

  end

  # Returns the newest page to be cropped and returns the query in json format
  def date

    url = Url.new
    @date = url.date

    respond_to do |format|
      format.html { }
      format.json { render json: {status: 'SUCCESS', data:@date}, status: :ok }
    end

  end
end
