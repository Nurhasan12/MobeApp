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
    
    var body: some Scene {
        WindowGroup {
            Home()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(CarViewModel(context: persistenceController.container.viewContext))
        }
    }
}
