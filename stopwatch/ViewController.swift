//
//  ViewController.swift
//  predict
//
//  Created by Jack Wittmayer on 12/30/19.
//  Copyright © 2019 Jack Wittmayer. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var walkButton: UIImageView!
    @IBOutlet weak var runButton: UIImageView!
    @IBOutlet weak var carButton: UIImageView!
    @IBOutlet weak var bikeButton: UIImageView!
    @IBOutlet weak var skateboardButton: UIImageView!
    //MARK: Timer Actions
    @IBAction func startTimer(_ sender: Any) {
        if(isPlaying) {
            return
        }
        startButton.isEnabled = false
        pauseButton.isEnabled = true
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        isPlaying = true
        paused = false
    }
    @IBAction func pauseTimer(_ sender: Any) {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        
        timer.invalidate()
        isPlaying = false
        paused = true
    }
    @IBAction func resetTimer(_ sender: Any) {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        
        timer.invalidate()
        isPlaying = false
        counter = 0.0
        timeLabel.text = String(counter)
    }
    @IBAction func selectWalkButton(_ sender: Any) {
        vehicle_selection = 0
        updateVehicleButtons()
    }
    @IBAction func selectRunButton(_ sender: Any) {
        vehicle_selection = 1
        updateVehicleButtons()
    }
    @IBAction func selectSkateboardButton(_ sender: Any) {
        vehicle_selection = 2
        updateVehicleButtons()
    }
    @IBAction func selectBikeButton(_ sender: Any) {
        vehicle_selection = 3
        updateVehicleButtons()
    }
    @IBAction func selectCarButton(_ sender: Any) {
        vehicle_selection = 4
        updateVehicleButtons()
    }
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var walk: Walk?
    var counter = 0.0
    var timer = Timer()
    var isPlaying = false
    var backGroundTime = Date()
    var paused = true
    var vehicle_selection = 0 // 0 = walk, 1 = run, 2 = skateboard, 3 = bike, 4 = car
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //updateSaveButtonState()
        navigationItem.title = textField.text
        saveButton.isEnabled = true
    }
    //MARK: Navigation
    @IBAction func cancel(_ sender: Any) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddWalkMode = presentingViewController is UINavigationController
        if isPresentingInAddWalkMode
        {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController
        {
            owningNavigationController.popViewController(animated: true)
        }
        else
        {
            fatalError("The walk view controller is not inside a navigation controller.")
        }
    }
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let date = Date()
        let dateString = convertDateToString(date: date)
        var name = ""
        
        if let Name = nameTextField.text
        {
            if Name.isEmpty
            {
                name = dateString
            }
            else
            {
                name = Name
            }
        }
        // let photo = photoImageView.image
        let time = counter
        // Set the walk to be passed to WalkTableViewController after the unwind segue.
        walk = Walk(name: name, time: Double(time), vehicle: vehicle_selection)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        timeLabel.text = String(counter)
        pauseButton.isEnabled = false
        saveButton.isEnabled = true
        
        // Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        // Enable the save button only if the text field has a valid Walk name.
        //updateSaveButtonState()
        
        // Set up views if editing an existing Walk.
        if let walk = walk
        {
            navigationItem.title = walk.name
            nameTextField.text = walk.name
            //photoImageView.image = walk.photo
            timeLabel.text = convertSecondsToMinutes(counter: walk.time)
            counter = walk.time
            vehicle_selection = walk.vehicle
            updateVehicleButtons()
        }
        
    }
    
    //MARK: Background Functionality
    override func viewWillAppear(_ animated: Bool) {
       // some other code
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.activeAgain), name: NSNotification.Name(rawValue: "UIApplicationDidBecomeActiveNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.goingAway), name: NSNotification.Name(rawValue: "UIApplicationWillResignActiveNotification"), object: nil)
    }
    @objc func activeAgain() {
        let date = Date()
        let newTime = date.timeIntervalSince(backGroundTime)
        print("Active again")
        print(newTime)
        if !paused
        {
            counter += newTime
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
            isPlaying = true
        }
    }

    @objc func goingAway() {
        isPlaying = false
        timer.invalidate()
        backGroundTime = Date()
    }
    
    @objc private func UpdateTimer()
    {
        counter = counter + 0.1
        timeLabel.text = convertSecondsToMinutes(counter: counter)
    }
    
    private func updateVehicleButtons()
    {
        walkButton.backgroundColor = nil
        runButton.backgroundColor = nil
        skateboardButton.backgroundColor = nil
        bikeButton.backgroundColor = nil
        carButton.backgroundColor = nil
        switch vehicle_selection {
        case 0:
            walkButton.backgroundColor = UIColor.lightGray
        case 1:
            runButton.backgroundColor = UIColor.lightGray
        case 2:
            skateboardButton.backgroundColor = UIColor.lightGray
        case 3:
            bikeButton.backgroundColor = UIColor.lightGray
        case 4:
            carButton.backgroundColor = UIColor.lightGray
        default:
            fatalError("Unknown button selected")
        }
    }
    
//    //MARK: Private Methods
//    private func updateSaveButtonState()
//    {
//        // Disable the Save button if the time is .
//        let text = nameTextField.text ?? ""
//        saveButton.isEnabled = !text.isEmpty
//    }
}
