//
//  ImageLoader.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 08/04/2022.
//

import UIKit
import os.log

actor ImageLoader {
    enum ImageError: Error {
        case invalidData
        case invalidUrl
    }
    
    private static var cache: [URL: Status] = [:]
    
    private enum Status {
        case inProgress(Task<UIImage, Error>)
        case ready(UIImage)
    }
    
    static func image(from url: URL) async throws -> UIImage {
        if let status = cache[url] {
            switch status {
            case .inProgress(let task):
                Logger.ui.debug("inProgress Cache")
                return try await task.value
            case .ready(let image):
                Logger.ui.debug("Using cache")
                return image
            }
        }
        
        let task = Task {
            try await downloadImage(from: url)
        }
            
        cache[url] = .inProgress(task)
        
        do {
            let image = try await task.value
            cache[url] = .ready(image)
            return image
        } catch {
            cache[url] = nil
            throw error
        }
    }
    
    private static func downloadImage(from url: URL) async throws -> UIImage {
        Logger.ui.debug("Downloading image for \(url)")
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data), (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ImageError.invalidData
        }
        Logger.ui.debug("Download completed for \(url)")
        return image
    }
}
