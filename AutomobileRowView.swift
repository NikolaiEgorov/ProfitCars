//
//  AutomobileRowView.swift
//  ProfitCars
//
//  Created by Анастасия Исакова on 18.06.2023.
//

import Foundation
import SwiftUI

struct AutomobileRowView: View {
    let automobile: Automobile
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(automobile.brand) \(automobile.model)")
                .font(.headline)
            HStack {
                Text(automobile.type)
                Spacer()
                Text("\(automobile.year)")
            }
        }
    }
}
