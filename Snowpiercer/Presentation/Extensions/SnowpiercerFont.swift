//
//  SnowpiercerFont.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 23/05/25.
//

import SwiftUI

struct SnowpiercerFont {
    static func heading(_ size: CGFloat = 24) -> Font {
        .system(size: size, weight: .bold, design: .default)
    }

    static func body(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }

    static func caption(_ size: CGFloat = 14) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }
}
