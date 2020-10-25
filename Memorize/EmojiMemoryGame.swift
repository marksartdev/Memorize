//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Mark Sartakov on 10.10.2020.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var memoryGame: MemoryGame<String> = MemoryGame<String>()
    private var themes: Array<Theme> = []
    private var currentTheme: Theme?
    
    init() {
        themes.append(Theme(name: "Halloween", emojis: ["😈", "👹", "👺", "🤡", "👻", "💀", "☠️", "👽", "👾", "🤖", "🎃", "🕷"], numberOfPairsOfCards: 6, colors: [Color.red]))
        themes.append(Theme(name: "Animals", emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮"], numberOfPairsOfCards: 6, colors: [Color.orange]))
        themes.append(Theme(name: "Sports", emojis: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🥏", "🎱", "🪀", "🏓", "🏸", "🏒"], numberOfPairsOfCards: 7, colors: [Color.yellow]))
        themes.append(Theme(name: "Faces", emojis: ["😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "☺️", "😊", "😇", "🙂"], numberOfPairsOfCards: 7, colors: [Color.green]))
        themes.append(Theme(name: "Foods", emojis: ["🍏", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍈", "🍒", "🍑", "🍍"], numberOfPairsOfCards: nil, colors: [Color.blue]))
        themes.append(Theme(name: "Cars", emojis: ["🚗", "🚕", "🚙", "🏎", "🚓", "🚑", "🚒", "🚐", "🚚", "🚜", "🚌", "🚎"], numberOfPairsOfCards: nil, colors: [Color.red, Color.blue]))
    }
    
    // MARK: - Access to Model
    
    var score: Int {
        memoryGame.score
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        memoryGame.cards
    }
    
    // MARK: - Intens(s)
    
    func startNewGame() {
        currentTheme = themes.randomElement()
        let theme = currentTheme!
        let emojisCount = theme.emojis.count
        let numberOfPairsOfCards = theme.numberOfPairsOfCards ?? Int.random(in: 3..<emojisCount)
        let offset = Int.random(in: 0..<emojisCount)
        
        memoryGame.startNewGame(numberOfPairsOfCards: numberOfPairsOfCards) { pairIndex in
            theme.emojis[(pairIndex + offset) % emojisCount]
        }
    }
    
    func choose(card: MemoryGame<String>.Card) {
        memoryGame.choose(card: card)
    }
    
    // MARK: - Theme
    
    var name: String {
        if let theme = currentTheme {
            return theme.name
        }
        
        return ""
    }
    
    var colors: Array<Color> {
        if let theme = currentTheme {
            return theme.colors
        }
        
        return []
    }
    
    struct Theme {
        var name: String
        var emojis: Array<String>
        var numberOfPairsOfCards: Int?
        var colors: Array<Color>
    }
}
