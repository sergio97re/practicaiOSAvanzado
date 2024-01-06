//
//  HeroCellView.swift
//  PracticaFinaliOSAvanzado
//
//  Created by Sergio Reina Montes on 04/01/2024.
//

import UIKit
import Kingfisher

class HeroCellView: UITableViewCell {
    static let identifier: String = "HeroCellView"
    static let estimatedHeight: CGFloat = 256
    
    //MARK: - IBOUTLETS -
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var heroeDescription: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        name.text = nil
        photo.image = nil
        heroeDescription.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 8
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.6
        
        photo.layer.cornerRadius = 8
        
        selectionStyle = .none
    }
    
    func updateView(
        name: String? = nil,
        photo: String? = nil,
        description: String? = nil) {
            
        self.name.text = name
        self.heroeDescription.text = description
        self.photo.kf.setImage(with: URL(string: photo ?? ""))
        
    }
}
