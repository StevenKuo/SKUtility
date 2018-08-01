//
//  SKURLSessionManager.swift
//  TestSwift
//
//  Created by 郭俊霖 on 2018/7/31.
//  Copyright © 2018年 SK. All rights reserved.
//

import Foundation

typealias SKURLSessionManagerCallback = (_: Any?, _: Error?) -> Void

class SKURLSessionManager: NSObject,URLSessionDelegate {
    static let sharedManager = SKURLSessionManager()
    private var mainSession: URLSession!
    
    private override init () {
        super.init()
        mainSession = URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: self, delegateQueue: OperationQueue())
    }
    
    func request(urlRequest: URLRequest, callback: SKURLSessionManagerCallback?) {
        createTask(urlRequest: urlRequest, callback: callback)
    }
    
    private func createTask(urlRequest: URLRequest, callback: SKURLSessionManagerCallback?) {
        let task = mainSession.dataTask(with: urlRequest) { (data, response, e) in
            if e != nil {
                callback?(nil, e)
                return
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    callback?(json, nil)
                } catch {
                    callback?(nil, error)
                }
            }
        }
        task.resume()
    }
}
