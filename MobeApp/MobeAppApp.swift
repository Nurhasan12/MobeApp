//
//  MobeAppApp.swift
//  MobeApp
//
//  Created by Mac on 11/09/25.
//

import SwiftUI

@main
struct MobeAppApp: App {
    let persistenceController = PersistenceController.shared
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView()
                        .transition(.opacity)
                } else {
                    Home()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(CarViewModel(context: persistenceController.container.viewContext))
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.6), value: showSplash)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        showSplash = false
                    }
                }
            }
        }
    }
}
