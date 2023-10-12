//
//  BrightnessPreferencesView.swift
//  BigHit
//
//  Created by Jason on 10/10/23.
//

import SwiftUI

struct BrightnessPreferencesView: View {
    @Binding var isBrightnessPreferencesVisible: Bool
    @Binding var isDarkMode: Bool

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Display Preferences")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
            }
            .navigationTitle("Brightness Preferences")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        isBrightnessPreferencesVisible = false
                    }
                }
            }
        }
    }
}

