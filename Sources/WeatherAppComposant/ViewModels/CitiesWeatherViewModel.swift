//
//  CitiesWeatherViewModel.swift
//  
//
//  Created by Loic D on 15/03/2023.
//

import Foundation

public class CitiesWeatherViewModel: ObservableObject {
    public let citySearchVM: CitySearchViewModel
    public let weatherDataFetcher: WeatherDataFetcher
    @Published public var cities: [CityWeather]
    
    public init(apiKey: String) {
        cities = SaveManager.getCities()
        
        citySearchVM = CitySearchViewModel()
        weatherDataFetcher = WeatherDataFetcher(apiKey: apiKey)
        
        citySearchVM.citiesWeatherVM = self
    }
    
    public func addCity(_ city: CityWeather) {
        cities.append(city)
        SaveManager.saveCities(cities)
        // TODO: weatherDataFetcher.updateWeather
    }
}
