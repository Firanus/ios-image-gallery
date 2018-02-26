//
//  DisplayGalleryCollectionViewController.swift
//  ImageGallery
//
//  Created by Ivan Tchernev on 20/02/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import UIKit

private let imageReuseIdentifier = "imageCell"
private let placeholderReuseIdentifier = "placeholderCell"

class DisplayGalleryCollectionViewController: UICollectionViewController, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    var imageGallery: ImageGallery = imageConstants.mandelbrotGallery
    
    var flowLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dragDelegate = self
        collectionView?.dropDelegate = self
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        
        let pinchGestureRecogniser = UIPinchGestureRecognizer(target: self, action: #selector(DisplayGalleryCollectionViewController.pinchGallery))
        collectionView?.addGestureRecognizer(pinchGestureRecogniser)
    }
    
    @objc func pinchGallery(recognizer: UIPinchGestureRecognizer){
        switch recognizer.state {
        case .changed:
            if let itemSize = flowLayout?.itemSize {
                let scaleFactor = recognizer.scale
                flowLayout?.itemSize = CGSize(width: itemSize.width * scaleFactor, height: itemSize.height * scaleFactor)
                flowLayout?.invalidateLayout()
            }
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        let destinationViewController = segue.destination
        switch segue.identifier {
        case "showImageSegue"?:
            if let displayImageController = destinationViewController as? DisplayImageViewController {
                if let imageCell = sender as? GalleryImageViewCell {
                    imageCell.activityIndicator.isHidden = false
                    imageCell.activityIndicator.startAnimating()
                    displayImageController.galleryImage = imageCell.galleryImage
                }
            }
        default:
            break
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageGallery.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageReuseIdentifier, for: indexPath)
        
        // Configure the cell
        if let imageCell = cell as? GalleryImageViewCell {
            imageCell.galleryImage = imageGallery.images[indexPath.item]
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDragDelegate
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(in: collectionView, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(in: collectionView, at: indexPath)
    }
    
    private func dragItems(in collectionView: UICollectionView, at indexPath: IndexPath) -> [UIDragItem] {
        if let galleryImage = (collectionView.cellForItem(at: indexPath) as? GalleryImageViewCell)?.galleryImage {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: galleryImage.url as NSItemProviderWriting))
            dragItem.localObject = galleryImage
            return [dragItem]
        } else {
            return []
        }
    }
    
    // MARK: UICollectionViewDropDelegate
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        let canDrop = session.canLoadObjects(ofClass: NSURL.self)
        return canDrop
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isLocalDrag = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isLocalDrag ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                if let galleryImage = item.dragItem.localObject as? GalleryImage {
                    collectionView.performBatchUpdates({
                        imageGallery.images.remove(at: sourceIndexPath.item)
                        imageGallery.images.insert(galleryImage, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            } else {
                let placeHolderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: placeholderReuseIdentifier))
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let url = provider as? URL {
                            placeHolderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                let galleryImage = GalleryImage(url: url)
                                self.imageGallery.images.insert(galleryImage, at: insertionIndexPath.item)
                            })
                        } else {
                            placeHolderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
