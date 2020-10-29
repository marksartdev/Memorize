//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Mark Sartakov on 08.10.2020.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var emojiMemoryGame: EmojiMemoryGame
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: emojiMemoryGame.resetGame) {
                    Text("New Game")
                        .foregroundColor(colorScheme == .dark ? .green : .blue)
                }
            }
            HStack {
                Text(emojiMemoryGame.name)
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            Grid(emojiMemoryGame.cards) { card in
                CardView(card: card, colors: emojiMemoryGame.colors).onTapGesture {
                    emojiMemoryGame.choose(card: card)
                }
                .padding(5)
            }
            Text("Score: \(emojiMemoryGame.score)")
                .font(.title2)
                .foregroundColor(colorScheme == .dark ? .green : .blue)
        }
        .padding()
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var colors: Array<Color>
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
                .foregroundColor(colors.first ?? .clear)
        }
    }
    
    @ViewBuilder
    func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(110-90), clockwise: true)
                    .padding(5).opacity(0.4)
                Text(card.content)
                    .font(.system(size: fontSize(for: size)))
            }
            .cardify(isFaceUp: card.isFaceUp, colors: colors)
        }
    }
    
    // MARK: Drawing Constants
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        let emojiMemoryGame = EmojiMemoryGame()
        emojiMemoryGame.choose(card: emojiMemoryGame.cards[0])
        return EmojiMemoryGameView(emojiMemoryGame: emojiMemoryGame)
    }
}
