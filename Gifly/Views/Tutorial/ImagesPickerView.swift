/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that wraps a UIPageViewController.
*/

import SwiftUI
import UIKit
import PhotosUI

struct PHPickerView2: UIViewControllerRepresentable {
//    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    
//    let filter: PHPickerFilter
        
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configration = PHPickerConfiguration(photoLibrary: .shared())
//        configration.filter = filter
//        configration.selectionLimit = 100
//        configration.filter = .any(of: [.livePhotos, .videos])
        configration.filter = .livePhotos
        
        
        let imagePicker = PHPickerViewController(configuration: configration)
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }

//    acts as a bridge between the UIKit and SwiftUI.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
   
        var phpicker: PHPickerView2
        
        init(_ phpicker: PHPickerView2) {
            self.phpicker = phpicker
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            picker.dismiss(animated: true)
            
            if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
//                let previousImage = self.phpicker.image
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        guard let image = image as? UIImage
//                              , previousImage == self.phpicker.image
                        else { return }
                        self.phpicker.image = image
                        self.phpicker.isPresented = false
                         
                    }
                }
            }
        }
        
        
    }
 
}
