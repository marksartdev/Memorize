//
//  Cardify.swift
//  Memorize
//
//  Created by Mark Sartakov on 27.10.2020.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    var colors: Array<Color>
    
    func body(content: Content) -> some View {
        ZStack {
            if isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
            }
        }
    }
    
    // MARK: Drawing Constants
    
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3
}

extension View {
    func cardify(isFaceUp: Bool, colors: Array<Color>) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, colors: colors))
    }
}
