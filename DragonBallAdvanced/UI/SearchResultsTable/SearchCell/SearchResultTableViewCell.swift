//
//  SearchResultTableViewCell.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 19/9/22.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    // MARK: - CONSTANTS
    static let idententifier = String(describing: SearchResultTableViewCell.self)
    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(with persistanceHero: PersistenceHeros) {
        heroImage.downloadImage(from: persistanceHero.photo ?? "")
        heroName.text = persistanceHero.name
    }
    
}
