//
//  Devote_Swift_UIApp.swift
//  Devote-Swift-UI
//
//  Created by Haziq Abdullah on 06/05/2024.
//

import SwiftUI

@main
struct Devote_Swift_UIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
