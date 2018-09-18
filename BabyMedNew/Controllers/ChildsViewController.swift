//
//  ChildsViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 15.08.2018.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//
import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage
import FirebaseAuth
import SVProgressHUD
import AlamofireImage

struct ChildModel{
    
    var id = ""
    var name = ""
    var birthDate = ""
    var gender = ""
    var bloodType = ""
    var weight = Int()
    var image = String()
    var userId = ""
    var illnessList = [IllModel]()
    
    init(id: String?, name: String?, birthDate: String?,  gender: String?, bloodType: String?, image: String?, weight: Int?, userId: String?) {
        self.id = id!
        self.name = name!
        self.birthDate = birthDate!
        self.gender = gender!
        self.bloodType = bloodType!
        self.image = image!
        self.weight = weight!
        self.userId = userId!
    }
    init(id: String?) {
        self.id = id!
    }
    
    init(illnessList: [IllModel]?) {
        self.illnessList = illnessList!
    }
}


class ChildsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference?
    var refreshControl: UIRefreshControl!
    var ArrayChild =  [DataSnapshot]()
    var childArray = [ChildModel]()  {
        didSet {
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    
    
    var userID = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        checkReachability()
        pullToRefresh()
        userID = (Auth.auth().currentUser?.uid)!
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func pullToRefresh() {
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Идет обновление...")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    fileprivate func extractedFunc() {
        loadChildsData()
    }
    
    @objc func refresh(_ sender: Any) {
        
        childArray.removeAll()
        extractedFunc()
        SVProgressHUD.dismiss()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childArray.count//childsArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ChildTableViewCell
        
        let store = Storage.storage()
        
        cell?.labelName.text = self.childArray[indexPath.row].name
        cell?.labelAge.text = self.childArray[indexPath.row].birthDate
        
        if self.childArray[indexPath.row].image == "" || self.childArray[indexPath.row].image == "null" {
            cell?.imageFoto.image = UIImage(named: "avatar_default")
            
        }else{
            
            SVProgressHUD.show()
            let storeRef = store.reference(forURL: self.childArray[indexPath.row].image)
            storeRef.downloadURL { url, error in
                
                if let error = error {
                    print("error: \(error)")
                } else {
                    
                    if let urlString = url{
                        if let data = try? Data(contentsOf: urlString) {
                            if let image = UIImage(data: data) {
                                DispatchQueue.global(qos: .userInitiated).async {
                                    DispatchQueue.main.async {
                                        cell?.imageFoto.image = image
                                        SVProgressHUD.dismiss()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let child = childArray[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PersonalViewController") as! PersonalViewController
        
        vc.name = child.name
        vc.bd = child.birthDate
        vc.blood = child.bloodType
        vc.weight = child.weight 
        vc.gen = child.gender
        vc.indexPath = indexPath
        vc.uid = child.id
        vc.userId = child.userId
        vc.childPerson = child
        vc.firebaseImagePath = child.image
        view.isUserInteractionEnabled = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            print("Deleted")
            ref = Database.database().reference()
            
            let id = childArray[indexPath.row].id
            let imgPath = childArray[indexPath.row].image
            ref?.child("children").child("\(id)").removeValue()
            
            let illCount = childArray[indexPath.row].illnessList.count
            print("illCount:\(illCount)")
            if illCount > 0{
                for index in 0...(illCount - 1){
                    let idill = childArray[indexPath.row].illnessList[index].fotoRecept
                    let storage = Storage.storage()
                    let storeRef = storage.reference(forURL: idill)
                    storeRef.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            print("Success delete")
                        }
                    }
                }
            }
            if imgPath != "" || imgPath != "null"{
                let storage = Storage.storage()
                let storeRef = storage.reference(forURL: imgPath)
                storeRef.delete { error in
                    if let error = error {
                        print(error)
                    } else {
                        print("Success delete")
                    }
                }
            }
            childArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func loadChildsData() {
        
        ref = Database.database().reference()
        self.childArray.removeAll()
        
        ref?.child("children").observe(.childAdded, with: { snapshot  in
            
            if let getData = snapshot.value as? [String:Any] {
                
                if
                    let name = getData["name"],
                    let birthDay = getData["birthDate"],
                    let bloodType = getData["bloodType"],
                    let weight = getData["weight"],
                    let userId = getData["userId"],
                    let image = getData["photoUri"],
                    let gender = getData["gender"],
                    let idString = getData["id"]
                {
                    if self.userID == userId as! String{
                        self.childArray.append(ChildModel(id: idString as? String,
                                                          name: name as? String,
                                                          birthDate: birthDay as? String,
                                                          gender: gender as? String,
                                                          bloodType: bloodType as? String,
                                                          image: image as? String,
                                                          weight: weight as? Int,
                                                          userId: userId as? String))
                        self.tableView.reloadData()
                    }
                    self.tableView.reloadData()
                }
                self.tableView.reloadData()
            }
            SVProgressHUD.dismiss()
        })
        self.tableView.reloadData()
    }
    
    
    @IBAction func LogOutButton(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Внимание!", message: "Вы хотите покинуть вашу семью!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        let action1 = UIAlertAction(title: "Да", style: .default, handler:{(action) -> Void in
            do{
                UserDefaults.standard.set("", forKey: "email")
                try Auth.auth().signOut()
                let storyboard =  UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! LoginNavigationViewController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = vc
            }
            catch{
                print("error problem with sign out")
            }
        })
        alert.addAction(action1)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkReachability(){
        
        if currentReachabilityStatus == .reachableViaWiFi {
            loadChildsData()
            print("User is connected to the internet via wifi.")
        }else if currentReachabilityStatus == .reachableViaWWAN{
            loadChildsData()
            print("User is connected to the internet via WWAN.")
        }else if currentReachabilityStatus == .notReachable{
            let alert = UIAlertController(title: "Внимание!", message: "Подключитесь к интернету.", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "OK", style: .cancel, handler:nil)
            alert.addAction(action1)
            self.present(alert, animated: true, completion: nil)
            SVProgressHUD.dismiss()
        } else {
            let alert = UIAlertController(title: "Внимание!", message: "Подключитесь к интернету.", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "OK", style: .cancel, handler:nil)
            alert.addAction(action1)
            self.present(alert, animated: true, completion: nil)
            SVProgressHUD.dismiss()
            print("There is no internet connection")
        }
    }
}
extension UIImage {
    func decodeImage() -> UIImage? {
        guard let newImage = self.cgImage else { return nil }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil,
                                width: newImage.width,
                                height: newImage.height,
                                bitsPerComponent: 8,
                                bytesPerRow: newImage.width * 4,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.draw(newImage, in: CGRect(x: 0, y: 0, width: newImage.width, height: newImage.height))
        
        let decodeImage = context?.makeImage()
        
        if let decodeImage = decodeImage {
            return UIImage(cgImage: decodeImage)
        }
        return nil
    }
}

