//
//  Convenience.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 21/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

public func mainThread(_ executable: @escaping () -> Void) {
    DispatchQueue.main.async(execute: executable)
}

public func backgroundThread(qos: DispatchQoS.QoSClass = .default, _ executable: @escaping () -> Void) {
    DispatchQueue.global(qos: qos).async(execute: executable)
}
