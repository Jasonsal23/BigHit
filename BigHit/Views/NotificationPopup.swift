//
//  NotificationPopup.swift
//  BigHit
//
//  Created by Jason on 10/9/23.
//

import SwiftUI

struct NotificationPopup: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("You are checked in!")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                
                Button("OK") {
                    withAnimation{
                        isShowing = false
                    }
                }
                .padding()
            }
            .background(Color.white)
            .foregroundColor(.red)
            .font(.headline)
            .cornerRadius(10)
            .padding()
        }
        .opacity(isShowing ? 1 : 0)
        .onAppear {
            if isShowing {
                // Schedule a closure to hide the popup after 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation {
                        isShowing = false
                    }
                }
            }
        }
    }
}
