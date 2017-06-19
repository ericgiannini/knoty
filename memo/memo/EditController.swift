//
//  EditController.swift
//  memo
//
//  Created by Eric Giannini on 6/19/17.
//  Copyright © 2017 Unicorn Mobile, LLC. All rights reserved.
//

import UIKit

class EditController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var onNoteEdited: ((Note) -> Void)?

    var note: Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if note == nil {
            print("Note is missing!")
            self.dismiss()
            return
        }
        
        textView.delegate = self

        textView.text = note.body
        
        if textView.text.isEmpty {
            self.textView.becomeFirstResponder()
        }
        
    }

    private func dismiss() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: UITextViewDelegate Methods
extension EditController : UITextViewDelegate {
    
    private var now: Date {
        return Date()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let newText = textView.text ?? ""
        
        note.body = newText
        
        note.timeLastEdited = now
        
        onNoteEdited?(note)
    }
    
    
}
