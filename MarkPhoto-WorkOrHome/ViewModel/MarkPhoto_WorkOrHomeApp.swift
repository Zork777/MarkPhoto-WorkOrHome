//
//  MarkPhoto_WorkOrHomeApp.swift
//  MarkPhoto-WorkOrHome
//
//  Created by Евгений Захаров on 27.01.2023.
//

import SwiftUI

@main
struct MarkPhoto_WorkOrHomeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
