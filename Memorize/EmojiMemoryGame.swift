//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Mark Sartakov on 10.10.2020.
//

import Foundation

class EmojiMemoryGame {
    private var memoryGame: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis = ["👻", "🎃", "🕷"]
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) {
            pairIndex in emojis[pairIndex]
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
