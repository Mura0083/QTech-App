//
//  QTechApp.swift
//  QTech
//
//  Created by Armand on 2026-10-29.
//

import SwiftUI
import SwiftData

@main
struct QTechApp: App {
    var body: some Scene {
        WindowGroup {
            ChatView()
        }
        .modelContainer(for: MessageItem.self)
    }
}
