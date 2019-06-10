//
//  NotesViewController.swift
//  ContactsTableView
//
//  Created by Vlad on 5/24/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {

    @IBOutlet weak var notesTitleLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    var returnBackNotes:((String)->())!
    
    var notes: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTitleLabel.text = NSLocalizedString("NOTES_TITLE", comment: "Notes")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("DONE_BUTTON_TEXT", comment: "Done"), style: .done, target: self, action: #selector(doneBottonPressed))
        notesTextView.text = notes
    }
    
    @objc private func doneBottonPressed(){
        returnBackNotes(notesTextView.text)
        navigationController?.popViewController(animated: true)
    }
}
