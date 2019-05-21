//
//  Cat.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 21/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

typealias Cats = [Cat]

struct Cat: Decodable {
    let id: String
    let url: String
}
