//
//  ViewController.swift
//  demo1
//
//  Created by Student on 03/09/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mybutton: UIButton!  //force unwrapping
    @IBOutlet weak var mytext: UITextField!
    @IBOutlet weak var mainButton: UIButton!
    var idx=0
    var lightOn=true
    
    @IBAction func onButtonClick(_ sender: Any) {
        if idx==0 {
            mybutton.tintColor = .blue
            idx=1
        } else {
            mybutton.tintColor = .red
            idx=0
        }
    }
    
    func updateUI() {
      if lightOn {
        view.backgroundColor = .white
        mainButton.setTitle("Off", for: .normal)
      } else {
        view.backgroundColor = .black
        mainButton.setTitle("On", for: .normal)
      }
    }
    @IBAction func mainButtonPressed(_ sender: Any) {
        lightOn.toggle()
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mybutton.tintColor = .red
    }


}

