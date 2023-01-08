//
//  UIImage+save.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 04.01.2023.
//

import UIKit

extension UIImage {

    func save(
        at directory: FileManager.SearchPathDirectory,
        pathAndImageName: String,
        createSubdirectoriesIfNeed: Bool = true,
        compressionQuality: CGFloat = 1.0
    ) throws -> URL? {
        let documentsDirectory = try FileManager.default.url(
            for: directory, in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        
        return try save(
            at: documentsDirectory.appendingPathComponent(pathAndImageName),
            createSubdirectoriesIfNeed: createSubdirectoriesIfNeed,
            compressionQuality: compressionQuality
        )
    }

    func save(
        at url: URL,
        createSubdirectoriesIfNeed: Bool = true,
        compressionQuality: CGFloat = 1.0
    ) throws -> URL? {
        if createSubdirectoriesIfNeed {
            try FileManager.default.createDirectory(
                at: url.deletingLastPathComponent(),
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        
        guard let data = jpegData(compressionQuality: compressionQuality) else { return nil }
        try data.write(to: url)
        return url
    }
}

extension UIImage {
    convenience init?(fileURLWithPath url: URL, scale: CGFloat = 1.0) {
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data, scale: scale)
        } catch {
            print("-- Error: \(error)")
            return nil
        }
    }
}
