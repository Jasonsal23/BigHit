//
//  PasswordView.swift
//  BigHit
//
//  Created by Jason on 10/9/23.
//

import SwiftUI

struct LoginView: View {
    
    @State private var password = ""
    @Binding var isLoggedIn: Bool
    let maxWidthForIpad: CGFloat = 700
    @EnvironmentObject private var vm: LocationsViewModel
    @State private var selectedMode = 0
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    @State private var selectedTheme = "Dark"
    let themes = ["Dark", "Light", "Automatic"]
    
    enum AppTheme: String {
            case light, dark, system
        }
    
    var body: some View {
        
        ScrollView{
            VStack {
                header
                    .padding()
                    .frame(maxWidth: maxWidthForIpad)
                
                Image("Barber")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: maxWidthForIpad)
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                    .cornerRadius(10)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 16){
                    Text("Preferences")
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                            
                            HStack {
                                Image(systemName: "sun.max")
                                    .padding()
                                Text("Display")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding()
                                    
                                Image(systemName: "moon.fill")
                                    .padding()
                            }
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    
                    
                    Picker(selection: $vm.isDarkModeEnabled, label: Text("Display")) {
                                    Text("Light Mode").tag(false)
                                    Text("Dark Mode").tag(true)
                                    
                                    
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding()
                    
                    /*Toggle("", isOn: $vm.isDarkModeEnabled)
                        .frame(maxWidth: maxWidthForIpad)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(width: 300)
                        .toggleStyle(CustomToggleStyle())
                        .padding()*/
                    

                    }
                .frame(maxWidth: .infinity, alignment: .center)
                }
                
                VStack(alignment: .leading, spacing: 16){
                    Text("Policies & Contact")
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Button(action: {
                        if let url = URL(string: "https://www.barbershoplasvegas.com/accessibility_page") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                                    Image(systemName: "gearshape")
                                        .padding()
                                    Text("Accessibility Notice")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial).offset(y: 65))
                                        .padding()
                                    Image(systemName: "accessibility.badge.arrow.up.right")
                                        .padding()
                                }
                            .cornerRadius(10)
                            .frame(maxWidth: maxWidthForIpad)
                            .frame(height: 40)
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                    }
                    Divider()
                    Button(action: {
                        if let url = URL(string: "https://www.barbershoplasvegas.com/contact") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                                    Image(systemName: "bell")
                                        .padding()
                                    Text("Contact Us")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial).offset(y: 65))
                                        .padding()
                                    Image(systemName: "arrowshape.right")
                                        .padding()
                                }
                            .cornerRadius(10)
                            .frame(maxWidth: maxWidthForIpad)
                            .frame(height: 40)
                            .frame(maxWidth: .infinity, alignment: .center)
                    
                }

                
                HStack{
                    TextField("Shop Owner Only", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Login"){
                        if password == "abc"{
                            isLoggedIn = true
                        }
                    }
                    .padding()
                }
                if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    Text("Version: \(appVersion)")
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    Text("Version information not available")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .onTapGesture{
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }

    }
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
    
    struct CustomToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                Text("Light Mode")
                    .padding(.leading, 8)
                Toggle("", isOn: configuration.$isOn)
                    .toggleStyle(SwitchToggleStyle(tint: .red))
                Text("Dark Mode")
                    .padding(.trailing, 8)
            }
        }
    }
    
}
