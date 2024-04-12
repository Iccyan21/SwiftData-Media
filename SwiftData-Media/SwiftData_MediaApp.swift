//
//  SwiftData_MediaApp.swift
//  SwiftData-Media
//
//  Created by 水原　樹 on 2024/04/11.
//

import SwiftUI
import SwiftData

@main
struct SwiftData_MediaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [User.self, Post.self, Comentary.self])
        }
    }
}
