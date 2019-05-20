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
