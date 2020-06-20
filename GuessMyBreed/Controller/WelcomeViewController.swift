//
//  ViewController.swift
//  GuessMyBreed
//
//  Created by Huong Tran on 6/2/20.
//  Copyright © 2020 RiRiStudio. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var breeds: [String]! {
        let object = UIApplication.shared.delegate
        let delegate = object as! AppDelegate
        return delegate.breeds
    }
    
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        overrideUserInterfaceStyle = .light
        
        Client.requestAnyRandomImage(completionHandler: handleRandomImageResponse(imageData:error:))
        getBreedList()
    }
    
    func handleImageFileResonse(image: UIImage?, error: Error?) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    func handleRandomImageResponse(imageData: DogResponse?, error: Error?) {
        guard let url = URL(string: imageData?.message ?? "") else {
                print("cannot create URL")
                return
        }
        Client.requestImageFile(url: url, completionHandler: self.handleImageFileResonse(image:error:))
    }
    
    func getBreedList() {
            Client.requestBreedsList(completionHandler: handleBreedsListResponse(breedsListData:error:))
        }

    func handleBreedsListResponse(breedsListData: [String]?, error: Error?) {
           if let breedsListData = breedsListData {
            DispatchQueue.main.async {
                let object = UIApplication.shared.delegate
                let appDelegate = object as! AppDelegate
                appDelegate.breeds = breedsListData
            }
            
//               breeds = breedsListData
//                print(breeds)
//               DispatchQueue.main.async {
//                   self.pickerView.reloadAllComponents()
//               }
            
//            let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: memedImage)
//            let object = UIApplication.shared.delegate
//            let appDelegate = object as! AppDelegate
//            appDelegate.memes.append(meme)
           } else {
               print("cannot get the breed list")
           }
           
       }
//    func handleBreedsListResponse(breedsListData: [String]?, error: Error?) {
//        if let breedsListData = breedsListData {
//            self.breeds = breedsListData
//            DispatchQueue.main.async {
////                self.pickerView.reloadAllComponents()
//            }
//        } else {
//            print("cannot get the breed list")
//        }
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let controller = segue.destination as! QuizViewController
//        controller.breeds = breeds
//    }
    @IBAction func nextButtonTapped(_ sender: Any) {
//        let controller : QuizViewController
//        let controller = storyboard?.instantiateViewController(identifier: "QuizViewController") as! QuizViewController
        let controller = storyboard?.instantiateViewController(identifier: "TabBarViewController") as! TabBarViewController
        controller.dataController = dataController
        navigationController?.pushViewController(controller, animated: true)
//        controller.breeds = breeds
//        showDetailViewController(controller, sender: self)
//        performSegue(withIdentifier: "QuizViewController", sender: self)
        
    }
}

