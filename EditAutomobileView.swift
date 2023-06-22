//
//  EditAutomobileView.swift
//  ProfitCars
//
//  Created by Анастасия Исакова on 18.06.2023.
//

import Foundation
import SwiftUI

struct EditAutomobileView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @ObservedObject private var automobile: Automobile
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var type = ""
    @State private var brand = ""
    @State private var model = ""
    @State private var year = 2022
    @State private var cost = 0.0
    @State private var expenses = 0.0
    @State private var photos = [UIImage]()
    
    init(automobile: Automobile) {
        self.automobile = automobile
        _type = State(wrappedValue: automobile.type)
        _brand = State(wrappedValue: automobile.brand)
        _model = State(wrappedValue: automobile.model)
        _year = State(wrappedValue: Calendar.current.component(.year, from: Date(timeIntervalSince1970: TimeInterval(automobile.year))))
        _cost = State(wrappedValue: automobile.cost)
        _expenses = State(wrappedValue: automobile.expenses)
        _photos = State(wrappedValue: automobile.photos as? [UIImage] ?? [])
    }
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Основная информация")) {
                    TextField("Тип", text: $type)
                    TextField("Марка", text: $brand)
                    TextField("Модель", text: $model)
                    Picker(selection: $year, label: Text("Год выпуска")) {
                        ForEach(1950...2022, id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }
                }
                
                Section(header: Text("Стоимость и расходы")) {
                    HStack {
                        Text("Стоимость")
                        Spacer()
                        TextField("\(automobile.cost.formattedCurrencySymbol)", value: $cost, formatter: numberFormatter)
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Text("Расходы")
                        Spacer()
                        TextField("\(automobile.expenses.formattedCurrencySymbol)", value: $expenses, formatter: numberFormatter)
                            .keyboardType(.decimalPad)
                    }
                }
                
                Section(header: Text("Фотографии")) {
                    PhotoPicker(photos: $photos)
                }
                .disabled(!UIImagePickerController.isSourceTypeAvailable(.photoLibrary))
            }
            .navigationBarTitle(Text("Изменить автомобиль"))
            .navigationBarItems(trailing:
                                    Button(action: saveAutomobile) {
                Text("Сохранить")
            }
                .disabled(type.isEmpty || brand.isEmpty || model.isEmpty)
            )
        }
        .onAppear {
            type = automobile.type
            brand = automobile.brand
            model = automobile.model
            year = Calendar.current.component(.year, from: Date(timeIntervalSince1970: TimeInterval(automobile.year)))
            cost = automobile.cost
            expenses = automobile.expenses
            if let photosData = automobile.photos {
                photos = photosData as! [UIImage]
            }
        }
    }
    
    private func saveAutomobile() {
        automobile.type = type
        automobile.brand = brand
        automobile.model = model
        automobile.year = Int16(DateComponents(calendar: Calendar.current, year: year).date?.timeIntervalSince1970 ?? 0)
        automobile.cost = cost
        automobile.expenses = expenses
        automobile.photos = photos.count > 0 ? photos as NSObject : nil
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func deleteAutomobile() {
        managedObjectContext.delete(automobile)
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

