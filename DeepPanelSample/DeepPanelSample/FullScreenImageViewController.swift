//
//  FullScreenImageViewController.swift
//  DeepPanelSample
//
//  Created by Pedro Gómez on 12/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

import Foundation
import UIKit
import Stevia


class FullScreenImageViewController: UIViewController {
    
    var image: UIImage?
    
    private var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        adjustConstraints()
        if let image = image {
            imageView.image = image
        }
    }
    
    private func adjustConstraints() {
        view.sv(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.fillContainer()
    }
    
}
