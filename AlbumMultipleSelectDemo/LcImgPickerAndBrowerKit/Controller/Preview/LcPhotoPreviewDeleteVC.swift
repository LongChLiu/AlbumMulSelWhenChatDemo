//
//  LcPhotoPreviewDeleteVC.swift
//  AlbumMultipleSelectDemo
//
//  Created by 刘隆昌 on 2020/9/28.
//  Copyright © 2020 刘隆昌. All rights reserved.
//

import UIKit
import Photos


class LcPhotoPreviewDeleteVC: LcBaseVC , UICollectionViewDelegate, UICollectionViewDataSource {

    /// 当前展示第几张，默认0
        public var currentIndex = 0
        /// 浏览数据源
        public var previewPhotoArray: [LcPhotoModel] = []
        /// 是否支持删除，默认不支持
        public var isAllowDelete = true
        /// 删除闭包，设置该闭包后删除功能默认打开
        public var deleteClicked: ((_ photos: [LcPhotoModel], _ deleteIndex: Int) -> Void)? {
            didSet {
                if deleteClicked != nil {
                    isAllowDelete = true
                }
            }
        }
        
        private let cellIdentifier = "PreviewCollectionCell"
        
        private var scrollDistance: CGFloat = 0
        
        private lazy var photoCollectionView: UICollectionView = {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            flowLayout.itemSize = CGSize(width: kScreenWidth+10, height: kScreenHeight)
            flowLayout.scrollDirection = .horizontal
            //  collectionView
            let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth+10, height: kScreenHeight), collectionViewLayout: flowLayout)
            collectionView.backgroundColor = UIColor.clear
            collectionView.isPagingEnabled = true
            //  添加协议方法
            collectionView.delegate = self
            collectionView.dataSource = self
            //  设置 cell
            collectionView.register(LcPreviewCollectionViewCell.self, forCellWithReuseIdentifier: self.cellIdentifier)
            return collectionView
        }()
        
        deinit {
            if kPhotoAlbumEnableDebugOn {
                print("=====================\(self)未内存泄露")
            }
        }
        
        override public func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
            self.view.backgroundColor = UIColor.black
            self.automaticallyAdjustsScrollViewInsets = false
            self.view.addSubview(self.photoCollectionView)
            self.initNavigation()
        }
        
        override public func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
    //        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
            self.photoCollectionView.selectItem(at: IndexPath(item: self.currentIndex, section: 0), animated: false, scrollPosition: .left)
            self.setNavTitle(title: "\(self.currentIndex+1)/\(self.previewPhotoArray.count)")
        }
        
        override public func didMove(toParent parent: UIViewController?) {
            if parent == nil {
    //            UIApplication.shared.setStatusBarHidden(false, with: .none)
            }
        }
        
        public override var preferredStatusBarStyle: UIStatusBarStyle{
            return .default
        }
        
        //  MARK:- private method
        private func initNavigation() {
            self.setNavTitle(title: "\(self.currentIndex+1)/\(self.previewPhotoArray.count)")
            if isAllowDelete {
                self.setRightImageButton(normalImage: UIImage.lcImageFromeBundle(named: "album_photo_delete.png"), selectedImage: LcSelectSkinImage, isSelected: false)
            }
            self.view.bringSubviewToFront(self.naviView)
        }
        
        // handle events
        override func rightButtonClick(button: UIButton) {
            let deleteAlert = UIAlertController(title: nil, message: "确定要删除此照片吗？", preferredStyle: .alert)
            let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            deleteAlert.addAction(cancleAction)
            let deleteAction = UIAlertAction(title: "删除", style: .default, handler: { [unowned self] (alertAction) in
                let deleteIndex = self.currentIndex
                self.previewPhotoArray.remove(at: self.currentIndex)
                self.photoCollectionView.deleteItems(at: [IndexPath(item: self.currentIndex, section: 0)])
                if self.currentIndex >= self.previewPhotoArray.count-1 {
                    self.currentIndex = self.previewPhotoArray.count-1
                }
                self.setNavTitle(title: "\(self.currentIndex+1)/\(self.previewPhotoArray.count)")
                if self.deleteClicked != nil {
                    self.deleteClicked!(self.previewPhotoArray, deleteIndex)
                }
                if self.previewPhotoArray.count == 0 {
                    self.navigationController!.popViewController(animated: true)
                }
            })
            deleteAlert.addAction(deleteAction)
            self.navigationController?.present(deleteAlert, animated: true, completion: nil)
        }
        
        func oneTapClick(tap: UITapGestureRecognizer) {
    //        var moveY = -ZYNavigationTotalHeight
    //        if self.naviView.frame.origin.y < 0 {
    //            moveY = 0
    //        }
    //        let isStatusBarHidden = UIApplication.shared.isStatusBarHidden
    //        UIApplication.shared.setStatusBarHidden(!isStatusBarHidden, with: .slide)
    //        UIView.animate(withDuration: 0.25) {
    //            self.naviView.frame.origin.y = CGFloat(moveY)
    //        }
        }
        
        // MARK:- delegate
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.previewPhotoArray.count
        }
        
        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! LcPreviewCollectionViewCell
            let photoTuple: LcPhotoModel = self.previewPhotoArray[indexPath.row]
            if let originImage = photoTuple.originImage {
                cell.photoImage = originImage
            } else if let imageURL = photoTuple.imageURL {
                if let thumbnailImage = photoTuple.thumbnailImage {
                    cell.photoImage = thumbnailImage
                }
                let loading = UIActivityIndicatorView(style: .whiteLarge)
                loading.center = CGPoint(x: cell.photoImageView.frame.width/2, y: cell.photoImageView.frame.height/2)
                loading.startAnimating()
                cell.photoImageView.addSubview(loading)
                cell.photoImageView.setWebImage(url: imageURL, defaultImage: photoTuple.thumbnailImage, isCache: true, downloadSuccess: { (image: UIImage?) in
                    loading.removeFromSuperview()
                    cell.photoImage = image
                })
            } else {
                cell.photoImage = photoTuple.thumbnailImage
            }
            cell.oneTapClosure = { [unowned self] (tap) in
                self.oneTapClick(tap: tap)
            }
            return cell
        }
        
        public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            (cell as! LcPreviewCollectionViewCell).defaultScale = 1
        }
        
        public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            self.scrollDistance = scrollView.contentOffset.x
        }
        
        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            self.currentIndex = Int(round(scrollView.contentOffset.x/scrollView.bounds.width))
            if self.currentIndex >= self.previewPhotoArray.count {
                self.currentIndex = self.previewPhotoArray.count-1
            } else if self.currentIndex < 0 {
                self.currentIndex = 0
            }
            self.setNavTitle(title: "\(self.currentIndex+1)/\(self.previewPhotoArray.count)")
        }
    

}
