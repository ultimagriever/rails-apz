class Weather

  def self.read
    Rails.cache.read('weather')
  end

  def self.write
    require 'open-uri'
    json = open('http://api.openweathermap.org/data/2.5/weather?q=Sao_Paulo,br&units=metric&APPID=4ddba1b714f818e7b23f3efcfcf526f6').read
    hash = JSON.parse json
    hash['datetime'] = Time.now.to_i
    Rails.cache.write('weather', hash)
    hash
  end

  def self.fetch
    if read
      if age > 60
        WeatherUpdateJob.perform_later
      end
      read
    else
      write
    end
  end

  def self.age
    if read
      (Time.now - Time.at(read['datetime']).to_datetime) / 1.minute
    end
  end
end