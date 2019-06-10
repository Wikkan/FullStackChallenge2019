require 'get_title_job'

class UrlsController < ApplicationController

  @@URL = "https://fullstackchallenge2019.herokuapp.com/" # Url de heroku con la conexion

  # Redirecciona a la página con el Url creado y devuelve la consulta en formato json
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

  # Crea una nueva Url con la Url original y devuelve la consulta en formato json
  def create
    
    url = Url.new
    url.original_url = params[:original_url]

    if url.sanitize? # Verifica que la Url esté bien escrita

      if url.find? # Verifica si la Url ya fue acortada anteriormente

        url.generate_short_url(@@URL)
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

  # Retorna el top de las páginas más visitasdas con el enlace recortado y devuelve la consulta en formato json
  def top

    url = Url.new
    @top = url.top

    respond_to do |format|
      format.html { }
      format.json { render json: {status: 'SUCCESS', data:@top}, status: :ok }
    end

  end

  # Retorna la página más neva en ser recortada y devuelve la consulta en formato json
  def date

    url = Url.new
    @date = url.date

    respond_to do |format|
      format.html { }
      format.json { render json: {status: 'SUCCESS', data:@date}, status: :ok }
    end

  end
end
