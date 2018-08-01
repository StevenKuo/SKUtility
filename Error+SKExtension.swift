//
//  Error+SKExtension.swift
//  TestSwift
//
//  Created by 郭俊霖 on 2018/8/1.
//  Copyright © 2018年 SK. All rights reserved.
//

import Foundation

protocol SKErrorProtocol: Error {
    var domain: String {get set}
    var code: Int {get set}
    var description: String {get set}
}

struct SKError: SKErrorProtocol {
    var domain: String
    var code: Int
    var description: String
}

extension Error {
    var domain: String {return (self as NSError).domain}
    var code: Int {return (self as NSError).code}
    var description: String {return (self as NSError).localizedDescription}
}
