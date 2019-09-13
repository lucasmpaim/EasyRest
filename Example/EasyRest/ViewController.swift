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

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImage()
    }
    
    func downloadImage() {
        let service = DownloadUrlService()
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
}
