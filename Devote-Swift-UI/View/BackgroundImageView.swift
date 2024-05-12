//
//  BackgroundImageView.swift
//  Devote-Swift-UI
//
//  Created by Haziq Abdullah on 06/05/2024.
//

import SwiftUI

struct BackgroundImageView: View {
    // MARK: - BODY
    
    var body: some View {
        Image("rocket")
            .antialiased(true)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea(.all)
    }
}

// MARK: - PREVIEW

#Preview {
    BackgroundImageView()
}
