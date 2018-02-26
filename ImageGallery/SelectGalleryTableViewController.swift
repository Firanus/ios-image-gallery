//
//  SelectGalleryTableViewController.swift
//  ImageGallery
//
//  Created by Ivan Tchernev on 20/02/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import UIKit

class SelectGalleryTableViewController: UITableViewController {

    var imageGalleries: [ImageGallery] = [imageConstants.mandelbrotGallery]
    var recentlyDeletedGalleries: [ImageGallery] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    @IBAction func addImageGallery(_ sender: UIBarButtonItem) {
        imageGalleries.append(ImageGallery())
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "openGallerySegue":
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPath(for: cell) {
                    return indexPath.section == 0
                }
            }
        default:
            break
        }
        return false
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            switch identifier {
            case "openGallerySegue":
                if let cell = sender as? UITableViewCell {
                    if let indexPath = tableView.indexPath(for: cell) {
                        if let collectionController = segue.destination as? DisplayGalleryCollectionViewController {
                            collectionController.imageGallery = imageGalleries[indexPath.row]
                        }
                    }
                }
            default:
                break
            }
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return imageGalleries.count
        case 1:
            return recentlyDeletedGalleries.count
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "galleryRow", for: indexPath)

        // Configure the cell...
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = imageGalleries[indexPath.row].name
        case 1:
            cell.textLabel?.text = recentlyDeletedGalleries[indexPath.row].name
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Image Galleries"
        case 1:
            return "Recently Deleted"
        default:
            return nil
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let undeleteSwipeAction = UIContextualAction(style: .normal, title: "Restore")
            { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
                tableView.performBatchUpdates({
                    let destinationIndexPath = self.imageGalleries.count
                    let restoredImageGallery = self.recentlyDeletedGalleries[indexPath.row]
                    self.recentlyDeletedGalleries.remove(at: indexPath.row)
                    self.imageGalleries.append(restoredImageGallery)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.insertRows(at: [IndexPath(row: destinationIndexPath, section: 0) ], with: .fade)
                })
                completionHandler(true)
            }
            undeleteSwipeAction.backgroundColor = UIColor(rgbColorCodeRed: 76, green: 217, blue: 100, alpha: 1.0)
            
            return UISwipeActionsConfiguration(actions: [undeleteSwipeAction])
        }
        return nil
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch indexPath.section {
            case 0:
                // Delete the row from the data source
                let deletedGallery = imageGalleries[indexPath.row]
                tableView.performBatchUpdates({
                    let destinationIndexPath = recentlyDeletedGalleries.count
                    imageGalleries.remove(at: indexPath.row)
                    recentlyDeletedGalleries.append(deletedGallery)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.insertRows(at: [IndexPath(row: destinationIndexPath, section: 1) ], with: .fade)
                })
            case 1:
                // Delete the row from the data source
                recentlyDeletedGalleries.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            default:
                break
            }
        } //else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}
