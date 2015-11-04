//
//  MentionTableViewCEll.swift
//  Smashtag
//
//  Created by Aaron Grau on 11/2/15.
//  Copyright (c) 2015 Aaron Grau. All rights reserved.
//

import UIKit

class MentionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mentionsTextLabel: UILabel!
    @IBOutlet weak var mentionsImage: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageBotMargin: NSLayoutConstraint!
    @IBOutlet weak var imageTopMargin: NSLayoutConstraint!


    
    var data: AnyObject?{
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    
    private func updateUI(){
        mentionsTextLabel?.text = nil
        mentionsImage?.image = nil
        
        if let imageURL = data as? NSURL{
            mentionsImage?.contentMode = .ScaleAspectFill
            mentionsTextLabel?.hidden = true
            mentionsImage?.hidden = false
            spinner?.startAnimating()
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            dispatch_async(dispatch_get_global_queue(qos,0)){ () -> Void in
                let imageData = NSData(contentsOfURL: imageURL)
                dispatch_async(dispatch_get_main_queue()){
                    if imageURL == self.data as NSURL{
                        self.spinner?.stopAnimating()
                        self.mentionsImage?.image = UIImage(data: imageData!)
                    }
                }
            }
        }
            
        else{
            imageHeight?.constant = 0;
            imageWidth?.constant = 0;
            let text = data as? String
            mentionsImage?.hidden = true
            mentionsTextLabel?.hidden = false
            mentionsTextLabel?.text = text
        }
    }
}
