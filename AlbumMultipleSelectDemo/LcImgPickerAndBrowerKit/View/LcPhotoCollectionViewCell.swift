//
//  LcPhotoCollectionViewCell.swift
//  AlbumMultipleSelectDemo
//
//  Created by 刘隆昌 on 2020/9/28.
//  Copyright © 2020 刘隆昌. All rights reserved.
//

import UIKit

class LcPhotoCollectionViewCell: UICollectionViewCell {
    
    lazy var selectButton: UIButton = {
        let button = UIButton.init(type: .custom)
        let contenViewSize = self.contentView.bounds.size
        button.frame = CGRect(x: contenViewSize.width * 2 / 3 - 2, y: 2, width: contenViewSize.width / 3, height: contenViewSize.width / 3)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: contenViewSize.width/3 - contenViewSize.width/4, bottom: contenViewSize.width/3 - contenViewSize.width/4, right: 0)
        button.asyncSetImage(UIImage.lcImageFromeBundle(named: "album_select_gray"), for: .normal)
        button.setImage(UIImage(named: "album_select_gray"), for: .normal)
        button.asyncSetImage(UIImage(named: "album_select_gray"), for: .normal)
        button.addTarget(self, action: #selector(selelctButtonClick(button:)), for: .touchUpInside)
        //button.backgroundColor = UIColor.blue
        return button
    }()
    
    lazy var isMasked_NotAllowSelect:Bool = false
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.contentView.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var selectNumber = 0 {
        didSet {
            self.selectButton.isSelected = true
        }
    }
    
    //  cell 是否被选择
    var isChoose = false {
        didSet {
            self.selectButton.isSelected = isChoose
        }
    }
    
    // 图片选中闭包
    var selectPhotoCompleted: (() -> Void)?
    
    // 图片设置
    var photoImage: UIImage? {
        didSet {
            self.photoImageView.image = photoImage
        }
    }
    
    var durationLabel:UILabel!
    var cameraImgView:UIImageView!
    
    convenience init() {
        self.init(frame: CGRect.init())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.photoImageView)
        self.contentView.addSubview(self.selectButton)
        
        
        let cameraImgView = UIImageView.init(frame: CGRect.init(x: 5, y: self.bounds.size.height-20, width: 20, height: 20))
        self.contentView.addSubview(cameraImgView)
        cameraImgView.image = UIImage.init(named: "videoCamera")
        self.cameraImgView = cameraImgView;
        //videoCamera@3x
        
        let durationLabel = UILabel.init(frame: CGRect.init(x: cameraImgView.frame.maxX+5, y: cameraImgView.frame.minY, width: 60, height: 20))
        durationLabel.textColor = UIColor.white
//        durationLabel.backgroundColor = .blue
        durationLabel.font = UIFont.systemFont(ofSize: 10)
        self.durationLabel = durationLabel
        contentView.addSubview(durationLabel)
    }
    
    
    func giveContent(seconds:Int){
        if seconds == 0 {
            self.cameraImgView.isHidden = true
            self.durationLabel.isHidden = true
        }else{
            self.cameraImgView.isHidden = false
            self.durationLabel.isHidden = false
            
            let hour:Int = seconds / (60*60)
            var minites:Int = seconds / 60
            if minites > 60 {
                minites = minites / 60
            }
            let seconds:Int = seconds % 60
            
            if hour == 0 {
                self.durationLabel.text = "\(minites):\(seconds)"
                if minites<10 {
                    if seconds < 10 {
                        self.durationLabel.text = "0\(minites):0\(seconds)"
                    }else{
                        self.durationLabel.text = "0\(minites):\(seconds)"
                    }
                }else{
                    if seconds < 10 {
                        self.durationLabel.text = "\(minites):0\(seconds)"
                    }else{
                        self.durationLabel.text = "\(minites):\(seconds)"
                    }
                }
            }else{
                if hour<10 {
                    if minites<10 {
                        if seconds < 10 {
                            self.durationLabel.text = "0\(hour):0\(minites):0\(seconds)"
                        }else{
                            self.durationLabel.text = "0\(hour):0\(minites):\(seconds)"
                        }
                    }else{
                        if seconds < 10 {
                            self.durationLabel.text = "0\(hour):\(minites):0\(seconds)"
                        }else{
                            self.durationLabel.text = "0\(hour):\(minites):\(seconds)"
                        }
                    }
                }else{
                    if minites<10 {
                        if seconds < 10 {
                            self.durationLabel.text = "\(hour):0\(minites):0\(seconds)"
                        }else{
                            self.durationLabel.text = "\(hour):0\(minites):\(seconds)"
                        }
                    }else{
                        if seconds < 10 {
                            self.durationLabel.text = "\(hour):\(minites):0\(seconds)"
                        }else{
                            self.durationLabel.text = "\(hour):\(minites):\(seconds)"
                        }
                    }                    
                }
            }
            
            
        }
        
    }
        
    
    
   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
   
   @objc func selelctButtonClick(button: UIButton) {
       //        self.isChoose = !self.isChoose
       if selectPhotoCompleted != nil {
           selectPhotoCompleted!()
       }
   }
    
}





class PreviewSmallCollectionViewCell: UICollectionViewCell {
        
        lazy var photoImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.frame = self.contentView.bounds
            imageView.contentMode = .scaleAspectFill
            imageView.frame = self.bounds
            imageView.clipsToBounds = true
            return imageView
        }()
        
        // 图片设置
        var photoImage: UIImage? {
            didSet {
                self.photoImageView.image = photoImage
            }
        }
        
        
        convenience init() {
            self.init(frame: CGRect.init())
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.contentView.addSubview(self.photoImageView)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
}
