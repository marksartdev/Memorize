//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Mark Sartakov on 08.10.2020.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var emojiMemoryGame: EmojiMemoryGame
    var body: some View {
        Grid(emojiMemoryGame.cards) { card in
            CardView(card: card).onTapGesture {
                emojiMemoryGame.choose(card: card)
            }
            .padding(5)
        }
        .foregroundColor(.orange)
        .padding()
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                    Text(card.content)
                } else {
                    if !card.isMatched {
                        RoundedRectangle(cornerRadius: cornerRadius).fill()
                    }
                }
            }
            .font(.system(size: fontSize(for: geometry.size)))
        }
        .aspectRatio(aspectRatioSize, contentMode: .fit)
    }
    // MARK: Drawing Constants
    
    let cornerRadius: CGFloat = 10.0
    let aspectRatioSize: CGSize = CGSize(width: 2, height: 3)
    let edgeLineWidth: CGFloat = 3
    
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(emojiMemoryGame: EmojiMemoryGame())
    }
}
