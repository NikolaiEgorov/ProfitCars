//
//  AutomobileViewModel.swift
//  ProfitCars
//
//  Created by Анастасия Исакова on 18.06.2023.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseFirestore

class AutomobileViewModel: ObservableObject {
    @Published var automobiles = Automobile().self
    
    private var db = Firestore.firestore()
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        let user = Auth.auth().currentUser
        
        guard let userID = user?.uid else { return }
        
        db.collection("users").document(userID).collection("automobiles").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.automobiles = documents.compactMap { queryDocumentSnapshot -> Automobile? in
                let data = queryDocumentSnapshot.data()
                let type = data["type"] as? String ?? ""
                let brand = data["brand"] as? String ?? ""
                let model = data["model"] as? String ?? ""
                let year = data["year"] as? Int16 ?? 0
                let cost = data["cost"] as? Double ?? 0.0
                let expenses = data["expenses"] as? Double ?? 0.0
                
                return Automobile(type: type, brand: brand, model: model, year: year, cost: cost, expenses: expenses)
            }
        }
    }
}

