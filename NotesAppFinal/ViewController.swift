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
        
    }


}

