//
//  AppointmentView.swift
//  BigHit
//
//  Created by Jason on 11/26/23.
//

import SwiftUI
import WebKit

struct AppointmentView: View {
    let maxWidthForIpad: CGFloat = 700
    @EnvironmentObject private var vm: LocationsViewModel

    var body: some View {
        VStack {
            header
                .padding()
                .frame(maxWidth: maxWidthForIpad)

            /*// Add WebView with a web link
            WebView(urlString: "https://getsquire.com/booking/brands/big-hit-barbershop-las-vegas")
                .edgesIgnoringSafeArea(.all)*/
            
            // Add WebView with a dynamic web link
                        WebView(urlString: vm.mapLocation.appointment?.absoluteString ?? "")
                            .edgesIgnoringSafeArea(.all)
            
        }
    }
}

struct AppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentView()
    }
}

extension AppointmentView {
    /*(private var header: some View {
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
    }*/
    private var header: some View{
        VStack {
            Button(action: vm.toggleLocationsList){
                Text(vm.mapLocation.name + ", " + vm.mapLocation.city)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: vm.mapLocation)
                    .overlay(alignment: .leading){
                        Image(systemName: "line.3.horizontal")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            /*.rotationEffect(Angle(degrees:
                                vm.showLocationsList ? 180 : 0))*/
                    }
            }
            
            if vm.showLocationsList{
                LocationsListView()
            }
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color:Color.black.opacity(0.3),radius:20,
                x: 0, y: 15)
        
    }
}

struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }
    }
}
