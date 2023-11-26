//
//  ContentView.swift
//  BigHit
//
//  Created by Jason on 7/27/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
            TabView{
                AppointmentView()
                    .tabItem(){
                        Image(systemName: "calendar.badge.clock")
                        Text("Appointments")
                    }
                LocationsView()
                    .tabItem(){
                        Image(systemName: "location.fill")
                        Text("Location")
                    }
                OwnerView()
                    .tabItem(){
                        Image(systemName: "info.circle")
                        Text("Info")
                    }
            }
            .background(Color.black)
        }
    }

    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .environmentObject(LocationsViewModel())
        }
    }

