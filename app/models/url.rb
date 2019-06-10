require 'metainspector'
require 'urls_controller'

class Url < ApplicationRecord

  # Este algoritmo lo que hace es tomar el dominio de la pagina y lo concatena a un string formado por
  # 4 letras y número elegidos al azar. Luego de eso los une y verifica si esta Url nueva existe en la
  # base. Si esta existe vuelve a realizar el cálculo de la Url pero tomando un caracter más.
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

  # Encuenta si el Url ya existe en la base 
  def find_duplicate
    Url.find_by_original_url(self.original_url)
  end

  # Encuenta si el Url ya existe recortada en la base 
  def find_by_short_url(short_url)
    Url.find_by_short_url(short_url)
  end

  # Actualiza la cantidad de visitas de la página
  def update_visits(short_url)

    url = Url.find_by_short_url(short_url)
    url.visit_count = url.visit_count + 1
    url.save
  
  end

  # Verifica si ya existe la Url recortada
  def find?
    find_duplicate.nil?
  end

  # Verifica si la Url tiene un formato correcto
  def sanitize?
    begin
      self.original_url.strip!
      page = MetaInspector.new(self.original_url)
      true
    rescue
      false
    end
  end

  # Devuelve las 100 Urls más visitasdas por la aplicación
  def top
    Url.order(visit_count: :desc).limit(100)
  end

  # Devuelve la última Url ingresada
  def date
    Url.order(created_at: :desc).limit(1)
  end
end
