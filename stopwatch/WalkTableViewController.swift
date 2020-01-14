//
//  WalkTableViewController.swift
//  stopwatch
//
//  Created by Wittmayer,Jack T on 1/6/20.
//  Copyright © 2020 Jack Wittmayer. All rights reserved.
//

import UIKit
import os.log

class WalkTableViewController: UITableViewController {

    //MARK: Properties
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var route: Route?
    var walks = [Walk]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Use the edit button item provided by the table view controller.
        //navigationItem.leftBarButtonItem = editButtonItem
        // Load any saved walks, otherwise load sample data.
        if let savedWalks = loadWalks()
        {
            walks += savedWalks
            print("Loading walks from loadWalks()")
            navigationItem.title = route?.name
        }
        else{
            // Load the sample data.
            loadSampleWalks()
            print("Loading sample walks...")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "WalkTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WalkTableViewCell else {
            fatalError("The dequeued cell is not an instance of WalkTableViewCell")
        }
        
        // Fetches the appropriate walk for the data source layout.
        let walk = walks[indexPath.row]
        
        cell.nameLabel.text = walk.name
        cell.photoImageView.image = walk.photo
        cell.timeLabel.text = convertSecondsToMinutes(counter: walk.time)

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            walks.remove(at: indexPath.row)
            saveWalks()
            tableView.deleteRows(at: [indexPath], with: .fade)

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let button = sender as? UIBarButtonItem, button === saveButton
        {
            os_log("Going back to route list...", log:OSLog.default, type: .debug)
            route?.walks = walks
        }
        else{
            switch(segue.identifier ?? "")
            {
                case "AddItem":
                    os_log("Adding a new walk.", log:OSLog.default, type: .debug)
                    
                case "ShowDetails":
                guard let walkDetailViewController = segue.destination as? ViewController
                    else
                {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                guard let selectedWalkCell = sender as? WalkTableViewCell else
                {
                    fatalError("Unexpected sender: \(sender)")
                }
                guard let indexPath = tableView.indexPath(for: selectedWalkCell)
                    else
                {
                    fatalError("The selected cell is not being displayed by the table")
                }
                let selectedWalk = walks[indexPath.row]
                walkDetailViewController.walk = selectedWalk
                
            default:
                fatalError("Unexpected Segue Identifier; \(segue.identifier)")
            }
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        if (!(parent?.isEqual(self.parent) ?? false)) {
            print("Back Button Pressed!")
            route?.walks = walks
        }
    }
    

    //MARK: Private Methods
    
    private func loadSampleWalks()
    {
        let photo1 = UIImage(named: "defaultPhoto")
        let photo2 = UIImage(named: "defaultPhoto")
        let photo3 = UIImage(named: "defaultPhoto")
        guard let walk1 = Walk(name: "Marston to Hume", photo: photo1, time: 15.0) else {
            fatalError("unable to instantiate walk1")
        }
        guard let walk2 = Walk(name: "Dining hall to Hume", photo: photo2, time: 15.0) else {
            fatalError("unable to instantiate walk2")
        }
        guard let walk3 = Walk(name: "Little Hall to library west", photo: photo3, time: 15.0) else {
            fatalError("unable to instantiate walk3")
        }
        walks+=[walk1, walk2, walk3]
    }
    @IBAction func unwindToWalkList(sender: UIStoryboardSegue)
    {

            if let sourceViewController = sender.source as?
                ViewController, let walk = sourceViewController.walk
            {
                if let selectedIndexPath = tableView.indexPathForSelectedRow
                {
                    // Update an existing walk.
                    walks[selectedIndexPath.row] = walk
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                }
                else
                {
                    // Add a new walk.
                    let newIndexPath = IndexPath(row: walks.count, section: 0)
                    walks.append(walk)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
                saveWalks()
            }
        //Save the walks.
    }
    private func saveWalks()
    {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(walks, toFile: Walk.ArchiveURL.path)
        if isSuccessfulSave
        {
            os_log("Walks successfully saved.", log: OSLog.default, type: .debug)
        }
        else
        {
            os_log("Failed to save walks...", log: OSLog.default, type: .error)
        }
    }
    private func loadWalks() -> [Walk]?
    {
        if let route = route
        {
            return route.walks
        }
        else
        {
            return nil
        }
    }
}
