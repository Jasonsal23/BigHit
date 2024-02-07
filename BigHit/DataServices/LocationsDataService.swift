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
            city: "Vegas",
            contact: "(702) 930-8657",
            address: "5651 S Grand Canyon Dr #105",
            coordinates: CLLocationCoordinate2D(latitude: 36.086312, longitude: -115.307597),
            description: "5X Best Of Las Vegas Winner!",
            bio: "Home Of The $100 Skip The Line!",
            sunday: "Sunday & Monday: Closed",
            monday: "Tuesday - Friday: 8am - 6pm",
            saturday: "Saturday: 8am - 4pm",
            website: URL(string: "https://www.barbershoplasvegas.com/"),
            appointment: URL(string: "https://getsquire.com/booking/book/big-hit-barbershop-las-vegas-las-vegas"),
            imageNames: ["Barber"]
        ),
        Location(
            name: "Big Hit Barber Shop",
            cityName: "Kenosha, Wisconsin",
            city: "Kenosha",
            contact: "(262) 657-5055",
            address: "6011 39th Ave, Kenosha, WI 53142",
            coordinates: CLLocationCoordinate2D(latitude: 42.58059, longitude: -87.85500),
            description: "Best Barbershop in Kenosha!",
            bio: "Cash Only!",
            sunday: "Sunday: Closed",
            monday: "Monday - Friday: 8:30am - 5pm",
            saturday: "Saturday: 8:30am - 3pm",
            website: URL(string: "https://www.barbershoplasvegas.com/"),
            appointment: URL(string: "https://booksy.com/en-us/408993_big-hit-barbershop_barber-shop_39844_kenosha"),
            imageNames: ["Barber"]
        )
    ]
    }
