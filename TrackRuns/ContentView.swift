//
//  ContentView.swift
//  TrackRuns
//
//  Created by Lacour Hugo on 20/11/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Accueil")
                }
            
            HistoryView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("Historique")
                }
            
            EventsView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Événements")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Options")
                }
        }
    }
}

#Preview {
    ContentView()
}
