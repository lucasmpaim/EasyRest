//
//  ViewController.swift
//  EasyRest
//
//  Created by Lucas on 03/22/2016.
//  Copyright (c) 2016 Lucas. All rights reserved.
//

import UIKit

import EasyRest
import PromiseKit
import Alamofire
import SwiftyJSON
import ZIPFoundation

class ViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    let service = DownloadUrlService()

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImageToStorage()
    }
    
    // Downloads image to memory and use
    func downloadImage() {
        try! service.download(.bigImage, onProgress: {p in
            print("Progress: \(p)")
        }).promise
            .done {[weak self] result in
                guard let data = result?.body else { return }
                self?.image.image = UIImage(data: data)
            }.catch { error in
                print("Error : \(error.localizedDescription)")
            }
    }
    
    // Download image saving gradually to a file and use
    // Use this if you care about memory optimization
    func downloadImageToStorage() {
        try! service.download(.documentDirectory, .bigImage, onProgress: {p in
            print("Progress: \(p)")
        }).promise
            .done {[weak self] result in
                guard let data = result?.body else { return }
                self?.image.image = UIImage(data: data)
            }.catch { error in
                print("Error : \(error.localizedDescription)")
        }
    }
}
