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
    var uidUser = ""
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
        
        let store = Storage.storage()
        let storeRef = store.reference().child("Childs").child(uidUser).child("Ills").child("\(idIll)/images/profile_photo.jpg")
        print(storeRef)
        storeRef.getData(maxSize: 15 * 1024 * 1024) { data, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else {
                let image = UIImage(data: data!)
                self.imageZoom.image = image
            }
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageZoom
    }

    

}
