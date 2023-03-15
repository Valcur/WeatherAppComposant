//
//  CitySearchViewModel.swift
//  
//
//  Created by Loic D on 15/03/2023.
//

import Foundation

// Handle city search and add the choosen city to CitiesWeatherViewModel

public class CitySeachViewModel: ObservableObject {
    public weak var citiesWeatherVM: CitiesWeatherViewModel?
}
