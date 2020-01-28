//
//  ViewController.swift
//  NotesAppFinal
//
//  Created by Naveen Kumar on 2020-01-27.
//  Copyright © 2020 Naveen Kumar. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var noteInfoView: UIView!
    @IBOutlet weak var noteImageViewView: UIView!
    
    @IBOutlet weak var noteNameLabel: UITextField!
    
    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var noteDescriptionLabel: UITextView!
    
    var managedObjectContext: NSManagedObjectContext?{
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    var notesFetchedResultsController: NSFetchedResultsController<Note>!
    var notes = [Note]()
    var note: Note?
    var isExisting = false
    var indexpath: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load Data
        if let note = note {
            noteNameLabel.text = note.noteName
            noteDescriptionLabel.text = note.noteDescription
            noteImageView.image = UIImage(data: note.noteImage! as Data)
        }
        
        if noteNameLabel.text != "" {
            isEditing = true
        }
        
        //Delegates
        noteNameLabel.delegate = self
        noteDescriptionLabel.delegate = self
        
    }
    
    //Core Data
    func saveToCoreData(completion: @escaping ()-> Void){
        managedObjectContext!.perform {
            do{
                try self.managedObjectContext?.save()
                completion()
                print("Note Saved")
            }catch{
                print(error)
            }
        }
    }

    //Image Picker Function
    @IBAction func pickImageButtonWasPressed(_ sender: Any) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "Add an Image", message: "Choose From", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            (action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
        
    }
    
}

