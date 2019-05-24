//
//  Extensions.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 20/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

extension UIStoryboard {
    func instantiateViewController<Controller>(_ controllerType: Controller.Type) -> Controller {
        return instantiateViewController(withIdentifier: String(describing: controllerType)) as! Controller
    }
}

extension UICollectionView {
    func dequeueReusableCell<Cell>(_ cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withReuseIdentifier: String(describing: cellType), for: indexPath) as! Cell
    }
}

extension UIImage {
    convenience init?(url: String?) {
        guard let string = url, let url = URL(string: string), let data = try? Data(contentsOf: url) else {
            return nil
        }

        self.init(data: data)
    }
}

extension NSCache where KeyType == NSString, ObjectType == NSData {
    func set(_ data: NSData, forKey key: String) {
        setObject(data, forKey: NSString(string: key))
    }

    func get(forKey key: String) -> NSData? {
        return object(forKey: NSString(string: key))
    }

    func clear() {
        removeAllObjects()
    }
}
}
