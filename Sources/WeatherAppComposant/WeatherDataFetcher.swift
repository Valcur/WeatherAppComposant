//
//  WeatherDataFetcher.swift
//  
//
//  Created by Loic D on 15/03/2023.
//

import Foundation

// Get weather info from API

public class WeatherDataFetcher {
    private let API_KEY: String
    
    init(apiKey: String) {
        self.API_KEY = apiKey
    }
    
    public func updateWeatherForCities(_ cities: [CityWeather]) {
        for city in cities {
            updateWeatherDataForCity(city)
        }
    }
    
    public func updateWeatherDataForCity(_ city: CityWeather) {
        // Utilisation d'une autre API que oneCall pour ne pas entrer d'info de payement
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(city.latitude)&lon=\(city.longitude)&units=metric&lang=fr&appid=\(API_KEY)"
        print(url)
        
        guard let url = URL(string: url) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("Missing data")
                return
            }
            
            do {
                let weatherResult = try JSONDecoder().decode(WeatherResult.self, from: data)
                
                // Faux résultat pour la météo de la semaine en raison du changement d'API
                var weatherTypeString: String
                if weatherResult.weather.count > 0 {
                    weatherTypeString = weatherResult.weather.first!.main
                } else {
                    weatherTypeString = "error: no weather type"
                }
                city.weather = WeatherData(currentTemp: "\(weatherResult.main.temp)",
                                           dailyWeather: [
                                            DailyWeather(minTemp: "\(weatherResult.main.tempMin)", maxTemp: "\(weatherResult.main.tempMax)", weatherType: weatherTypeString == "clouds" ? .rain : .sun),
                                            DailyWeather(minTemp: "\(weatherResult.main.tempMin)", maxTemp: "\(weatherResult.main.tempMax)", weatherType: weatherTypeString == "clouds" ? .rain : .sun),
                                            DailyWeather(minTemp: "\(weatherResult.main.tempMin)", maxTemp: "\(weatherResult.main.tempMax)", weatherType: weatherTypeString == "clouds" ? .rain : .sun)
                                           ])
                SaveManager.saveCity(city)
            } catch {
                print(error)
                return
            }
        }.resume()
    }
    
    struct WeatherResult: Codable {
        let coord: Coord
        let weather: [Weather]
        let base: String
        let main: Main
        let visibility: Int
        let wind: Wind
        let clouds: Clouds
        let dt: Int
        let sys: Sys
        let timezone, id: Int
        let name: String
        let cod: Int
        
        struct Clouds: Codable {
            let all: Int?
        }

        struct Coord: Codable {
            let lon, lat: Double
        }

        struct Main: Codable {
            let temp, tempMin, tempMax: Double
            let feelsLike: Double?
            let pressure, humidity, seaLevel, grndLevel: Int?

            enum CodingKeys: String, CodingKey {
                case temp
                case feelsLike = "feels_like"
                case tempMin = "temp_min"
                case tempMax = "temp_max"
                case pressure, humidity
                case seaLevel = "sea_level"
                case grndLevel = "grnd_level"
            }
        }

        struct Sys: Codable {
            let type, id: Int?
            let country: String?
            let sunrise, sunset: Int?
        }

        struct Weather: Codable {
            let id: Int?
            let main, description, icon: String
        }

        struct Wind: Codable {
            let speed: Double?
            let deg: Int?
            let gust: Double?
        }
    }
}
