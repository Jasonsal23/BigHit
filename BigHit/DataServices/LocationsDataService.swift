//
//  LocationsDataService.swift
//  MapTest
//
//  Created by Nick Sarno on 11/26/21.
//

import Foundation
import MapKit

class LocationsDataService {
    
    static let locations: [Location] = [
        Location(
            name: "Big Hit Barber Shop",
            cityName: "Las Vegas, Nevada",
            contact: "(702) 930-8657",
            address: "5651 S Grand Canyon Dr #105,Las Vegas, NV 89148",
            coordinates: CLLocationCoordinate2D(latitude: 36.086312, longitude: -115.307597),
            description: "5X Best Of Las Vegas Winner!",
            imageNames: ["Barber"]
        )]
    }
