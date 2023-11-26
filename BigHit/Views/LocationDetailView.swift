//
//  LocationDetailView.swift
//  BigHit
//
//  Created by Jason on 7/26/23.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    let location:Location
    
    var body: some View {
        ScrollView{
            VStack{
                imageSection
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                
                VStack(alignment: .leading, spacing: 16){
                    titleSection
                    Divider()
                    descriptionSection
                    Divider()
                    mapLayer
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(backButton, alignment: .topLeading)
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView(location: LocationsDataService.locations.first!)
            .environmentObject(LocationsViewModel())
    }
}

extension LocationDetailView{
    
    private var imageSection: some View{
        TabView{
            ForEach(location.imageNames, id: \.self){
                Image($0)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width)
                    .clipped()
            }
        }
        .frame(height: 500)
        .tabViewStyle(PageTabViewStyle())
    }
    
    private var titleSection: some View{
        VStack(alignment: .leading, spacing: 8){
             Text(location.name)
                 .font(.largeTitle)
                 .fontWeight(.semibold)
            Link(location.contact, destination: phoneCallURL(phoneNumber: location.contact))
                 .font(.title3)
                 .foregroundColor(.blue)
            Link("5651 S Grand Canyon Dr #105", destination: locationMapsURL(location: location))
                 .font(.title3)
                 .foregroundColor(.red)
         }
    }
    
    private var descriptionSection: some View{
        VStack(alignment: .leading, spacing: 8){
            Text(location.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Home Of The $100 Skip The Line!")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Hours of Operation:")
                .font(.title2)
            Text("Sunday & Monday: Closed")
                .font(.subheadline)
            Text("Tuesday - Friday: 8am - 6pm")
                .font(.subheadline)
            Text("Saturday: 8am - 4pm")
                .font(.subheadline)
            Link("Website",
                 destination: URL(string:
                                    "https://www.barbershoplasvegas.com/")!)
            .font(.headline)
            Link("Book An Appointment",
                 destination: URL(string:"https://getsquire.com/booking/brands/big-hit-barbershop-las-vegas")!)
            .font(.headline)
         }
    }
    
    private var mapLayer: some View{
        Map(coordinateRegion: .constant(MKCoordinateRegion(
            center: location.coordinates,
            span: vm.mapSpan)),
            annotationItems: [location]) { location in
            MapAnnotation(coordinate: location.coordinates){
                Button(action: {
                    openInMaps(coordinate: location.coordinates)}) {
                    Text("💈")
                        .font(.largeTitle)
                        .shadow(radius: 10)
                }
            }
        }
            .allowsHitTesting(true)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(30)
    }
    
    private var backButton: some View{
        Button{
            vm.sheetLocation = nil
        } label:{
            Image(systemName: "xmark")
                .font(.headline)
                .padding(16)
                .foregroundColor(.primary)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding()
        }
    }
    private func locationMapsURL(location: Location) -> URL {
            let coordinateString = "\(location.coordinates.latitude),\(location.coordinates.longitude)"
            let urlString = "http://maps.apple.com/?q=\(coordinateString)"
            return URL(string: urlString)!
        }
    private func phoneCallURL(phoneNumber: String) -> URL {
            let cleanedPhoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
            let urlString = "tel://\(cleanedPhoneNumber)"
            return URL(string: urlString)!
        }
    
    private func openInMaps(coordinate: CLLocationCoordinate2D) {
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = vm.mapLocation.name
            mapItem.openInMaps(launchOptions: nil)
        }
}

