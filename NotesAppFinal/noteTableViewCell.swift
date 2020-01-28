//
//  noteTableViewCell.swift
//  NotesAppFinal
//
//  Created by Naveen Kumar on 2020-01-28.
//  Copyright © 2020 Naveen Kumar. All rights reserved.
//

import UIKit

class noteTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var noteNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var noteImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Styles
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configureCell(note: Note){
        self.noteNameLabel.text = note.noteName?.uppercased()
    }

}
