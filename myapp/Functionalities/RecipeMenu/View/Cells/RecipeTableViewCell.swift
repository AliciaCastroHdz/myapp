//
//  RecipeTableViewCell.swift
//  myapp
//
//  Created by Alicia Monserrath Castro Hernandez on 13/01/21.
//

import SDWebImage
import UIKit

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!

    var recipe: RecipeModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.loadingView.alpha = 1
        self.setup(isEnable: false)
    }

    override func prepareForReuse() {
        self.picture.image = nil
        self.recipe = nil
        self.setup(isEnable: false)
    }

    func setRecipe(_ recipe: RecipeModel) {
        self.recipe = recipe
        self.categoryLabel.text = recipe.category
        self.nameLabel.text = recipe.name
        if let picturePath = recipe.picturePath, picturePath.isValid() {
            self.picture.sd_setImage(with: URL(string: picturePath)) { (image,_,_,_) in
                self.loadingView.isHidden = image != nil
                self.setup(isEnable: image != nil)
            }
        }
    }

    private func setup(isEnable: Bool) {
        self.overlayView.isHidden = !isEnable
    }
}
