//
//  EmojiconViewController.swift
//  emojiKeyboard
//
//  Created by Jia Liu on 8/11/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit


private let emojiconCell = "emojiconCell"

class EmojiconViewController: UIViewController {
    
    //MARK:- properties
    var emojiconCallback: ((emojicon: Emojicon) -> ())?

    //MARK:- lazy load variables
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: EmojiconViewControllerLayout())
    private lazy var toolBar: UIToolbar = UIToolbar()
    private lazy var manager: EmojiconManager = EmojiconManager()
    
    //MARK:- system callbacks
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK:- init
    init(emojiconCallback: (emojicon: Emojicon) -> ()) {
        super.init(nibName: nil, bundle: nil)
        self.emojiconCallback = emojiconCallback
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK:- UI setup
extension EmojiconViewController {
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        collectionView.backgroundColor = UIColor.clearColor()
        toolBar.tintColor = UIColor.orangeColor()
        
        //set frame using VFL
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["toolBar": toolBar, "collectionView": collectionView]
        var cons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-[toolBar]-0-|", options: [.AlignAllLeft, .AlignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
        prepareForCollectionView()
        
        prepareForToolBar()
    }
    
    private func prepareForCollectionView() {
        //register cell
        collectionView.registerClass(EmojiconViewCell.self, forCellWithReuseIdentifier: emojiconCell)
        collectionView.dataSource = self
        
        collectionView.delegate = self
    }
    
    private func prepareForToolBar() {
        //set titles
        let titles = ["Recent", "Default", "emoji" , "浪小花"]
        
        //creat items
        var tempItems: [UIBarButtonItem] = [UIBarButtonItem]()
        var index = 0
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .Plain, target: self, action: #selector(EmojiconViewController.itemClick(_:)))
            item.tag = index
            index += 1
            
            tempItems.append(item)
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil))
        }
        
        tempItems.removeLast()
        toolBar.items = tempItems
    }
}

//MARK:- event listener
extension EmojiconViewController {
    @objc private func itemClick(item: UIBarButtonItem) {
        let tag = item.tag
        let indexPath = NSIndexPath(forItem: 0, inSection: tag)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: true)
    }
}


//MARK:- datasource and delegate
extension EmojiconViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    //datasource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.packages[section].emojicons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(emojiconCell, forIndexPath: indexPath) as! EmojiconViewCell
        
        //setup cell
        let package = manager.packages[indexPath.section]
        let emojicon = package.emojicons[indexPath.item]
        
        cell.emojicon = emojicon
        
        return cell
    }
    
    //delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //get the emojicon
        let package = manager.packages[indexPath.section]
        let emojicon = package.emojicons[indexPath.item]
        
        //put selected emojicon in the recently used package
        insertRecentlyUsedEmojicons(emojicon)
        
        //transfor the seleceted emojicon to outter ViewController
        emojiconCallback!(emojicon: emojicon)
    }
    
    private func insertRecentlyUsedEmojicons(emojicon: Emojicon) {
        if emojicon.isEmpty || emojicon.isRemove {
            return
        }
        
        //delete an exciting emojicon
        if manager.packages.first!.emojicons.contains(emojicon) {
            let index = manager.packages.first!.emojicons.indexOf(emojicon)!
            manager.packages.first!.emojicons.removeAtIndex(index)
        } else {
            manager.packages.first!.emojicons.removeAtIndex(19)
        }
        
        //insert
        manager.packages.first?.emojicons.insert(emojicon, atIndex: 0)
    }
}

//MARK:- customized layout
class EmojiconViewControllerLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        let itemWidth = UIScreen.mainScreen().bounds.width / 7
        
        //set layout
        itemSize = CGSize(width: itemWidth, height: itemWidth)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .Horizontal

        //set collectionView
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        let insertMargin = (collectionView!.bounds.height - 3 * itemWidth) / 2
        //collectionView?.contentInset = UIEdgeInsets(top: insertMargin, left: 0, bottom: insertMargin, right: 0)
    }
}

