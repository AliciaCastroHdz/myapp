//
//  PropertyView.swift
//  myapp
//
//  Created by Alicia Monserrath Castro Hernandez on 13/01/21.
//

import Foundation
import UIKit

class PropertyView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    internal func commonInit() {
        Bundle.main.loadNibNamed("PropertyView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.descriptionLabel.setLineSpacing(lineSpacing: 5)
    }

    func setProperty(title: String, description: String) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
    }
}
