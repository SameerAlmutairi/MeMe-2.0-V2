//
//  MemeDetailViewController.swift
//  Meme-2.0
//
//  Created by Sameer Almutairi on 26/04/2019.
//  Copyright © 2019 Sameer Almutairi. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var selectedMeme: Meme!
    
    @IBOutlet weak var memedPickerView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        memedPickerView.image = selectedMeme.memedImage
    }
    


}
