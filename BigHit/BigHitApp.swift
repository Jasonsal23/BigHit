//
//  BigHitApp.swift
//  BigHit
//
//  Created by Jason on 7/26/23.
//

import SwiftUI

@main
struct BigHitApp: App {
    
    @State private var isPasswordCorrect = false
    @State private var waitlist: [String] = []
    @StateObject private var vm = LocationsViewModel()
    @AppStorage("appTheme") private var appTheme: LoginView.AppTheme = .system

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(vm.isDarkModeEnabled ? .dark : .light)
                .environmentObject(vm)
                .sheet(isPresented: $isPasswordCorrect){
                    OwnerView()
                        .environmentObject(vm)
                }
        }
    }
}

