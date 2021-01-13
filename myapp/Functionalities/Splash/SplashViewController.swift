//
//  SplashViewController.swift
//  myapp
//
//  Created by Alicia Monserrath Castro Hernandez on 13/01/21.
//

import UIKit

class SplashViewController: UIViewController {
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = RecipeMenuViewController(nibName: "RecipeMenuViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
