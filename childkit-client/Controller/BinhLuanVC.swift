//
//  BinhLuanVC.swift
//  childkit-client
//
//  Created by SANG on 5/24/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit

class BinhLuanVC: UIViewController {

    @IBOutlet weak var danhSachBinhLuanTableView: UITableView!
    
    var numLike = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        danhSachBinhLuanTableView.delegate = self
        danhSachBinhLuanTableView.dataSource = self
    }

}

extension BinhLuanVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = danhSachBinhLuanTableView.dequeueReusableCell(withIdentifier: "binhLuanCell", for: indexPath) as? BinhLuanCell
        cell?.configure(tenPH: "Nguyễn Huy Hoàng", binhLuan: "Bữa ăn hôm nay ngon lắm")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let like = likeAction(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [like])
    }
    
    func likeAction(indexPath: IndexPath) -> UIContextualAction {
        let like = UIContextualAction(style: .normal, title: "(\(numLike))") { (action, view, completion) in
            print("Tăng like")
            self.numLike += 1
            self.danhSachBinhLuanTableView.reloadData()
        }
        
        like.backgroundColor = .blue
        like.image = UIImage(named: "like")
        print("Đã gọi")
        return like
    }
    
}
