//
//  PhotoTableViewCell.swift
//  ZA-assignment
//
//  Created by VinBrain on 17/04/2022.
//

import UIKit

protocol PhotoTableViewCellDelegate: AnyObject {
    func didTapLikeButton(index: Int)
}

class PhotoTableViewCell: UITableViewCell {
    
    // MARK: Identifer
    static let identifier: String = "PhotoTableViewCell"
    
    // MARK: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likeButton: UILabel!
    
    weak var delegate: PhotoTableViewCellDelegate?
    var index: Int!
    
    weak var photoModel: PhotoModel! {
        didSet {
            self.photoImageView.downloaded(from: photoModel.urls.small)
            self.usernameLabel.text = photoModel.user.username
            self.likeButton.text = photoModel.isLiked ? "Unlike" : "Like"
            self.likeButton.textColor = photoModel.isLiked ? UIColor.systemRed : UIColor.systemGreen
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
        
    }
    
    func setupCell() {
        photoImageView.layer.masksToBounds = true
        photoImageView.layer.cornerRadius = 24
        likeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLikeButtonClicked))
)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func onLikeButtonClicked() {
        delegate?.didTapLikeButton(index: index)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        usernameLabel.text = ""
    }
    
}
