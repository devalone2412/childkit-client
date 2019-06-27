//
//  CategoryVC.swift
//  childkit-client
//
//  Created by sang luc on 5/26/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit
import SWRevealViewController
import FirebaseDatabase
import Toast_Swift

class CategoryVC: UIViewController {

    @IBOutlet weak var categoryTableView: UITableView!
    
    var listCategory = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        getData()
    }
    
    func getData() {
        ref_Category.observe(.value) { (snapshot) in
            for data in snapshot.children.allObjects as! [DataSnapshot] {
                let cateObjs = data.value as! [String: AnyObject]
                let keyCate = data.key
                let imageURL = cateObjs["imageURL"] as! String
                let maCategory = cateObjs["maCategory"] as! String
                let tenCategory = cateObjs["tenCategory"] as! String
                
                let category = Category(imageURL: imageURL, maCategory: maCategory, tenCategory: tenCategory, keyCategory: keyCate)
                
                self.listCategory.append(category)
            }
            
            self.categoryTableView.reloadData()
        }
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @IBAction func themCategoryWasPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Tạo category mới", message: "Nhập tên cho category mới", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Tạo", style: .default) { (_) in
            let textField = alert.textFields?[0] as! UITextField
            if !textField.text!.isEmpty {
                let category = [
                    "imageURL": defaultCategoryImage,
                    "maCategory": self.randomString(length: 8),
                    "tenCategory": textField.text
                    ] as [String : Any]
                
                ref_Category.childByAutoId().setValue(category)
                
                self.view.makeToast("Tạo category thành  ", duration: 1.5, position: .bottom)
            }
        }
        
        let huyAction = UIAlertAction(title: "Huỷ", style: .cancel) { (_) in
        }
        
        alert.addTextField { (textField) in
            textField.font = UIFont(name: "AvenirNext-Medium", size: 14)
        }
        
        alert.addAction(action)
        alert.addAction(huyAction)
        present(alert, animated: true, completion: nil)
    }
}

extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryCell
        DispatchQueue.global().async {
            let url = URL(string: self.listCategory[indexPath.row].imageURL)!
            let imageData = try! Data(contentsOf: url)
            let tenCate = self.listCategory[indexPath.row].tenCategory
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)
                cell?.configure(image: image!, name: tenCate!)
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let foodByCategoryVC = storyboard?.instantiateViewController(withIdentifier: "foodByCategory") as! FoodByCategoryVC
        foodByCategoryVC.category = listCategory[indexPath.row]
        navigationController?.pushViewController(foodByCategoryVC, animated: true)
    }
}
