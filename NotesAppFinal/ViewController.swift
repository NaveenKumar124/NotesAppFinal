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
        
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default){
            (action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default){
            (action) in
            pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    //This function is called when we choose our photo and confirm our selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.noteImageView.image = image
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }

    // Save
    @IBAction func saveButtonWasPressed(_ sender: UIBarButtonItem) {
        if noteNameLabel.text == "" || noteNameLabel.text == "NOTE NAME" || noteDescriptionLabel.text == "" || noteDescriptionLabel.text == "Note Description..." {
            
            let alertController = UIAlertController(title: "Missing Information", message:"You left one or more fields empty. Please make sure that all fields are filled before attempting to save.", preferredStyle: UIAlertController.Style.alert)
            let OKAction = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil)
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        else {
            if (isExisting == false) {
                let noteName = noteNameLabel.text
                let noteDescription = noteDescriptionLabel.text
                
                if let moc = managedObjectContext {
                    let note = Note(context: moc)

                    if let data = self.noteImageView.image!.jpegData(compressionQuality: 1.0) {
                        note.noteImage = data as NSData as Data
                    }
                
                    note.noteName = noteName
                    note.noteDescription = noteDescription
                
                    saveToCoreData() {
                        
                        let isPresentingInAddFluidPatientMode = self.presentingViewController is UINavigationController
                        
                        if isPresentingInAddFluidPatientMode {
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                        
                        else {
                            self.navigationController!.popViewController(animated: true)
                            
                        }

                    }

                }
            
            }
            
            else if (isExisting == true) {
                
                let note = self.note
                
                let managedObject = note
                managedObject!.setValue(noteNameLabel.text, forKey: "noteName")
                managedObject!.setValue(noteDescriptionLabel.text, forKey: "noteDescription")
                
                if let data = self.noteImageView.image!.jpegData(compressionQuality: 1.0) {
                    managedObject!.setValue(data, forKey: "noteImage")
                }
                
                do {
                    try context.save()
                    
                    let isPresentingInAddFluidPatientMode = self.presentingViewController is UINavigationController
                    
                    if isPresentingInAddFluidPatientMode {
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                        
                    else {
                        self.navigationController!.popViewController(animated: true)
                        
                    }

                }
                
                catch {
                    print("Failed to update existing note.")
                }
            }

        }

    }
    
}

