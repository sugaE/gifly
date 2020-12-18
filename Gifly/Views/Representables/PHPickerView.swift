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
    @Binding var image: [UIImage]
    @Binding var isFinished: Bool
    
//    let filter: PHPickerFilter
        
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configration = PHPickerConfiguration(photoLibrary: .shared())
//        configration.filter = filter
//        configration.selectionLimit = 100
//        configration.filter = .any(of: [.livePhotos, .videos])
        configration.filter = .videos
        
        
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
            
//            if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: PHLivePhoto.self) {
////                let previousImage = self.phpicker.image
//                itemProvider.loadObject(ofClass: PHLivePhoto.self) { asset, error in
//                    DispatchQueue.main.async {
//                        guard let asset = asset as? PHLivePhoto
////                              , previousImage == self.phpicker.image
//                        else { return }
////                        self.phpicker.image = asset
//
//                    }
//                }
//            }
            let identifiers = results.compactMap(\.assetIdentifier)
            if identifiers.count <= 0 {
                return
            }
            
            self.phpicker.image = [UIImage]()
            self.phpicker.isFinished = false
            
            
            let fetchResults = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
            let fetchResult = fetchResults[0]
            
            let manager = PHImageManager.default()
            let options = PHVideoRequestOptions()
            options.deliveryMode = PHVideoRequestOptionsDeliveryMode.fastFormat
            options.isNetworkAccessAllowed = true
            manager.requestAVAsset(forVideo: fetchResult, options: options) { avasset, audio, other  in
//                AVAsset.
                print("voila")
                
//                let asset : AVAsset = AVAsset(URL: yourNSURLtoTheAsset )
                let imageGenerator = AVAssetImageGenerator(asset: avasset!)
                imageGenerator.appliesPreferredTrackTransform = true
                imageGenerator.requestedTimeToleranceBefore = CMTime.zero
                imageGenerator.requestedTimeToleranceAfter = CMTime.zero
//                let time = CMTimeMakeWithSeconds(0.5, preferredTimescale: 1000)
//                var actualTime = CMTime.zero
                var times = [NSValue]()
                 
                for i in 0..<Int(fetchResult.duration * FRAME_COUNT) {
                    let timetmp = CMTimeMake(value: Int64(i), timescale: Int32(FRAME_COUNT))
                    times.append(NSValue(time: timetmp))
                    
//                    do {
//                        var outTime = UnsafeMutablePointer<CMTime>.allocate(capacity: 32)
//                        let cgImage = try imageGenerator.copyCGImage(at: timetmp, actualTime: outTime)
//                        self.phpicker.image.append(UIImage(cgImage: cgImage))
//                        print("req:\(timetmp.seconds) get: \(outTime.pointee.seconds)")
//                    }
//                    catch let error as NSError {
//                        print(error.localizedDescription)
//                    }
                }
                var timeslen = times.count
                 
//                do {
                imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { (cmtime1, cgImage, cmtime2, result, error) in
                    if let error = error {
                        print("[ERR] generateCGImagesAsynchronously: \(error)")
                        timeslen -= 1
                    }
                    print("[INFO] image \(self.phpicker.image.count): req:\(cmtime1.seconds) get: \(cmtime2.seconds)")
                    guard let cgImage = cgImage, result == AVAssetImageGenerator.Result.succeeded else { return }
                    self.phpicker.image.append(UIImage(cgImage: cgImage))

                    if timeslen == self.phpicker.image.count {
                        self.phpicker.isFinished = true // todo
                    }
                })
//                }
//                catch let error as NSError {
//                    print(error.localizedDescription)
//                }
            }
        }
        
        
    }
 
}
