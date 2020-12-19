/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that wraps a UIPageViewController.
*/

import SwiftUI
import UIKit
import PhotosUI

struct PHPickerView: UIViewControllerRepresentable {
//    @Environment(\.presentationMode) var presentationMode
    let filter: PHPickerFilter?
    @EnvironmentObject var modelData: ModelData
//    @Binding var modelData: ModelData
//    @Binding var image: [UIImage]
//    @Binding var isFinished: Bool
//    let parameters: Parameter
    
//    let filter: PHPickerFilter
        
    func makeUIViewController(context: Context) -> PHPickerViewController {
         
        var configration = PHPickerConfiguration(photoLibrary: .shared())
        configration.filter = filter
//        configration.selectionLimit = 100
//        configration.filter = .any(of: [.livePhotos, .videos])
//        configration.filter = .videos
        
        
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
   
        var phpicker: PHPickerView
        
        init(_ phpicker: PHPickerView) {
            self.phpicker = phpicker
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            picker.dismiss(animated: true)
            
            let identifiers = results.compactMap(\.assetIdentifier)
            
            if identifiers.count <= 0 || self.phpicker.modelData.isGenerating {
                return
            }
             
//            self.phpicker.modelData.frames = []
//            self.phpicker.modelData.isGenerating = true
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            if !(status == .authorized || status == .limited) {
                print("[Fail Authorization] no access to photo libarary")
                return
            }
            
            // TODO: if fails, then try itemProvider
            let fetchResults = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
            if fetchResults.count == 0 {
                print("[Fail Authorization] lack access to certain photos")
                return
            }
//            self.phpicker.modelData.phassets = fetchResults.objects(at: IndexSet(integersIn: 0..<fetchResults.count))
            let fetchResult = fetchResults[0]
//            self.phpicker.modelData.phasset = fetchResult
            
            switch fetchResult.mediaType {
            case .video:
                Helper.loadVideoIntoModel(from: fetchResult, modelData: self.phpicker.modelData)
                break
            case .image:
                if fetchResult.mediaSubtypes == .photoLive {
                    Helper.loadLivephotoIntoModel(from: fetchResult, modelData: self.phpicker.modelData)
                    return
                } else if fetchResult.mediaSubtypes.rawValue == 64 { // gif hopefully
                    Helper.loadGifIntoModel(from: fetchResult, modelData: self.phpicker.modelData)
                    return
                }
                
            default:
                print("[Warning] unsupported media type: \(fetchResult.mediaType)")
                return
            }
            
        }
        
        
    }
 
}
