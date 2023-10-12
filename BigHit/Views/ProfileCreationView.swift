//
//  ProfileCreationView.swift
//  BigHit
//
//  Created by Jason on 7/28/23.
//

import SwiftUI

struct Profile: Identifiable, Codable {
    var id = UUID()
    var name: String
    var phoneNumber: String
    
    // Computed property to format the phone number when saving
    var formattedPhoneNumber: String {
            let cleaned = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            let areaCode = String(cleaned.prefix(3))
            let prefix = String(cleaned.dropFirst(3).prefix(3))
            let suffix = String(cleaned.dropFirst(6).prefix(4))
            return "(\(areaCode)) \(prefix)-\(suffix)"
        }
        
        // Computed property to create a URL with the "tel" scheme for phone number
        var phoneNumberURL: URL? {
            let cleaned = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            return URL(string: "tel:\(cleaned)")
        }
    }

struct ProfileButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.blue)
            .padding(5)
            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color.gray.opacity(0.2)))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct ProfileCreationView: View {
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var profiles: [Profile] = []
    @State private var editingProfile: Profile?
    
    var isEditing: Bool {
        editingProfile != nil
    }
    
    var body: some View {
        VStack {
            Text("Create Account")
                .font(.title) // Set the font size and style of the header
                .fontWeight(.bold)
                .padding()
            
            VStack {
                TextField("Name", text: $name)
                    .padding()
                
                // Use the custom phone number field with input validation
                PhoneNumberField(phoneNumber: $phoneNumber)
                    .padding()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if isEditing {
                HStack {
                    Button("Save", action: saveEditedProfile)
                        .padding()
                    Button("Cancel", action: cancelEditing) // Add a cancel button for editing
                        .padding()
                }
            } else {
                Button("Create Account", action: saveProfile)
                    .padding()
                    .disabled(name.isEmpty || phoneNumber.isEmpty)
            }
            
            List {
                ForEach(profiles) { profile in
                    VStack(alignment: .leading) {
                        Text("Name: \(profile.name)")
                        Text("Phone Number: \(profile.formattedPhoneNumber)") // Use the formatted phone number
                        HStack {
                            Button(action: { editProfile(profile) }) {
                                Text("Edit")
                            }
                            .buttonStyle(ProfileButtonStyle()) // Apply the custom button style
                            
                            Button(action: { deleteProfile(profile) }) {
                                Text("Delete")
                                    .foregroundColor(.red) // Make the "Delete" button red
                            }
                            .buttonStyle(ProfileButtonStyle()) // Apply the custom button style
                        }
                        .padding(.top, 5)
                    }
                }
            }
        }
        .navigationBarHidden(true) // Hide the default navigation bar
        .onAppear(perform: loadProfiles)
    }
    
    func saveProfile() {
            // Perform validation checks on the name and phone number before saving
            guard !name.isEmpty, !phoneNumber.isEmpty else {
                // Display an alert or error message to prompt the user to enter both values
                return
            }
            
            // Save the profile data using UserDefaults
            profiles.append(Profile(name: name, phoneNumber: phoneNumber))
            saveProfilesToUserDefaults()
            
            // Clear the input fields after saving
            name = ""
            phoneNumber = ""
        }
    
    func saveEditedProfile() {
           // Perform validation checks on the name and phone number before saving
           guard let editingProfile = editingProfile,
                 !name.isEmpty, !phoneNumber.isEmpty else {
               // Display an alert or error message to prompt the user to enter both values
               return
           }
           
           // Update the edited profile data using UserDefaults
           if let index = profiles.firstIndex(where: { $0.id == editingProfile.id }) {
               profiles[index].name = name
               profiles[index].phoneNumber = phoneNumber
               saveProfilesToUserDefaults()
           }
           
           // Clear the input fields and reset editingProfile after saving
           name = ""
           phoneNumber = ""
           self.editingProfile = nil
       }
    
    func saveProfilesToUserDefaults() {
        if let encodedData = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(encodedData, forKey: "ProfilesKey")
        }
    }
    
    func loadProfiles() {
        // Load the saved data from UserDefaults if available
        if let data = UserDefaults.standard.data(forKey: "ProfilesKey"),
           let savedProfiles = try? JSONDecoder().decode([Profile].self, from: data) {
            profiles = savedProfiles
        }
    }
    
    func deleteProfile(_ profile: Profile) {
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles.remove(at: index)
            saveProfilesToUserDefaults()
        }
    }
    
    func editProfile(_ profile: Profile) {
        // Set the fields to the profile data when the user taps the "Edit" button
        name = profile.name
        phoneNumber = profile.phoneNumber
        editingProfile = profile
    }
    
    func cancelEditing() {
        // Clear the input fields and reset editingProfile when canceling the edit
        name = ""
        phoneNumber = ""
        self.editingProfile = nil
    }
}

// Custom TextField for phone number with input validation
struct PhoneNumberField: View {
    @Binding var phoneNumber: String
    
    var body: some View {
        TextField("Phone Number", text: $phoneNumber)
            .padding()
            .keyboardType(.numberPad)
            .onChange(of: phoneNumber) { newValue in
                // Allow only numbers and limit the input to 10 digits
                let filtered = newValue.filter { "0123456789".contains($0) }
                phoneNumber = String(filtered.prefix(10))
            }
    }
}


struct ProfileCreationView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCreationView()
    }
}
