//
//  NoteRecordTableViewCell.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 5/9/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

protocol NoteRecordTableViewCellDelegate {
    func didBeginEditing()
    func didEndEditing()
}

class NoteRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var NotesLabel: UILabel!
    @IBOutlet weak var NotesTextField: UITextField!
    
    private var delegate: NoteRecordTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(delegate: NoteRecordTableViewCellDelegate) {
        self.delegate = delegate
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.didBeginEditing()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.didEndEditing()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) {
        NotesTextField.resignFirstResponder()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
