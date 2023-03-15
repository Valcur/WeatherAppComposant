//
//  CitiesWeatherViewModel.swift
//  
//
//  Created by Loic D on 15/03/2023.
//

import Foundation

public class CitiesWeatherViewModel: ObservableObject {
    public let citySearchVM: CitySeachViewModel
    public let weatherDataFetcher: WeatherDataFetcher
    @Published public var cities: [CityWeather]
    
    public init(apiKey: String) {
        cities = [CityWeather(name: "Test",
                              latitude: "",
                              longitude: "",
                              weather: nil)]
        
        citySearchVM = CitySeachViewModel()
        weatherDataFetcher = WeatherDataFetcher(apiKey: apiKey)
        
        citySearchVM.citiesWeatherVM = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.cities.first?.weather = WeatherData(currentTemp: "21",
                                                    dailyWeather: [DailyWeather(minTemp: "5", maxTemp: "12", weatherType: .rain),
                                                                   DailyWeather(minTemp: "6", maxTemp: "14", weatherType: .sun)])
        }
    }
}
