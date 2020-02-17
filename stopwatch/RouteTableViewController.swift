//
//  RouteTableViewController.swift
//  stopwatch
//
//  Created by Wittmayer,Jack T on 1/6/20.
//  Copyright © 2020 Jack Wittmayer. All rights reserved.
//

import UIKit
import os.log

class RouteTableViewController: UITableViewController {

    //MARK: Properties
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func save(_ sender: Any) {
        saveRoutes()
    }
    var Routes = [Route]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        // Load any saved Routes, otherwise load sample data.
        if let savedRoutes = loadRoutes()
        {
            Routes += savedRoutes
        }
        else{
            // Load the sample data.
            loadSampleRoutes()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Routes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "RouteTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RouteTableViewCell else {
            fatalError("The dequeued cell is not an instance of RouteTableViewCell")
        }
        
        // Fetches the appropriate Route for the data source layout.
        let Route = Routes[indexPath.row]
        
        cell.nameLabel.text = Route.name
        cell.photoImageView.image = Route.photo
        cell.startLabel.text = "Start: " + Route.start
        cell.endLabel.text = "End: " + Route.end
        cell.vehicleTimeLabels = [cell.WalkTimeLabel, cell.RunTimeLabel, cell.SkateboardTimeLabel, cell.BikeTimeLabel, cell.CarTimeLabel]
        cell.vehicleIcons = [cell.walkingIcon, cell.runningIcon, cell.skateboardingIcon, cell.bikingIcon, cell.drivingIcon]
        let times = findAverageTime(route: Route)
        //var i = 0
        // Iterate over times, timeLables, and vehicle icons
        for (time, (timeLabel, icon)) in zip(times, (zip(cell.vehicleTimeLabels, cell.vehicleIcons)))
        {
            if time != 0.0
            {
                timeLabel.text = convertSecondsToMinutesWithoutMili(counter: time)
            }
            else
            {
                icon.isHidden = true
                timeLabel.isHidden = true
            }
//            print(i)
//            i += 1
        }

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
            Routes.remove(at: indexPath.row)
            saveRoutes()
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
        switch(segue.identifier ?? "")
        {
            case "AddRoute":
                os_log("Adding a new Route.", log:OSLog.default, type: .debug)
                
            case "ShowWalks":
            guard let RouteDetailViewController = segue.destination as? WalkTableViewController
                else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedRouteCell = sender as? RouteTableViewCell else
            {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedRouteCell)
                else
            {
                fatalError("The selected cell is not being displayed by the table")
            }
            let passedRoute = Routes[indexPath.row]
//            var selectedRoute = Routes[indexPath.row]
//            let selectedRoute2 = selectedRoute
//            let photo1 = UIImage(named: "defaultPhoto")
//            selectedRoute = Route(name: "Marston to Hume", photo: photo1, start: "Marson", end: "Hume", walks: [Walk]())!
            //RouteDetailViewController.route = selectedRoute2
          let photo1 = UIImage(named: "defaultPhoto")
            RouteDetailViewController.route = Route(name: passedRoute.name, photo: passedRoute.photo, start: passedRoute.start, end: passedRoute.end, walks: passedRoute.walks!)
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    

    //MARK: Private Methods
    
    private func loadSampleRoutes()
    {
        let photo1 = UIImage(named: "defaultPhoto")
        let photo2 = UIImage(named: "defaultPhoto")
        let photo3 = UIImage(named: "defaultPhoto")
        guard let Route1 = Route(name: "Marston to Hume", photo: photo1, start: "Marson", end: "Hume", walks: [Walk]()) else {
            fatalError("unable to instantiate Route1")
        }
        guard let Route2 = Route(name: "Dining hall to Hume", photo: photo2, start: "Dining hall", end: "Hume", walks: [Walk]()) else {
            fatalError("unable to instantiate Route2")
        }
        guard let Route3 = Route(name: "Little Hall to library west", photo: photo3, start: "Little Hall", end: "Libary West", walks: [Walk]()) else {
            fatalError("unable to instantiate Route3")
        }
        Routes+=[Route1, Route2, Route3]
    }
    @IBAction func unwindToRouteList(sender: UIStoryboardSegue)
    {

        if let sourceViewController = sender.source as?
                RouteViewController, let route = sourceViewController.route
            {
                if let selectedIndexPath = tableView.indexPathForSelectedRow
                {
                    // Check if new route is the same as old route
                    if (!routesAreEqual(route1: Routes[selectedIndexPath.row], route2: route))
                    {
                        // Update an existing Route.
                        Routes[selectedIndexPath.row] = route
                        tableView.reloadRows(at: [selectedIndexPath], with: .none)
                        saveRoutes()
                    }
                    else
                    {
                        os_log("Route not modified so not saving...")
                    }
                }
                else
                {
                    // Add a new Route.
                    let newIndexPath = IndexPath(row: Routes.count, section: 0)
                    Routes.append(route)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                    saveRoutes()
                }
            }
        else if let sourceViewController = sender.source as? WalkTableViewController, let route = sourceViewController.route
        {
            if let selectedIndexPath = tableView.indexPathForSelectedRow
            {
                // Update an existing Route.
                // Check if new route is the same as old route
                if (!routesAreEqual(route1: Routes[selectedIndexPath.row], route2: route))
                {
                    Routes[selectedIndexPath.row] = route
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                    saveRoutes()
                }
                else
                {
                    os_log("Route not modified so not saving...")
                }
            }
        }
    }
    private func saveRoutes()
    {
        print("Saving...")
        self.saveButton.isEnabled = false
        DispatchQueue.global(qos: .utility).async {
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.Routes, toFile: Route.ArchiveURL.path)
            if isSuccessfulSave
            {
                os_log("Routes successfully saved.", log: OSLog.default, type: .debug)
            }
            else
            {
                os_log("Failed to save routes...", log: OSLog.default, type: .error)
            }
            DispatchQueue.main.async {
                self.saveButton.isEnabled = true
            }
        }
    }
    private func loadRoutes() -> [Route]?
    {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Route.ArchiveURL.path) as? [Route]
    }
    private func findAverageTime(route: Route) -> [Double]
    {
        //TODO: change findAverageTime to return list of times, one item for each vehicle
        
        var averages = [0.0, 0.0, 0.0, 0.0, 0.0]
        var walk_counts = [0, 0, 0, 0, 0]
        if let walks = route.walks
        {
            if walks.count != 0
            {
                for walk in walks
                {
                    averages[walk.vehicle] += walk.time
                    walk_counts[walk.vehicle] += 1
                }
                for (i, count) in walk_counts.enumerated()
                {
                    if count != 0
                    {
                        averages[i] /= Double(count)
                    }
                }
            }
        }
        return averages
    }
}
