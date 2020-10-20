//
//  Grid.swift
//  Memorize
//
//  Created by Mark Sartakov on 17.10.2020.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    var items: Array<Item>
    var viewForItem: (Item) -> ItemView
    
    init(_ items: Array<Item>, viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            let layout = GridLayout(itemCount: items.count, in: geometry.size)
            
            ForEach(items) { item in
                let index = items.firstIndex(matching: item)!
                viewForItem(item)
                    .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                    .position(layout.location(ofItemAt: index))
            }
        }
    }
}
