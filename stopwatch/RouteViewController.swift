//
//  RouteViewController.swift
//  stopwatch
//
//  Created by Wittmayer,Jack T on 1/12/20.
//  Copyright © 2020 Jack Wittmayer. All rights reserved.
//

import UIKit
import os.log

class RouteViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var startField: UITextField!
    @IBOutlet weak var endField: UITextField!
    @IBOutlet weak var photoSelect: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var route: Route?
    
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
        updateSaveButtonState()
        navigationItem.title = textField.text
    }

    //MARK: Navigation
    @IBAction func cancel(_ sender: Any) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddRouteMode = presentingViewController is UINavigationController
        if isPresentingInAddRouteMode
        {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController
        {
            owningNavigationController.popViewController(animated: true)
        }
        else
        {
            fatalError("The route view controller is not inside a navigation controller.")
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
            if let Name = nameField.text
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
            let photo = photoSelect.image
            let start = startField.text ?? ""
            let end = endField.text ?? ""
            var finalWalks: [Walk]
            finalWalks = []
            if let Route = route
            {
                if let walks = Route.walks
                {
                    finalWalks = walks
                }
            }            
            
            // Set the Route to be passed to RouteTableViewController after the unwind segue.
            route = Route(name: name, photo: photo, start: start, end: end, walks: finalWalks)
            print("About to to exit...")
        }
    override func viewDidLoad()
     {
         super.viewDidLoad()
         
         // Handle the text field's user input through delegate callbacks.
         nameField.delegate = self
        startField.delegate = self
        endField.delegate = self
         // Enable the save button only if the text field has a valid Walk name.
         updateSaveButtonState()
         
         // Set up views if editing an existing Walk.
         if let route = route
         {
             navigationItem.title = route.name
             nameField.text = route.name
            startField.text = route.start
            endField.text = route.end
             photoSelect.image = route.photo
         }
         
     }
     
    //MARK: Private Methods
    private func updateSaveButtonState()
    {
        // Disable the Save button if the start or end fields are empty.
        let text = endField.text ?? ""
        let text2 = startField.text ??  ""
        saveButton.isEnabled = !text.isEmpty && !text2.isEmpty
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.dismiss(animated: true, completion: nil)
        photoSelect.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameField.resignFirstResponder()
        startField.resignFirstResponder()
        endField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        //Allow photos to be picked and taken
        imagePickerController.sourceType = .camera
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
}
