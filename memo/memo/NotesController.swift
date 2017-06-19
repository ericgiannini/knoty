//
//  NotesController.swift
//  memo
//
//  Created by Eric Giannini on 6/18/17.
//  Copyright © 2017 Unicorn Mobile, LLC. All rights reserved.
//

import UIKit

class NotesController: UITableViewController {
    
    fileprivate var notes: [Note] = Note.loadNotes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        removeEmptyNotes()
    }
    
    private func removeEmptyNotes() {
        
        let filteredNotes = notes.filter() { !$0.body.isEmpty }
        
        if filteredNotes.count != notes.count { //Some notes were removed
            
            self.notes = filteredNotes
            self.tableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
            
            Note.save(notes: notes)
        }
    }
}

//MARK: Actions
extension NotesController {
    
    @IBAction func onEdit(_ sender: AnyObject) {
        
        let newNote = Note(body: "")
        add(note: newNote)
        
        self.go(toNote: newNote)
    }
    
    private func add(note: Note) {
        
        self.notes.prepend(value: note)
        
        let path = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [path], with: .automatic)
    }
    
    func onNoteEdited(note: Note) {
        
        guard let index = findIndex(of: note)
            else {
                print("Could not find Note: \(note) in Array")
                return
        }
        
        notes[index] = note
        
        let pathToReload = IndexPath(row: index, section: 0)
        self.tableView?.reloadRows(at: [pathToReload], with: .automatic)
        
        Note.save(notes: notes)
        
    }
    
    private func findIndex(of note: Note) -> Int? {
        return notes.index(where: { $0 == note })
    }
}

//MARK: Segues
extension NotesController {
    
    fileprivate func go(toNote note: Note) {
        self.performSegue(withIdentifier: "ToNote", sender: note)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let editController = segue.destination as? EditController
            else { return }
        
        editController.onNoteEdited = self.onNoteEdited
        
        if let note = sender as? Note {
            editController.note = note
        }
        else if let selectedPath = tableView?.indexPathForSelectedRow {
            let row = selectedPath.row
            
            if row >= 0 && row < notes.count {
                let note = notes[row]
                editController.note = note
            }
        }
    }
}

//MARK: Table View Methods
extension NotesController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        guard row >= 0 && row < notes.count,
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NoteCell
            else {
                return UITableViewCell()
        }
        
        let note = notes[row]
        
        cell.noteView?.text = note.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { action, path in
            
            let row = path.row
            
            self.notes.remove(at: row)
            
            if self.notes.isEmpty {
                tableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
            }
            else {
                self.tableView.deleteRows(at: [path], with: .automatic)
            }
        }
        
        return [delete]
    }
}

// MARK : UITableViewCell - should be moved to its own file
class NoteCell: UITableViewCell {
    
    @IBOutlet weak var noteView: UILabel!
    

}
