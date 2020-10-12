//
//  ViewController.swift
//  DeepPanelSample
//
//  Created by Pedro Gómez on 09/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

import UIKit
import Stevia

class ViewController: UIViewController {
    
    private let originalImage = UIImageView()
    private let mask = UIImageView()
    private let panelsInfo = UIImageView()
    
    var currentPage = 0
    var size = Pages.images.count

    override func viewDidLoad() {
        super.viewDidLoad()
        let deepPanel = DeepPanel()
        adjustConstrains()
        showPredictionForPage(deepPanel, Pages.images[currentPage % size])
    }
    
    private func adjustConstrains() {
        view.sv(originalImage, mask, panelsInfo)
        originalImage.contentMode = .scaleAspectFit
        originalImage.Top == view.safeAreaLayoutGuide.Top
        originalImage.centerHorizontally()
        originalImage.height(32%)
        mask.contentMode = .scaleAspectFit
        mask.Top == originalImage.Bottom
        mask.centerHorizontally()
        mask.height(32%)
        panelsInfo.contentMode = .scaleAspectFit
        panelsInfo.Top == mask.Bottom
        panelsInfo.centerHorizontally()
        panelsInfo.height(32%)
    }
    
    private func showPredictionForPage(_ deepPanel: DeepPanel,_ page: String) {
        let page = UIImage(named: "sample_page_0")!
        let result = deepPanel.extractDetailedPanelsInfo(from: page)
        originalImage.image = result.inputImage
        mask.image = result.labeledAreasImage
        panelsInfo.image = result.panelsImage
    }


}

