//
//  LocationViewModel.swift
//  BigHit
//
//  Created by Jason on 7/26/23.
//

import Foundation
import MapKit
import SwiftUI
import AppTrackingTransparency

class LocationsViewModel: ObservableObject{
    
    @Published var isDarkModeEnabled: Bool = false // Initialize as per user's preference

    
    @Published var waitlist: [String] = []
    @Published var estimatedWaitTime: TimeInterval = 0
//    @Published var phoneNumberList: [String] = []
    
    //loaded location
    @Published var locations: [Location]
    
    //current location
    @Published var mapLocation: Location{
        didSet{
            updateMapRegion(location: mapLocation)
            objectWillChange.send()
            
            // Handle the appointment URL update here
                        webViewURL = mapLocation.appointment?.absoluteString ?? ""
        }
    }
    
    // Additional property to store the web view URL
        @Published var webViewURL: String = ""
    
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
    
    @Published var showLocationsList: Bool = false
    
    //location detail via sheet
    @Published var sheetLocation: Location? = nil
    
    private let waitlistKey = "WaitlistKey"
    private let estimatedWaitTimeKey = "EstimatedWaitTimeKey"
    private var timer: Timer?
    private let defaultEstimatedWaitTime: TimeInterval = 300
    
    init(){
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        
        // Load the waitlist data from UserDefaults
        if let savedWaitlist = UserDefaults.standard.stringArray(forKey: waitlistKey) {
            waitlist = savedWaitlist
                }
        estimatedWaitTime = UserDefaults.standard.double(forKey: estimatedWaitTimeKey)
        if estimatedWaitTime <= 0 {
            estimatedWaitTime = defaultEstimatedWaitTime
        }
        
        self.updateMapRegion(location: locations.first!)
        
        startTimer()
    }
    
    private func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateEstimatedWaitTime()
        }
    }
    
    private func stopTimer() {
            timer?.invalidate()
            timer = nil
        }
    
    private func saveWaitlistToUserDefaults(){
        UserDefaults.standard.set(waitlist, forKey: waitlistKey)
    }
    
    private func loadWaitlist(){
        if let savedWaitlist = UserDefaults.standard.array(forKey: waitlistKey) as? [String]{
            waitlist = savedWaitlist
        }
    }
    
    private func saveEstimatedWaitTimeToUserDefaults() {
        UserDefaults.standard.set(estimatedWaitTime, forKey: estimatedWaitTimeKey)
    }
    
    private func updateEstimatedWaitTime() {
        if estimatedWaitTime > 300 {
            if estimatedWaitTime > 60 { // Only subtract if the estimated wait time is over 1 minute
                estimatedWaitTime -= 60 // Subtracting 1 minute
            }

            // Ensure it doesn't go below 5 minutes
            if estimatedWaitTime < 300 {
                estimatedWaitTime = 300
            }

            // Save the updated estimated wait time to UserDefaults
            saveEstimatedWaitTimeToUserDefaults()
        }
    }
    
    func toggleLocationsList(){
        withAnimation(.easeInOut){
            showLocationsList = !showLocationsList
        }
    }
    
    func showNextLocation(location: Location) {
        withAnimation(.easeInOut) {
            mapLocation = location
            showLocationsList = false
        }
    }



    
    private func updateMapRegion(location: Location){
        withAnimation(.easeInOut){
            mapRegion = MKCoordinateRegion(
                center: location.coordinates,
                span: mapSpan)
        }
    }
    func removeNameFromWaitlist(_ name: String){
        if let index = waitlist.firstIndex(of: name){
            waitlist.remove(at: index)
            estimatedWaitTime -= 1500 //remove 25 minutes
            
            if estimatedWaitTime < 300 {
                estimatedWaitTime = 300
            }
            
            saveWaitlistToUserDefaults()
            saveEstimatedWaitTimeToUserDefaults()
            
            objectWillChange.send()
        }
    }
    
    func addNameToWaitlist(_ name: String){
        waitlist.append(name)
        
        if waitlist.count >= 2 {
            estimatedWaitTime += 1500
        }
        saveWaitlistToUserDefaults()
        saveEstimatedWaitTimeToUserDefaults()
        objectWillChange.send()
    }
    
    func requestTrackingPermissionIfNeeded() {
            if #available(iOS 14.5, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    DispatchQueue.main.async {
                        switch status {
                        case .authorized:
                            // Tracking is authorized, you can continue with your logic.
                            break
                        case .denied, .restricted:
                            // Handle the case where tracking is not authorized.
                            print("Tracking not authorized")
                        case .notDetermined:
                            // Tracking permission not yet determined.
                            print("Tracking permission not yet determined")
                        @unknown default:
                            // Handle any unknown cases.
                            print("Unknown tracking authorization status")
                        }
                    }
                }
            }
        }
}
