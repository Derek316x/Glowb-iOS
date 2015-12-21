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
          Relationship(image: UIImage(named: "meagan")!, device: Device(deviceID: "53ff6d066667574818431267")),
          Relationship(image: UIImage(named: "hannah")!, device: Device(deviceID: "300035000547343232363230"))
        ]
    }()
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        registerForPreviewingWithDelegate(self, sourceView: collectionView)
    }
    
    
    // MARK: - Setup
    
    private func setup() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(NewRelationshipCollectionViewCell.Nib, forCellWithReuseIdentifier: NewRelationshipCollectionViewCell.CellIdentifier)
        collectionView.registerNib(RelationshipCollectionViewCell.Nib, forCellWithReuseIdentifier: RelationshipCollectionViewCell.CellIdentifier)
    }
    
    
    // MARK: - Collection view data source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relationships.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == relationships.count {
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NewRelationshipCollectionViewCell.CellIdentifier, forIndexPath: indexPath) as? NewRelationshipCollectionViewCell {
                
                cell.newItemButtonTappedHandler = { [unowned self] in
                    self.displayNewRelationship()
                }
                
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(RelationshipCollectionViewCell.CellIdentifier, forIndexPath: indexPath) as? RelationshipCollectionViewCell {
                
                let relationship = relationships[indexPath.row]
                cell.relationship = relationship
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    
    // MARK: - 
    
    private func displayNewRelationship() {
        let viewController = NewRelationshipViewController(nibName: NewRelationshipViewController.NibName, bundle: nil)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    
    // MARK: - Collection view flow layout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? RelationshipCollectionViewCell {
            cell.eagerLoad()
        }
    }
    
    
    // MARK: - Previewing context delegate
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let _ = collectionView.indexPathsForSelectedItems(),
            indexPath = collectionView.indexPathForItemAtPoint(location),
            cell = collectionView.cellForItemAtIndexPath(indexPath) else {
                return nil
        }
        
        guard indexPath.row != relationships.count else { return nil }
        
        previewingContext.sourceRect = cell.frame
        let viewController = HeartViewController(nibName: HeartViewController.nibName(), bundle: nil)
        viewController.preferredContentSize = CGSize(width: view.frame.size.width - 30, height: view.frame.size.width - 30)
        
        GlowAPIManager.glowForRelationship(relationships[indexPath.row])
        
        return viewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
    }
    
    // MARK: - Scroll view delegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if let cells = collectionView.visibleCells() as? [RelationshipCollectionViewCell] {
            for cell in cells {
                cell.resetScroll()
            }
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == collectionView && scrollView.contentOffset.x < -80 {
            performSegueWithIdentifier("SettingsSegueIdentifier", sender: self)
        }
    }
    
    // MARK: - Utility
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}