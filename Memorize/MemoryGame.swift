//
//  MemoryGame.swift
//  Memorize
//
//  Created by Mark Sartakov on 10.10.2020.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private let maxScorePerMatch = 10
    private let maxPenalizingPerMismatch = 5
    private let timeFactor: Double = 3
    private var choiceFirstCartInPairTime: Date = Date()
    private(set) var score: Int = 0
    private(set) var cards = Array<Card>()
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set {
            for index in cards.indices {
                if cards[index].isFaceUp {
                    cards[index].isBeenSeen = true
                }
                cards[index].isFaceUp = index == newValue
            }
            choiceFirstCartInPairTime = Date()
        }
    }
    
    private mutating func calculateScore(isMatching: Bool) {
        let choiceTimeFactor = Int(abs((timeFactor * choiceFirstCartInPairTime.timeIntervalSinceNow).rounded()))
        if isMatching {
            score += max((maxScorePerMatch - choiceTimeFactor), 1)
        } else {
            score -= max(min(choiceTimeFactor, maxPenalizingPerMismatch), 1)
        }
    }
    
    mutating func startNewGame(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        score = 0
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    
                    calculateScore(isMatching: true)
                } else {
                    if cards[chosenIndex].isBeenSeen {
                        calculateScore(isMatching: false)
                    }
                    if cards[potentialMatchIndex].isBeenSeen {
                        calculateScore(isMatching: false)
                    }
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isBeenSeen: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}
