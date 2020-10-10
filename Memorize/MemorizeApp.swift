//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Mark Sartakov on 08.10.2020.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(emojiMemoryGame: game)
        }
    }
}
