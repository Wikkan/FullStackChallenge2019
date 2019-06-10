# Full Stack Challenge 2019

You can see the project specifications in the following [link](https://drive.google.com/file/d/1pDolgbZ-tH192V9HTLl30f85X44DAs1Y/view)

## Starting

** Ruby on Rails ** was used to prepare the project.


### Requirements

* Ruby 2.6.3
* Rails 6.0.0

### Installation

For a correct installation follow the steps in the following [link](https://gorails.com/setup/ubuntu/18.04)


## Project features

### Algorithm

* This algorithm takes the original domain of the page, codifies it in a base 64. 
* It concatenates to a string formed by 2 characters chosen at random from the same base.
* After that, join them and verify if this new URL exists in the database. 
* If it exists, recalculate the URL but take one more character.

```ruby
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
```

### API

There are several commands with which you can test the API using cURL. Or by means of a small interface, which can be visited by clicking on this [link](https://fullstackchallenge2019.herokuapp.com/)

#### create

POST method. It receives the original URL of the page and returns a json with the characteristics, including the trimmed URL.
```bash
$ curl -X POST -d "original_url=https://www.facebook.com/" https://fullstackchallenge2019.herokuapp.com/urls/create.json
```

#### show

GET method. Shows the page consulted by means of the clipped URL, which returns the information through json.
```bash
$ curl https://fullstackchallenge2019.herokuapp.com/z24q.json
```

#### top

GET method. It shows the top 100 of the most visited pages, made through the system.
```bash
$ curl https://fullstackchallenge2019.herokuapp.com/top.json
```

#### date

GET method. Displays the newest page to be entered into the system.
```bash
$ curl https://fullstackchallenge2019.herokuapp.com/date.json
```

### Note

* All these queries can be done through the interface with just writing the routes in the browser, removing the query **curl** and ending **.json **
```
https://fullstackchallenge2019.herokuapp.com/top
```
* You can enjoy the application through the code developed in React, in the following [link](https://github.com/Wikkan/FullStackChallenge2019Web)

## Tools

* Ruby on Rails
* MetaInspector (gem)
* Base64 (gem)

## Authors

* **Josué Jiménez** - [Wikkan](https://github.com/Wikkan)
