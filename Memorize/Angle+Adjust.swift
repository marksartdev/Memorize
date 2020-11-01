//
//  Angle+Adjust.swift
//  Memorize
//
//  Created by Mark Sartakov on 01.11.2020.
//

import SwiftUI

extension Angle {
    func adjust() -> Angle {
        Angle.degrees(self.degrees - 90)
    }
}
