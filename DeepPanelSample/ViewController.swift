//
//  ViewController.swift
//  DeepPanelSample
//
//  Created by Pedro Gómez on 09/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let deepPanel = DeepPanel()
        let page = UIImage(named: "sample_page_0")!
        deepPanel.extractPanelsInfo(from: page)
    }


}

