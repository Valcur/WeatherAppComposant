//
//  CitySearchViewModel.swift
//  
//
//  Created by Loic D on 15/03/2023.
//

import Foundation

import Foundation
import MapKit
import Combine

public class CitySearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    public weak var citiesWeatherVM: CitiesWeatherViewModel?
    @Published public var searchQuery = ""
    public var completer: MKLocalSearchCompleter
    @Published public var completions: [MKLocalSearchCompletion] = []
    var cancellable: AnyCancellable?
    
    override init() {
        completer = MKLocalSearchCompleter()
        completer.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
        super.init()
        cancellable = $searchQuery.assign(to: \.queryFragment, on: self.completer)
        completer.delegate = self
    }
    
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.completions = completer.results
    }
    
    public func addPlace(place: MKLocalSearchCompletion) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("\(place.title), \(place.subtitle)") { [self] placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude ?? 0
            let lon = placemark?.location?.coordinate.longitude ?? 0
            print("Lat: \(lat), Lon: \(lon)")
            
            citiesWeatherVM?.addCity(CityWeather(name: place.title,
                                                 latitude: "\(lat)",
                                                 longitude: "\(lon)"))
        }
    }
}

extension MKLocalSearchCompletion: Identifiable {}
