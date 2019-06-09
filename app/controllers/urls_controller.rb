require 'get_title_job'

class UrlsController < ApplicationController

  def show

    begin
    
      url = Url.new
      original_url = url.find_by_short_url("http://localhost:3000/" + params[:short_url]).original_url
      url.update_visits("http://localhost:3000/" + params[:short_url])

      respond_to do |format|
          format.html { redirect_to original_url }
          format.json { render json: {status: 'SUCCESS', data:original_url}, status: :ok }
      end

    rescue

      respond_to do |format|
          format.html { redirect_to shortened_path(original_url: url.original_url, short_url: "", title: "", visit_count: "", obs: "\"" + "http://localhost:3000/" + params[:short_url] + "\" -> is not a Short URL  0_0") }
          format.json { render json: {status: 'ERROR'}, status: :error }
      end
        
    end
  end

  # Create a Url object and set the parameters to the object
  def create
    
    url = Url.new
    url.original_url = params[:original_url]

    if url.sanitize?

      if url.find?

        url.generate_short_url("http://localhost:3000/")
        url.visit_count = 0
        url.save
        
        job = GetTitleJob.new
        job.get_title(url.short_url)
        
        respond_to do |format|
          format.html { redirect_to shortened_path(original_url: url.original_url, short_url: url.short_url, title: url.find_duplicate.title, visit_count: url.visit_count, obs: "New shortened") }
          format.json { render json: {status: 'SUCCESS', data:url.short_url}, status: :ok }
        end

      else

        respond_to do |format|
          format.html { redirect_to shortened_path(original_url: url.original_url, short_url: url.find_duplicate.short_url, title: url.find_duplicate.title, visit_count: url.find_duplicate.visit_count, obs: "Before shortened") }
          format.json { render json: {status: 'SUCCESS', data:url.find_duplicate.short_url}, status: :ok }
        end

      end

    else

      respond_to do |format|
          format.html { redirect_to error_path(original_url: url.original_url, short_url: "", title: "", visit_count: "", obs: "URL unreachable or has invalid format  (0_0)") }
          format.json { render json: {status: 'ERROR'}, status: :ok }
      end

    end
  end

  def top

    url = Url.new
    @top = url.top

    respond_to do |format|
      format.html { }
      format.json { render json: {status: 'SUCCESS', data:@top}, status: :ok }
    end

  end
end
