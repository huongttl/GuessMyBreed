//
//  TabBarViewController.swift
//  GuessMyBreed
//
//  Created by Huong Tran on 6/8/20.
//  Copyright © 2020 RiRiStudio. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
//    var breeds: [String]! {
//        let object = UIApplication.shared.delegate
//        let delegate = object as! AppDelegate
//        return delegate.breeds
//    }
    var dataController: DataController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("print")
//        print(tabBarController?.viewControllers)
        print(dataController)
    }
    

   /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
*/
    

}
