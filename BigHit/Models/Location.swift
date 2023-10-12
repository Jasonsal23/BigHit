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
    let contact : String
    let address: String
    let coordinates: CLLocationCoordinate2D
    let description: String
    let imageNames: [String]
    
    var id: String{
        name + cityName
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
}
