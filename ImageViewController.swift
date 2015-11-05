//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Aaron Grau on 11/5/15.
//  Copyright (c) 2015 Aaron Grau. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    var imageURL: NSURL?{
        didSet{
            image = nil
            if view.window != nil{
                fetchImage()
            }
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private func fetchImage(){
        if let url = imageURL {
            spinner?.startAnimating()
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            dispatch_async(dispatch_get_global_queue(qos, 0)){ () -> Void in
                let imageData = NSData(contentsOfURL: url)
                    if url == self.imageURL{
                    dispatch_async(dispatch_get_main_queue()){
                        if imageData != nil {
                            self.image = UIImage(data: imageData!)
                        }
                    }
                }
            }
        }
    }
    
    private var imageView = UIImageView()
    
    private var image: UIImage? = UIImage(){
        didSet{
            if image != nil{
                imageView.image = image
                imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: image!.size)
                spinner?.stopAnimating()
                configureScrollView()
            }
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        configureScrollView()
    }
    
    private func configureScrollView(){
        scrollView?.contentSize = imageView.frame.size
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        scrollView.minimumZoomScale = minScale;
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale;
    }
    

    override func viewDidLoad(){
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil{
            fetchImage()
        }
    }
}
