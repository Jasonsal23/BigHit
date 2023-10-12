//
//  QueueView.swift
//  BigHit
//
//  Created by Jason on 7/28/23.
//


import SwiftUI

struct QueueView: View {
    @State private var waitlist: [String] = []
    @State private var estimatedWaitTime: TimeInterval = 0
    @State private var timer: Timer?
    let maxWidthForIpad: CGFloat = 700
    @EnvironmentObject private var vm: LocationsViewModel
    @State private var isPopupShowing = false

    var body: some View {
        VStack {
            header
                .padding()
                .frame(maxWidth: maxWidthForIpad)
            
            Text("Estimated Wait Time:")
                .font(.title)
                .foregroundColor(.secondary)
                .padding(.bottom, 5)
            
            Text(formattedTime(vm.estimatedWaitTime))
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
            
            List {
                ForEach(vm.waitlist, id: \.self) { name in
                        Text(name)
                    }
                }
            
            HStack {
                TextField("Enter your name", text: $nameInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Check In") {
                    checkIn()
                    withAnimation {
                        isPopupShowing = true
                    }
                    hidePopupAfterDelay()
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
                .onTapGesture{
                    isPopupShowing = false
                }
        )
        .onTapGesture{
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    private func formattedTime(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: timeInterval) ?? ""
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
        if vm.estimatedWaitTime > 300 {
            vm.estimatedWaitTime -= 60 // Subtracting 1 minute
        }
    }


    
    private func checkIn() {
        guard !nameInput.isEmpty else { return }
        vm.addNameToWaitlist(nameInput)
        estimatedWaitTime += 1500// Adding 30 minutes
        nameInput = ""
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func hidePopupAfterDelay() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    isPopupShowing = false
                }
            }
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

struct QueueView_Previews: PreviewProvider {
    static var previews: some View {
        QueueView()
    }
}

extension QueueView{
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

