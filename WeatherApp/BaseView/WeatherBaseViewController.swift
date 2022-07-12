//
//  WeatherBaseViewController.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 07/07/22.
//

import UIKit
import ProgressHUD

class WeatherBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func showHUD() {
        ProgressHUD.show(nil, interaction: false)
    }
    
    func hideHUD() {
        ProgressHUD.dismiss()
    }
}

