//
//  StoryboardManager.swift
//  TheWalls
//
//  Created by John McClelland on 6/15/15.
//  Copyright (c) 2015 machine^n. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onOnboardingButtonPressed(sender: UIButton)
    {
        var storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        var controller = storyboard.instantiateViewControllerWithIdentifier("SplashViewController") as! UIViewController

        self.presentViewController(controller, animated: true, completion: nil)
    }

    @IBAction func onPrimaryButtonPressed(sender: UIButton)
    {
        var storyboard = UIStoryboard(name: "PrimaryView", bundle: nil)
        var controller = storyboard.instantiateViewControllerWithIdentifier("PrimaryMapViewController") as! UIViewController

        self.presentViewController(controller, animated: true, completion: nil)
    }

}
