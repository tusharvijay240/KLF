//
//  TvCellDetailsTableViewCell.swift
//  AttendenceScanner
//
//  Created by Tushar on 16/01/25.
//

import UIKit

class EventDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        // Set corner radius for contentView
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true  // Ensures subviews stay within bounds
        
        // Set shadow on the cell layer (not contentView)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 2, height: 4)
        layer.shadowRadius = 6
        layer.masksToBounds = false  // Allows the shadow to be visible outside
        
        // Optional: Set the background color of the cell
        contentView.backgroundColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure shadow bounds match the content view size
        layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
   
    
    
}
