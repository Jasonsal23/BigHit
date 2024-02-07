//
//  Location.swift
//  BigHit
//
//  Created by Jason on 7/26/23.
//

import Foundation
import MapKit

struct Location: Identifiable, Equatable{
    
    let name: String
    let cityName: String
    let city: String
    let contact : String
    let address: String
    let coordinates: CLLocationCoordinate2D
    let description: String
    let bio: String
    let sunday: String
    let monday: String
    let saturday: String
    let website: URL?
    let appointment: URL?
    let imageNames: [String]
    
    var id: String{
        name + cityName
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
}
