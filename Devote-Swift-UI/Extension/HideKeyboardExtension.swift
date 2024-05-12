//
//  HideKeyboardExtension.swift
//  Devote-Swift-UI
//
//  Created by Haziq Abdullah on 06/05/2024.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
