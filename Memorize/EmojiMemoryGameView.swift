//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Mark Sartakov on 08.10.2020.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var emojiMemoryGame: EmojiMemoryGame
    
    var body: some View {
        VStack {
            HStack{
                Button(action: emojiMemoryGame.startNewGame) {
                    Image(systemName: emojiMemoryGame.newGameSystemImageName)
                        .frame(width: iconSize.width, height: iconSize.height, alignment: .center)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke())
                        .foregroundColor(colorScheme == .dark ? .white : .blue)
                }
                Text("Score: \(emojiMemoryGame.score)").font(.title2).padding(.leading)
                Text(emojiMemoryGame.name).font(.title).padding(.leading)
                Spacer()
            }
            Grid(emojiMemoryGame.cards) { card in
                CardView(card: card, colors: emojiMemoryGame.colors).onTapGesture {
                    emojiMemoryGame.choose(card: card)
                }
                .padding(5)
            }
        }
        .padding()
    }
    
    // MARK: Drawing Constants
    
    let iconSize: CGSize = CGSize(width: 19.0, height: 19.0)
    let cornerRadius: CGFloat = 10.0
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var colors: Array<Color>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                    Text(card.content)
                } else {
                    if !card.isMatched {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
                    }
                }
            }
            .font(.system(size: fontSize(for: geometry.size)))
            .foregroundColor(colors.first ?? .clear)
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
