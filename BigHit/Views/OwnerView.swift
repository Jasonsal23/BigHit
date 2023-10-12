//
//  OwnerView.swift
//  BigHit
//
//  Created by Jason on 8/21/23.
//

import SwiftUI

struct OwnerView: View {
    
    let maxWidthForIpad: CGFloat = 700
    @State private var estimatedWaitTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var waitlist: [String] = []
    @EnvironmentObject private var vm: LocationsViewModel
    @State private var isLoggedIn =  false
    @State private var isPopupShowing = false
    
    var body: some View {
        if isLoggedIn {
            VStack {
                header
                    .padding()
                    .frame(maxWidth: maxWidthForIpad)
                
                //            Text("Owner's Waitlist")
                //                .font(.title)
                //                .padding()
                
                Text("Waitlist: ")
                    .font(.title)
                    .foregroundColor(.red)
                    .padding()
                
                List {
                    ForEach(vm.waitlist, id: \.self) { name in
                        HStack {
                            Text(name)
                            Spacer()
                            Button("Remove") {
                                removeNameFromWaitlist(name)
                            }
                            .onTapGesture {
                                removeNameFromWaitlist(name)
                            }
                        }
                    }
                }
                HStack {
                    TextField("Enter your name", text: $nameInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Check In") {
                        addNameToWaitlist()
                        withAnimation {
                            isPopupShowing = true
                        }
                        hidePopupAfterDelay()
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
                .padding()
            }
            .onAppear {
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
            .overlay(
                NotificationPopup(isShowing: $isPopupShowing)
            )
            .onTapGesture{
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
    
        
        private func formattedTime(_ timeInterval: TimeInterval) -> String {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .abbreviated
            return formatter.string(from: timeInterval)!
        }
        
        private func startTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                updateEstimatedWaitTime()
            }
        }
        
        private func stopTimer() {
            timer?.invalidate()
            timer = nil
        }
        
    private func updateEstimatedWaitTime() {
        if !vm.waitlist.isEmpty && vm.estimatedWaitTime >= 60 {
            vm.estimatedWaitTime -= 60 // Subtracting 1 minute
        }
    }

    private func hidePopupAfterDelay() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    isPopupShowing = false
                }
            }
        }

        
        private func addNameToWaitlist(){
            guard !nameInput.isEmpty else { return }
            vm.addNameToWaitlist(nameInput)
            nameInput = ""
        }
        
        private func removeNameFromWaitlist(_ name: String) {
            vm.removeNameFromWaitlist(name)
            if let index = waitlist.firstIndex(of: name) {
                waitlist.remove(at: index)
                estimatedWaitTime -= 1500 // Removing 30 minutes
            }
        }
        @State private var nameInput: String = ""
    }
    
    
    struct OwnerView_Previews: PreviewProvider {
        static var previews: some View {
            OwnerView()
        }
    }
    
    extension OwnerView{
        
        private var header: some View{
            VStack {
                Text(vm.mapLocation.name)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
            }
            .background(.thickMaterial)
            .cornerRadius(10)
            .shadow(color:Color.black.opacity(0.3),radius:20,
                    x: 0, y: 15)
            
        }
    }

