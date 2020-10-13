//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Mark Sartakov on 10.10.2020.
//

import Foundation

class EmojiMemoryGame: ObservableObject {
    @Published private var memoryGame: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis = ["😈", "👹", "👺", "🤡", "👻", "💀", "☠️", "👽", "👾", "🤖", "🎃", "🕷"]
        let numberOfPairsOfCards = Int.random(in: 2...5)
        let randomOffset = Int.random(in: 0..<emojis.count)
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairsOfCards) {
            pairIndex in emojis[(pairIndex + randomOffset) % emojis.count]
        }
    }
    
    // MARK: - Access to Model
    
    var cards: Array<MemoryGame<String>.Card> {
        memoryGame.cards
    }
    
    // MARK: - Intens(s)
    
    func choose(card: MemoryGame<String>.Card) {
        memoryGame.choose(card: card)
    }
}
