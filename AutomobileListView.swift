//
//  AutomobileListView.swift
//  ProfitCars
//
//  Created by Анастасия Исакова on 18.06.2023.
//

import Foundation
import SwiftUI
import CoreData

struct AutomobileListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Automobile.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Automobile.brand, ascending: true)])
    
    var automobiles: FetchedResults<Automobile>
    
    var body: some View {
            NavigationView {
                List {
                    ForEach(automobiles, id: \.self) { automobile in
                        NavigationLink(destination: EditAutomobileView(automobile: automobile)) {
                            AutomobileRowView(automobile: automobile)
                        }
                    }
                    .onDelete(perform: deleteAutomobile)
                }
            .navigationBarTitle(Text("Мои автомобили"))
            .navigationBarItems(trailing:
                                    NavigationLink(destination: AddAutomobileView()) {
                                        Image(systemName: "plus.circle")
                                            .imageScale(.large)
                                    }
            )
        }
    }
    
    private func deleteAutomobile(at indexSet: IndexSet) {
        for index in indexSet {
            let automobile = automobiles[index]
            managedObjectContext.delete(automobile)
        }
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
}
