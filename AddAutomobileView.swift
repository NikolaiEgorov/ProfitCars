//
//  AddAutomobileView.swift
//  ProfitCars
//
//  Created by Анастасия Исакова on 18.06.2023.
//

import Foundation
import SwiftUI
import CoreData
import Firebase

struct AddAutomobileView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var automobileViewModel: AutomobileViewModel
    
    @State private var type = ""
    @State private var brand = ""
    @State private var model = ""
    @State private var year = 2022
    @State private var cost = 0.0
    @State private var expenses = 0.0
    @State private var photos = [UIImage]()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Основные данные")) {
                    TextField("Тип", text: $type)
                    TextField("Марка", text: $brand)
                    TextField("Модель", text: $model)
                    DatePicker("Год выпуска", selection: $year, displayedComponents: .date)
                }
                Section(header: Text("Финансы")) {
                    TextField("Цена", value: $cost, formatter: NumberFormatter.currency)
                    TextField("Расходы", value: $expenses, formatter: NumberFormatter.currency)
                }
                
                Section(header: Text("Фото")) {
                    ImagePicker(images: $photos)
                }
            }
            .navigationBarTitle(Text("Добавить автомобиль"))
            .navigationBarItems(trailing:
                                    Button(action: saveAutomobile) {
                Text("Сохранить")
            }
                .disabled(type.isEmpty || brand.isEmpty || model.isEmpty)
            )
        }
        .onDisappear(perform: backupData)
    }
    
    
    private func saveAutomobile() {
        
        let newAutomobile = Automobile(context: managedObjectContext)
        newAutomobile.type = type
        newAutomobile.brand = brand
        newAutomobile.model = model
        newAutomobile.year = Int16(DateComponents(calendar: Calendar.current, year: year).date?.timeIntervalSince1970 ?? 0)
        newAutomobile.cost = cost
        newAutomobile.expenses = expenses
        newAutomobile.photos = photos.count > 0 ? photos as NSObject : nil
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
        let user = Auth.auth().currentUser
        
        guard let userID = user?.uid else { return }
        
        db.collection("users").document(userID).collection("automobiles").addDocument(data: [
            "type": type,
            "brand": brand,
            "model": model,
            "year": year,
            "cost": cost,
            "expenses": expenses
        ]) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Data saved successfully!")
            }
            
            automobileViewModel.fetchData()
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func backupData() {
        let user = Auth.auth().currentUser
        
        guard let userID = user?.uid else { return }
        
        db.collection("users").document(userID).setData(["automobiles": automobile.map { automobile -> [String: Any] in
            return [
                "type": automobile.type,
                "brand": automobile.brand,
                "model": automobile.model,
                "year": Int(automobile.year),
                "cost": automobile.cost,
                "expenses": automobile.expenses
            ]
        }]) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Data backed up successfully!")
            }
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

extension NumberFormatter {
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }
}
