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
                Button(action: {
                    withAnimation(Animation.easeInOut) {
                        emojiMemoryGame.resetGame()
                    }
                }) {
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
                    withAnimation(Animation.linear(duration: cardRotationDuration)) {
                        emojiMemoryGame.choose(card: card)
                    }
                }
                .padding(5)
            }
            Text("Score: \(emojiMemoryGame.score)")
                .font(.title2)
                .foregroundColor(colorScheme == .dark ? .green : .blue)
        }
        .padding()
    }
    
    // MARK: Drawing Constants
    
    private let cardRotationDuration: Double = 0.75
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var colors: Array<Color>
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        
        withAnimation(Animation.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
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
                Group {
                    if card.isConsumingBonusTime {
                        Pie(
                            startAngle: Angle.degrees(0).adjust(),
                            endAngle: Angle.degrees(-animatedBonusRemaining * 360).adjust(),
                            clockwise: true
                        )
                        .onAppear(perform: startBonusTimeAnimation)
                    } else {
                        Pie(
                            startAngle: Angle.degrees(0).adjust(),
                            endAngle: Angle.degrees(-card.bonusRemaining * 360).adjust(),
                            clockwise: true
                        )
                    }
                }
                .padding(5).opacity(0.4)
                .transition(.identity)
                Text(card.content)
                    .font(.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(
                        card.isMatched
                            ? Animation.linear(duration: emojiRotationDuration)
                            .repeatForever(autoreverses: false)
                            : .default
                    )
            }
            .cardify(isFaceUp: card.isFaceUp, colors: colors)
            .transition(.scale)
        }
    }
    
    // MARK: Drawing Constants
    
    private let emojiRotationDuration: Double = 1
    
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
