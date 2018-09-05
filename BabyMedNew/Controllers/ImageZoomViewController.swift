//
//  ImageZoomViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 15.08.2018.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import FirebaseStorage

class ImageZoomViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageZoom: UIImageView!
    
    var imageString = ""
    var id = ""
    var idIll = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        refreshProfileImage()
        
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func refreshProfileImage(){
        
        if imageString == ""{
            imageZoom.image = UIImage(named: "avatar_default")
        }else{
            DispatchQueue.main.async {
                let store = Storage.storage()
                let storeRef = store.reference(forURL: self.imageString)
                
                storeRef.downloadURL { url, error in
                    if let error = error {
                        
                        print("error: \(error)")
                    } else {
                        if let data = try? Data(contentsOf: url!) {
                            if let image = UIImage(data: data) {
                                
                                self.imageZoom.image = image
                            }
                        }
                    }
                }
            }
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageZoom
    }
}
