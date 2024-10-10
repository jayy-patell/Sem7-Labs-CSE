//
//  ViewController.swift
//  Exercise_2.11
//
//  Created by Student on 01/10/24.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func clear_function(_ sender: UIButton)
    {
        displayRes?.text="0"
    }
    @IBOutlet var displayRes: UILabel!
    @IBOutlet var buttons: [UIButton]!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for button in buttons {
            button.layer.cornerRadius = 20.0
            print(button.titleLabel!.text!)
        }
        
    }
    
    
    
    @IBAction func clear(_ sender: UIButton, forEvent event: UIEvent) {
//        displayRes?.text="0"
    }
    
}

