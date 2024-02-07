//
//  LocationView.swift
//  BigHit
//
//  Created by Jason on 7/26/23.
//

import SwiftUI
import MapKit

struct LocationsView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    let maxWidthForIpad: CGFloat = 700
    
    var body: some View {
        ZStack{
            mapLayer
                
            VStack(spacing: 0) {
                header
                    .padding()
                    .frame(maxWidth: maxWidthForIpad)
                
                Spacer()
                locationsPreviewStack
            }
        }
        .sheet(item: $vm.sheetLocation, onDismiss: nil){ location in
            LocationDetailView(location: location)
        }
    }
}
    

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LocationsViewModel())
    }
}

extension LocationsView{
    
    private var header: some View{
        VStack {
            Button(action: vm.toggleLocationsList){
                Text(vm.mapLocation.name + ", " + vm.mapLocation.city)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: vm.mapLocation)
                    .overlay(alignment: .leading){
                        Image(systemName: "line.3.horizontal")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            /*.rotationEffect(Angle(degrees:
                                vm.showLocationsList ? 180 : 0))*/
                    }
            }
            
            if vm.showLocationsList{
                LocationsListView()
            }
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color:Color.black.opacity(0.3),radius:20,
                x: 0, y: 15)
        
    }
      
    
    private var mapLayer: some View{
        Map(coordinateRegion: $vm.mapRegion,
            annotationItems: vm.locations,
            annotationContent: { location in
            MapAnnotation(coordinate: location.coordinates){
                Button(action: {
                    openInMaps(coordinate: location.coordinates)}) {
                    Text("💈")
                        .font(.largeTitle)
                        .shadow(radius: 10)
                }
            }
        })
    }
    
    private var locationsPreviewStack: some View{
        ZStack{
            ForEach(vm.locations){ location in
                if vm.mapLocation == location{
                    LocationPreviewView(location: location)
                        .shadow(color:Color.black.opacity(0.3),radius:20)
                        .padding()
                        .frame(maxWidth: maxWidthForIpad)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
                        )
                        .offset(y: -10)
                }
            }
        }
    }
    private func openInMaps(coordinate: CLLocationCoordinate2D) {
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = vm.mapLocation.name
            mapItem.openInMaps(launchOptions: nil)
        }
}
