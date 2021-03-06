//
//  ViewController.swift
//  GuessMyBreed
//
//  Created by Huong Tran on 6/2/20.
//  Copyright © 2020 RiRiStudio. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var introLabel: UILabel!
    
    var breeds: [String]! {
        let object = UIApplication.shared.delegate
        let delegate = object as! AppDelegate
        return delegate.breeds
    }
    
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        indicator.startAnimating()
        navigationController?.navigationBar.isHidden = true
        overrideUserInterfaceStyle = .light
        
//        getBreedList()
        Client.requestBreedsList(completionHandler: handleBreedsListResponse(breedsListData:error:))
        Client.requestAnyRandomImage(completionHandler: handleRandomImageResponse(imageData:error:))
        
        
    }
    
    func handleImageFileResonse(image: UIImage?, error: Error?) {
        if let image = image {
            DispatchQueue.main.async {
                let screenSize: CGRect = UIScreen.main.bounds
                let screenWidth = screenSize.width
                let imageWidth = image.size.width
                self.imageView.image = image
                if(imageWidth>screenWidth) {
                    self.imageView.contentMode = .scaleAspectFit
                }
                self.indicator.stopAnimating()
                self.playButton.isHidden = false
                self.introLabel.isHidden = false
            }
        } else {
            showLoadFailure(message: error?.localizedDescription ?? "")
        }    
    }
    
    func handleRandomImageResponse(imageData: DogResponse?, error: Error?) {
        guard let url = URL(string: imageData?.message ?? "") else {
            showLoadFailure(message: error?.localizedDescription ?? "")
            Client.requestAnyRandomImage(completionHandler: handleRandomImageResponse(imageData:error:))
            return
        }
        Client.requestImageFile(url: url, completionHandler: self.handleImageFileResonse(image:error:))
    }
    
    func getBreedList() {
            Client.requestBreedsList(completionHandler: handleBreedsListResponse(breedsListData:error:))
        }

    func handleBreedsListResponse(breedsListData: [String]?, error: Error?) {
           if let breedsListData = breedsListData {
            if (breedsListData.count>0){
                DispatchQueue.main.async {
                    print("Got the breed list")
                    let object = UIApplication.shared.delegate
                    let appDelegate = object as! AppDelegate
                    appDelegate.breeds = breedsListData
                }
            } else {
                Client.requestBreedsList(completionHandler: handleBreedsListResponse(breedsListData:error:))
            }
            
           } else {
            print("cannot get the breed list")
                showLoadFailure(message: error?.localizedDescription ?? "")
                Client.requestBreedsList(completionHandler: handleBreedsListResponse(breedsListData:error:))
                print("cannot get the breed list")
           }
           
       }
    
    func showLoadFailure(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        print(message)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

    @IBAction func nextButtonTapped(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "TabBarViewController") as! TabBarViewController
        controller.dataController = dataController
        navigationController?.pushViewController(controller, animated: true)
        
    }
}

