//
//  SesrchView.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//

import SwiftUI

struct SearchBarView: View {
    var placeholder: String
    var onTap: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            Text(placeholder)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .onTapGesture {
            onTap()
        }
    }
}
