//
//  Login.swift
//  ProfitCars
//
//  Created by Анастасия Исакова on 18.06.2023.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.all, 10)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.all, 10)
                
                Button(action: login) {
                    Text("Войти")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }.padding(.top, 30)
                
                NavigationLink(destination: RegisterView()) {
                    Text("Зарегистрироваться")
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                        .padding(10)
                }.padding(.top, 10)
            }
            .navigationTitle("Вход")
        }
    }
    
    func login() {
        // Реализация входа пользователя
    }
}
