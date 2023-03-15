//
//  SaveManager.swift
//  
//
//  Created by Loic D on 15/03/2023.
//

import Foundation

// Save cities and weather

public class SaveManager {
    public static func saveCities(_ cities: [CityWeather]) {
        if let encoded = try? JSONEncoder().encode(cities) {
            UserDefaults.standard.set(encoded, forKey: "Cities")
        }
    }
    
    public static func getCities() -> [CityWeather] {
        if let data = UserDefaults.standard.object(forKey: "Cities") as? Data,
            let cities = try? JSONDecoder().decode([CityWeather].self, from: data) {
            return cities
        }
        return []
    }
}
