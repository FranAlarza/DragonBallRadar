//
//  PrincipalCollectionViewCell.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 6/9/22.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
// MARK: - Constants
    static let identifier = String(describing: OnboardingCollectionViewCell.self)
    
// MARK: - IBOutlets
    
    @IBOutlet weak var principalImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Functions
    func setData(with model: PrincipalModel) {
        principalImage.image = UIImage(named: model.image)
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
}
