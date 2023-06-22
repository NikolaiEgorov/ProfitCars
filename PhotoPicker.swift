//
//  PhotoPicker.swift
//  ProfitCars
//
//  Created by Анастасия Исакова on 18.06.2023.
//

import Foundation
import SwiftUI
import UIKit
 
struct PhotoPicker: UIViewControllerRepresentable {
    
    // Функция для отображения представления выбора фотографии
    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator // делегировать события контроллеру координатора
        picker.sourceType = .photoLibrary
        return picker
    }
    
    // Функция для скрытия контроллера выбора фотографии после выбора
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<PhotoPicker>) {
        
    }
    
    // Функция связывания объекта Coordinator с View
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        // Функция, вызываемая при выборе фото
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let pickedImage = info[.originalImage] as? UIImage {
                parent.photos.append(pickedImage)
            }
            
            // Закрыть окно выбора фотографий после выбора
            picker.dismiss(animated: true)
        }
        
        // Функция, вызываемая при отмене выбора фото
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // Закрыть окно выбора фотографий при отмене
            picker.dismiss(animated: true)
        }
    }
    
    @Binding var photos: [UIImage]
    
    typealias UIViewControllerType = UIImagePickerController
}
