//
//  ViewController.swift
//  AlphabetWall
//
//  Created by Séraphin Hochart on 16-10-13.
//  Copyright © 2016 Séraphin Hochart. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let lightsManager = LightsManager()

    @IBOutlet weak var alphabetImage: UIImageView?

    // MARK: - Setup

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LightsManager.sharedManager.alphabetView = alphabetImage
        CommunicationManager.sharedManager.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

