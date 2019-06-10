# Full Stack Challenge 2019

Puede ver las especificaciones del proyecto [aquí](https://drive.google.com/file/d/1pDolgbZ-tH192V9HTLl30f85X44DAs1Y/view)

## Comenzando

Se utilizó **Ruby on Rails** para la elaboración del proyecto.


### Pre-requisitos

* Ruby 2.6.3
* Rails 6.0.0

### Instalación

Para una correcta instalación siga los pasos en el siguiente [enlace](https://gorails.com/setup/ubuntu/18.04)


## Características

### Algoritmo

* Este algoritmo lo que hace es tomar el dominio de la pagina y lo concatena a un string formado por 4 caracteres (conformado por letras y números) elegidos al azar. 
* Luego de eso los une y verifica si esta Url nueva existe en la base.
* Si esta existe vuelve a realizar el cálculo de la Url pero tomando un caracter más.

```ruby
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
```

### API

Existen varios comandos con los que puede probar el API usando cURL. O por medio de una pequeña interfaz, la cual se puede visitar dando click a este [enlace](https://fullstackchallenge2019.herokuapp.com/)

#### create

Método POST. Recibe el Url original de la página y devuelve un json con las características, incluyendo la Url recortada.
```bash
$ curl -X POST -d "original_url=https://www.facebook.com/" https://fullstackchallenge2019.herokuapp.com/urls/create.json
```

#### show

Método GET. Muestra la página consultada por medio la Url recortada, la cual devuelve la información por medio de json. 
```bash
$ curl https://fullstackchallenge2019.herokuapp.com/z24q.json
```

#### top

Método GET. Muestra el top 100 de las páginas más visitas, hechas por medio del sistema.
```bash
$ curl https://fullstackchallenge2019.herokuapp.com/top.json
```

#### date

Método GET. Muestra la página más nueva en ser ingresada al sistema
```bash
$ curl https://fullstackchallenge2019.herokuapp.com/date.json
```

### Nota

* Todas estas consultas puede hacerse por medio de la interfaz con solo escribir en el navegador las rutas, quitando la consulta **curl** y la terminacion **.json**
```
https://fullstackchallenge2019.herokuapp.com/top
```
* Puede disfrutas de las aplicación por medio del código desarrollado en React, en el siguiente [enlace](https://github.com/Wikkan/FullStackChallenge2019Web)

## Construido con

* Ruby on Rails
* MetaInspector (gema)

## Autores

* **Josué Jiménez** - [Wikkan](https://github.com/Wikkan)
