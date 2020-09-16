//
//  UIImageView.swift
//  MovieDB
//
//  Created by Ermac on 9/14/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView {
    func setImage(with url: URL) {
        self.sd_setImage(with: url, completed: nil)
    }
}
