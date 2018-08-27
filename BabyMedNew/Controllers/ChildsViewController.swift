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
import SVProgressHUD

struct ChildModel{
    
    var id = ""
    var name = ""
    var birthDate = ""
    var gender = ""
    var bloodType = ""
    var weight = ""
    var image = String()
    var userId = ""
    var illnessList = [IllModel]()
    
    init(id: String?, name: String?, birthDate: String?,  gender: String?, bloodType: String?, image: String?, weight: String?, userId: String?) {
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
    var childArray = [ChildModel]()
    var userID = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        childArray.removeAll()
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
    
    @objc func refresh(_ sender: Any) {
        
        childArray.removeAll()
        loadChildsData()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childArray.count//childsArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ChildTableViewCell
        
        cell?.labelName.text = childArray[indexPath.row].name
        cell?.labelAge.text = childArray[indexPath.row].birthDate
        cell?.imageFoto.image = getImage(imageName: childArray[indexPath.row].image)
        
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
        vc.imageFoto = child.image
        vc.id = child.id 
        vc.userId = child.userId
        vc.childPerson = child
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Deleted")
            ref = Database.database().reference()
            let id = childArray[indexPath.row].id
            
            ref?.child("children").child("\(id)").removeValue()
            childArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func loadChildsData() {
        if childArray.isEmpty{
            SVProgressHUD.dismiss()
        }
        SVProgressHUD.show()
        
        ref = Database.database().reference()
        ref?.child("children").observe(.childAdded, with: { snapshot  in
            
            if let getData = snapshot.value as? [String:Any] {
                
                if
                    let name = getData["name"],
                    let birthDay = getData["birthDate"],
                    let bloodType = getData["bloodType"],
                    let weight = getData["weight"],
                    let userId = getData["userId"],
                    let image = getData["image"],
                    let gender = getData["gender"],
                    let idString =  getData["id"]
                {
                    if self.userID == userId as! String{
                        self.childArray.insert(ChildModel(id: idString as? String,
                                                          name: name as? String,
                                                          birthDate: birthDay as? String,
                                                          gender: gender as? String,
                                                          bloodType: bloodType as? String,
                                                          image: image as? String,
                                                          weight: weight as? String,
                                                          userId: userId as? String), at: 0)
                    }
                    self.tableView.reloadData()
                }
            }
            SVProgressHUD.dismiss()
        })
        self.tableView.reloadData()
    }
    
    func getImage(imageName: String) -> UIImage{
        
        var decodeImage = UIImage()
        if  let decode  = NSData(base64Encoded: imageName, options: .ignoreUnknownCharacters){
            decodeImage = UIImage(data: decode as Data) ?? UIImage(named: "avatar_default")!
        }
        return decodeImage
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

