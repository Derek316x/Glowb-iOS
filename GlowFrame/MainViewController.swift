//
//  MainViewController.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/7/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDelegate,
    UIViewControllerPreviewingDelegate,
    UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var relationships: [Relationship] = {
        return [
          Relationship(image: UIImage(named: "meagan")!, device: Device(deviceID: "53ff6d066667574818431267"))
        ]
    }()
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        registerForPreviewingWithDelegate(self, sourceView: collectionView)
    }
    
    
    // MARK: - Collection view data source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relationships.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCollectionViewCellIdentifier", forIndexPath: indexPath) as? ImageViewCollectionViewCell {
            
            cell.imageView.image = relationships[indexPath.row].image
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    // MARK: - Collection view flow layout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height)
    }
    
    
    // MARK: - Previewing context delegate
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let _ = collectionView.indexPathsForSelectedItems(),
            indexPath = collectionView.indexPathForItemAtPoint(location),
            cell = collectionView.cellForItemAtIndexPath(indexPath)
        {
            previewingContext.sourceRect = cell.frame
            let viewController = HeartViewController(nibName: HeartViewController.nibName(), bundle: nil)
            viewController.preferredContentSize = CGSize(width: view.frame.size.width - 30, height: view.frame.size.width - 30)
            
            GlowAPIManager.glowForRelationship(relationships[indexPath.row])
            return viewController
        }
        
        return nil
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
    }
    
    // MARK: - Utility
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}