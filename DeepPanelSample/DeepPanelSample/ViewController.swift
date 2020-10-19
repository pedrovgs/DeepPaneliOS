//
//  ViewController.swift
//  DeepPanelSample
//
//  Created by Pedro Gómez on 09/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

import UIKit
import Stevia
import DeepPanel

class ViewController: UIViewController {
    
    private let originalImage = UIImageView()
    private let mask = UIImageView()
    private let panelsInfo = UIImageView()
    private let nextButton = UIButton()
    private let detailButton = UIButton()
    
    var currentPrediction: DetailedPredictionResult?
    var currentPage = 0
    var size = Pages.images.count

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DeepPanel"
        adjustConstrains()
        attachGestureRecognizers()
        showPredictionForPage(Pages.images[currentPage % size])
    }
    
    private func adjustConstrains() {
        view.sv(originalImage, mask, panelsInfo, nextButton, detailButton)
        originalImage.contentMode = .scaleAspectFit
        originalImage.Top == view.safeAreaLayoutGuide.Top
        originalImage.centerHorizontally()
        originalImage.height(30%)
        mask.contentMode = .scaleAspectFit
        mask.Top == originalImage.Bottom
        mask.centerHorizontally()
        mask.height(30%)
        panelsInfo.contentMode = .scaleAspectFit
        panelsInfo.Top == mask.Bottom
        panelsInfo.centerHorizontally()
        panelsInfo.height(30%)
        nextButton.text("Next")
        nextButton.backgroundColor = UIColor.black
        detailButton.text("Detail")
        detailButton.backgroundColor = UIColor.black
        nextButton.Bottom == view.safeAreaLayoutGuide.Bottom - 16
        nextButton.Right == view.safeAreaLayoutGuide.Right - 16
        detailButton.Bottom == view.safeAreaLayoutGuide.Bottom - 16
        detailButton.Left == view.safeAreaLayoutGuide.Left + 16
    }
    
    private func attachGestureRecognizers() {
        nextButton.isUserInteractionEnabled = true
        nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showNextPage)))
        detailButton.isUserInteractionEnabled = true
        detailButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDetailScreen)))
        originalImage.isUserInteractionEnabled = true
        originalImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openOriginalFullImage)))
        mask.isUserInteractionEnabled = true
        mask.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openMaskFullImage)))
        panelsInfo.isUserInteractionEnabled = true
        panelsInfo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPanelsInfoFullImage)))
    }
    
    @objc
    private func showNextPage() {
        currentPage+=1
        showPredictionForPage(Pages.images[currentPage % size])
    }
    
    private func showPredictionForPage(_ page: String) {
        let deepPanel = DeepPanel()
        let page = UIImage(named: page)!
        let result = measureExecutionTime { deepPanel.extractDetailedPanelsInfo(from: page) }
        Toast.show(message: "Page analyzed in \(result.0) ms", controller: self)
        originalImage.image = result.1.inputImage
        mask.image = result.1.labeledAreasImage
        panelsInfo.image = result.1.panelsImage
        currentPrediction = result.1
    }
    
    @objc
    private func openOriginalFullImage() {
        if let prediction = currentPrediction {
            let vc = FullScreenImageViewController()
            vc.image = prediction.inputImage
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    private func openMaskFullImage() {
        if let prediction = currentPrediction {
            let vc = FullScreenImageViewController()
            vc.image = prediction.labeledAreasImage
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    private func openPanelsInfoFullImage() {
        if let prediction = currentPrediction {
            let vc = FullScreenImageViewController()
            vc.image = prediction.panelsImage
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    private func showDetailScreen() {
        let vc = ExtractPanelsViewController()
        vc.page = originalImage.image
        vc.panelsInfoImage = panelsInfo.image
        navigationController?.pushViewController(vc, animated: true)
    }

}
