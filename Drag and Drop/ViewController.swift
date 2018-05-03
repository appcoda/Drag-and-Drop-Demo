//
//  ViewController.swift
//  Drag and Drop
//
//  Created by Sai Kambampati on 2/17/18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIDropInteractionDelegate, UIDragInteractionDelegate {
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addInteraction(UIDropInteraction(delegate: self))
        view.addInteraction(UIDragInteraction(delegate: self))
        firstImageView.isUserInteractionEnabled = true
        secondImageView.isUserInteractionEnabled = true
    }
    
    // Drop Interaction
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        // 1
        for dragItem in session.items {
            // 2
            dragItem.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { object, error in
                // 3
                guard error == nil else { return print("Failed to load our dragged item") }
                guard let draggedImage = object as? UIImage else { return }
                // 4
                DispatchQueue.main.async {
                    let centerPoint = session.location(in: self.view)
                    if session.location(in: self.view).y <= self.firstImageView.frame.maxY {
                        self.firstImageView.image = draggedImage
                        self.firstImageView.center = centerPoint
                    } else {
                        self.secondImageView.image = draggedImage
                        self.secondImageView.center = centerPoint
                    }
                }
            })
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    // Drag Interaction
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let centerPoint = session.location(in: self.view)
        if session.location(in: self.view).y <= self.firstImageView.frame.maxY {
            guard let image = firstImageView.image else { return [] }
            let provider = NSItemProvider(object: image)
            let item = UIDragItem(itemProvider: provider)
            self.firstImageView.center = centerPoint
            return [item]
        } else {
            guard let image = secondImageView.image else { return [] }
            let provider = NSItemProvider(object: image)
            let item = UIDragItem(itemProvider: provider)
            self.secondImageView.center = centerPoint
            return [item]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

