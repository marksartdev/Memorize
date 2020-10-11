//
//  ContentView.swift
//  Memorize
//
//  Created by Mark Sartakov on 08.10.2020.
//

import SwiftUI

struct ContentView: View {
    var emojiMemoryGame: EmojiMemoryGame
    var body: some View {
        HStack {
            ForEach(emojiMemoryGame.cards) { card in
                CardView(card: card)
                    .aspectRatio(CGSize(width: 2, height: 3), contentMode: .fit)
                    .onTapGesture {
                        emojiMemoryGame.choose(card: card)
                    }
            }
        }
        .padding()
        .foregroundColor(.orange)
        .font(emojiMemoryGame.cards.count == 10 ? .headline : .largeTitle)
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var body: some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                Text(card.content)
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(emojiMemoryGame: EmojiMemoryGame())
    }
}
