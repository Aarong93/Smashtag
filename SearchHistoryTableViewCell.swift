//
//  SearchHistoryTableViewCell.swift
//  Smashtag
//
//  Created by Aaron Grau on 11/8/15.
//  Copyright (c) 2015 Aaron Grau. All rights reserved.
//

import UIKit

class SearchHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var historyTextLabel: UILabel!
    
    var data : String?{
        didSet{
            UpdateUI()
        }
    }

    private func UpdateUI(){
        historyTextLabel.text = nil
        
        if let data = self.data{
            historyTextLabel.text = data
        }
    }

}
