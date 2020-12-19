//
//  Helper.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/19.
//

import Foundation
import Photos
import MobileCoreServices

struct Helper {
    
    static func cancelGeneratingStatus(of: ModelData) {
        DispatchQueue.main.async {
            of.isGenerating = false
        }
    }
    
    
    static func fileExtension(for dataUTI: String) -> String? {
        guard let fileExtension = UTTypeCopyPreferredTagWithClass(dataUTI as CFString, kUTTagClassFilenameExtension) else {
            return nil
        }

        return String(fileExtension.takeRetainedValue())
    }
     
    
    static func generateFolderForLivePhotoResources() -> NSURL? {
        let photoDir = NSURL(
            // NB: Files in NSTemporaryDirectory() are automatically cleaned up by the OS
            fileURLWithPath: NSTemporaryDirectory(),
            isDirectory: true
            ).appendingPathComponent(NSUUID().uuidString)

        let fileManager = FileManager()
        // we need to specify type as ()? as otherwise the compiler generates a warning
        let success : ()? = try? fileManager.createDirectory(
            at: photoDir!,
            withIntermediateDirectories: true,
            attributes: nil
        )

        return success != nil ? photoDir! as NSURL : nil
    }
    
    
    static func saveAssetResource(
        resource: PHAssetResource,
        buffer: NSMutableData?,
        maybeError: Error?,
        completionHandler: @escaping (URL, Error?) -> Void
        ) -> Void {
        
        guard let inDirectory = generateFolderForLivePhotoResources() else { return }
        
        guard maybeError == nil else {
            print("Could not request data for resource: \(resource), error: \(String(describing: maybeError))")
            return
        }

        let maybeExt = fileExtension(for: resource.uniformTypeIdentifier)

        guard let ext = maybeExt else {
            return
        }

        guard var fileUrl = inDirectory.appendingPathComponent(NSUUID().uuidString) else {
            print("file url error")
            return
        }

        fileUrl = fileUrl.appendingPathExtension(ext as String)

        if let buffer = buffer, buffer.write(to: fileUrl, atomically: true) {
            print("Saved resource form buffer \(resource) to filepath: \(String(describing: fileUrl))")
            completionHandler(fileUrl, nil)
        } else {
            PHAssetResourceManager.default().writeData(for: resource, toFile: fileUrl, options: nil) { (error) in
                print("Saved resource directly \(resource) to filepath: \(String(describing: fileUrl))")
                completionHandler(fileUrl, error)
            }
        }
    }
 
}
