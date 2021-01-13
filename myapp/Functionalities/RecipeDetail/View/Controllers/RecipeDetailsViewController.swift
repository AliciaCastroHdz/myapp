//
//  RecipeDetailsViewController.swift
//  myapp
//
//  Created by Alicia Monserrath Castro Hernandez on 13/01/21.
//

import UIKit

class RecipeDetailsViewController: UIViewController, IRecipeDetailsPresenter {
    @IBOutlet weak var titleButton: UINavigationItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loadingImageView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var stackView: UIStackView!

    var recipe: RecipeModel!
    var presenter: RecipeDetailsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.presenter = RecipeDetailsPresenter(view: self)
        self.presenter?.getDetails(id: self.recipe.id)
    }

    private func setupView() {
        self.titleButton.title = self.recipe.name
        
    }
    
    private func setDatas() {
        self.titleLabel.text = self.recipe.name
        if let picturePath = recipe.picturePath, picturePath.isValid() {
            self.imageView.sd_setImage(with: URL(string: picturePath)) { (image,_,_,_) in
                self.loadingImageView.isHidden = image != nil
            }
        }
        let titles = ["Instructions: "]

        let descriptions: [String?] = [self.recipe.instructions ?? ""]

        titles.enumerated().forEach { (index, title) in
            if let description = descriptions[index], description.isValid() {
                self.stackView.addArrangedSubview(self.createPropertyView(title: title, description: description))
            }
        }
    }

    private func createPropertyView(title: String, description: String) -> PropertyView {
        let propertyView = PropertyView.init()
        propertyView.setProperty(title: title, description: description)
        return propertyView
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func showErrorAlert(title: String, msg: String?) { }

    func showResponse(response: RecipeModel) {
        self.loadingView.isHidden = true
        self.setDatas()
    }
}
