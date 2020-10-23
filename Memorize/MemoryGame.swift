//
//  MemoryGame.swift
//  Memorize
//
//  Created by Mark Sartakov on 10.10.2020.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    let maxScorePerMatch = 10
    let maxPenalizingPerMismatch = 5
    var score: Int = 0
    var cards = Array<Card>()
    var lastChoiceFirstCartTime: Date = Date()
    var lastChoiceSecondCartTime: Date = Date()
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set {
            for index in cards.indices {
                if cards[index].isFaceUp {
                    cards[index].isBeenSeen = true
                }
                cards[index].isFaceUp = index == newValue
            }
            lastChoiceFirstCartTime = Date()
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
        
        let now = Date()
        lastChoiceFirstCartTime = now
        lastChoiceSecondCartTime = now
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
                lastChoiceSecondCartTime = Date()
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    private mutating func calculateScore(isMatching: Bool) {
        let deltaBetweenCardsInPair = lastChoiceFirstCartTime.timeIntervalSinceNow.rounded()
        let deltaBetweenPairs = (lastChoiceSecondCartTime.timeIntervalSinceNow - deltaBetweenCardsInPair).rounded()
        let factorBetweenCardsInPair = Int(deltaBetweenCardsInPair * deltaBetweenCardsInPair)
        let factorBetweenPairs = 2 * Int(deltaBetweenPairs * deltaBetweenPairs)
        
        if isMatching {
            score += max((maxScorePerMatch - factorBetweenCardsInPair - factorBetweenPairs), 1)
        } else {
            score -= max(min((factorBetweenCardsInPair + factorBetweenPairs), maxPenalizingPerMismatch), 1)
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
