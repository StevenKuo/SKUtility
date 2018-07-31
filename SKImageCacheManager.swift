//
//  SKImageCacheManager.swift
//  TestSwift
//
//  Created by 郭俊霖 on 2018/7/31.
//  Copyright © 2018年 SK. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func toMD5() -> String {
        if let messageData = self.data(using:String.Encoding.utf8) {
            var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
            _ = digestData.withUnsafeMutableBytes {digestBytes in
                messageData.withUnsafeBytes {messageBytes in
                    CC_MD5(messageBytes, CC_LONG((messageData.count)), digestBytes)
                }
            }
            return digestData.map{ String($0, radix:16) }.joined()
        }
        return self
    }
    
}

var imageCachePath: String {
    let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
    let cachesDirectory = path[0]
    try! FileManager.default.setAttributes([FileAttributeKey.protectionKey : FileProtectionType.none], ofItemAtPath: cachesDirectory)
    let imagePath = cachesDirectory + "/image"
    return imagePath
}

class SKImageCacheManager: NSObject, URLSessionDelegate {
    static let sharedManager = SKImageCacheManager()
    private var mainSession: URLSession!
    
    private override init () {
        super.init()
        mainSession = URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: self, delegateQueue: OperationQueue())
        
        if FileManager.default.fileExists(atPath: imageCachePath) == false {
            try! FileManager.default.createDirectory(at: URL(fileURLWithPath: imageCachePath), withIntermediateDirectories: false, attributes: nil)
        }
    }
    
    private func imageCache(url: String) -> UIImage? {
        let key = url.toMD5()
        if FileManager.default.fileExists(atPath: imageCachePath) == false {
            return nil
        }
        let filePath = imageCachePath + "/\(key)"
        guard let imageData = FileManager.default.contents(atPath: filePath) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    func fetchImage(url: String, callback: @escaping ((_: UIImage?) -> Void)) {
        if let cache = imageCache(url: url) {
            callback(cache)
            return
        }
        guard let imageURL = URL(string: url) else {
            callback(nil)
            return
        }
        let task = mainSession.dataTask(with: URLRequest(url: imageURL)) { (data, response, e) in
            if e != nil || data == nil {
                DispatchQueue.main.async {
                    callback(nil)
                }
                return
            }
            let key = url.toMD5()
            let filePath = imageCachePath + "/\(key)"
            try! data!.write(to: URL(fileURLWithPath: filePath), options: Data.WritingOptions.atomic)
            DispatchQueue.main.async {
                callback(UIImage(data: data!))
            }
            
        }
        task.resume()
    }
    
}
