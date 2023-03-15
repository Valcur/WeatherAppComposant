//
//  CityWeather.swift
//  
//
//  Created by Loic D on 15/03/2023.
//

import Foundation

public class CityWeather: ObservableObject, Codable, Identifiable {
    public var id = UUID()
    public let name: String
    public let latitude: String
    public let longitude: String
    public var weather: WeatherData? {
        didSet {
            objectWillChange.send()
        }
    }
    
    public init(id: UUID = UUID(), name: String, latitude: String, longitude: String, weather: WeatherData? = nil) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.weather = weather
    }
}

public struct WeatherData: Codable {
    public var currentTemp: String
    public var dailyWeather: [DailyWeather]
    
    public static let noWeather = WeatherData(currentTemp: "Error", dailyWeather: [])
}

public struct DailyWeather: Codable {
    public let minTemp: String
    public let maxTemp: String
    public let weatherType: WeatherType
}

public enum WeatherType: Codable {
    case rain
    case sun
    
    public func systemImage() -> String {
        switch self {
        case .rain:
            return "cloud.rain.fill"
        case .sun:
            return "sun.max.fill"
        }
    }
}
