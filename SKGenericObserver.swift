//
//  SKGenericObserver.swift
//  TestSwift
//
//  Created by 郭俊霖 on 2018/7/31.
//  Copyright © 2018年 SK. All rights reserved.
//

import Foundation

class SKGenericObserver<T> {
    typealias Listener =  (T?) -> Void
    var listener: Listener?
    var value: T? {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T?) {
        value = v
    }
    
    func bind(listener: Listener?)  {
        self.listener = listener
    }
    
    func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
