//
//  LocationsListView.swift
//  BigHit
//
//  Created by Jason on 2/6/24.
//

import SwiftUI

struct LocationsListView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    
    var body: some View {
        List {
            ForEach(vm.locations) { location in
                Button {
                    vm.showNextLocation(location: location)
                } label: {
                    HStack {
                        if let imageName = location.imageNames.first {
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 45, height: 45)
                                .cornerRadius(10)
                        }
                        VStack(alignment: .leading){
                            Text(location.name)
                            Text(location.cityName)
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct LocationsListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsListView()
            .environmentObject(LocationsViewModel())
    }
}
