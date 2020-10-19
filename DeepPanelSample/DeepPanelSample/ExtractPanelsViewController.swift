//
//  ExtractPanelsViewController.swift
//  DeepPanelSample
//
//  Created by Pedro Gómez on 12/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

import Foundation
import UIKit
import Stevia
import DeepPanel

class ExtractPanelsViewController: UIViewController {
    
    var page: UIImage?
    var panelsInfoImage: UIImage?
    
    private let panelsInfo = UIImageView()
    private let panelsDetailedInfo = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        adjustConstrains()
        attachGestureRecognizers()
        showPredictionForPage()
    }
    
    private func adjustConstrains() {
        view.sv(panelsInfo, panelsDetailedInfo)
        panelsInfo.contentMode = .scaleAspectFit
        panelsInfo.Top == view.safeAreaLayoutGuide.Top
        panelsInfo.centerHorizontally()
        panelsInfo.height(40%)
        panelsDetailedInfo.fillHorizontally().Top == panelsInfo.Bottom
        panelsDetailedInfo.Bottom == view.safeAreaLayoutGuide.Bottom
    }
    
    private func attachGestureRecognizers() {
        panelsInfo.isUserInteractionEnabled = true
        panelsInfo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openDetailPanelInfo)))
    }
    
    private func showPredictionForPage() {
        guard let page = page else {
            return
        }
        let deepPanel = DeepPanel()
        let result = measureExecutionTime { deepPanel.extractPanelsInfo(from: page) }
        Toast.show(message: "Page analyzed in \(result.0) ms", controller: self)
        panelsInfo.image = panelsInfoImage
        panelsDetailedInfo.textColor = UIColor.black
        let panels = result.1.panels.panelsInfo
        let numberOfPanels = panels.count
        let infoPerPanel = panels.map { panel in
            "----\n\nLeft: \(panel.left), Top: \(panel.top)\n|Right: \(panel.right), Bottom: \(panel.bottom)\n|Width: \(panel.width), Height: \(panel.height)\n"
        }.joined()
        panelsDetailedInfo.text = "Number of panels found: \(numberOfPanels) in \(result.0) ms:\n\n\(infoPerPanel)"
    }
    
    @objc
    private func openDetailPanelInfo() {
        if let image = panelsInfo.image {
            let vc = FullScreenImageViewController()
            vc.image = image
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
