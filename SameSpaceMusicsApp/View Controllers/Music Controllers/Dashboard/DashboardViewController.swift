//
//  DashboardViewController.swift
//  SameSpaceMusicsApp
//
//  Created by Rahul Vishwakarma on 18/01/24.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var labelSongsName: UILabel!
    @IBOutlet weak var viewMusicPauseConaitner: UIView!
    @IBOutlet weak var imageCoverMusic: UIImageView!
    @IBOutlet weak var imagePause: UIImageView!
    
    var isFirstTimeViewDidAppear = true
    let musicStoryBoard = "MusicStoryBoard"
    var musicControlVC: MusicControlViewController?
    var musicControlVCTopPicks: MusicControlViewController?
    
    //--------------Bottom Menu Collection View--------------
    
    var menus = ["For You", "Top Tracks"]
    let cellIdentifier = "CollectionViewMenuCell"
    var selectedIndex = 0
    
    //-----------------Page View Controller----------------
    
    var pageViewController: UIPageViewController!
    var controllers = [UIViewController]()
    var oldIndex = 0
    
    //------------------------------------------------------
    
    @IBOutlet weak var viewPageControllerContainer: UIView!
    @IBOutlet weak var collectionViewMenu: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewSetuUp()
        addControllers()
        
        openMusicPlayer()
        addGesture()
        bindData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if isFirstTimeViewDidAppear {
            pageViewControllerSetUp()
            collectionViewMenu.addShadow(location: .top)
            imageCoverMusic.layer.cornerRadius = imageCoverMusic.frame.width/2
        }
    }
    
    
    
    
    func bindData() {
        
        viewMusicPauseConaitner.isHidden = true
        MusicControllAVPlayer.shared.isMusicStillPlaying = { [self] image, songsName, status, color in
            
            if status {
                
                viewMusicPauseConaitner.isHidden = false
                viewMusicPauseConaitner.backgroundColor = color
                imageCoverMusic.image = image
                labelSongsName.text = songsName
                
                
            } else {
                
                viewMusicPauseConaitner.isHidden = true
                
            }
        }
        
        MusicControllAVPlayer.shared.didFinishPlayingDash = { [weak self] in
            guard let self = self else { return }
            viewMusicPauseConaitner.isHidden = true
        }
    }
    
    
    func addGesture() {
        let pauseTapGesture = UITapGestureRecognizer(target: self, action: #selector(pauseTap))
        imagePause.isUserInteractionEnabled = true
        imagePause.addGestureRecognizer(pauseTapGesture)
        
        
        let swipUp = UISwipeGestureRecognizer(target: self, action: #selector(swipUpScrolled))
        swipUp.direction = .up
        
        viewMusicPauseConaitner.addGestureRecognizer(swipUp)
    }
    
    @objc func swipUpScrolled() {
        
        if musicControlVC != nil {
            self.present(musicControlVC!, animated: true)
        }
    }
    
    @objc func pauseTap() {
        MusicControllAVPlayer.shared.pause()
        
        UIView.animate(withDuration: 0.6) {
            self.viewMusicPauseConaitner.isHidden = true
        }
    }
    
    
    func addControllers() {
        
        let storyBoard = UIStoryboard(name: musicStoryBoard, bundle: nil)
        guard let forYouController = storyBoard.instantiateViewController(withIdentifier: MusicListViewController.identifier) as? MusicListViewController else { return }
        
        guard let topPicksViewController = storyBoard.instantiateViewController(withIdentifier: MusicListViewController.identifier) as? MusicListViewController else { return }
        topPicksViewController.istopTrack = true
        
        controllers.append(contentsOf: [forYouController, topPicksViewController])
    }
    
    func pageViewControllerSetUp() {
        
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.viewPageControllerContainer.addSubview(pageViewController.view)
        pageViewController.view.frame = self.viewPageControllerContainer.bounds
        
        addChild(pageViewController)
        didMove(toParent: pageViewController)
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        pageLoad(index: 0)
    }
    
    func pageLoad(index: Int) {
        
        guard index < controllers.count else { return }
        pageViewController.setViewControllers([controllers[index]], direction: selectedIndex < oldIndex ? .reverse : .forward, animated: true)
        
        oldIndex = selectedIndex
    }
    
    func collectionViewSetuUp() {
        collectionViewMenu.delegate = self
        collectionViewMenu.dataSource = self
    }
    
    
    func openMusicPlayer() {
   
        let storyBoard = UIStoryboard(name: musicStoryBoard, bundle: nil)
        
        if musicControlVC == nil {
            musicControlVC = storyBoard.instantiateViewController(withIdentifier: MusicControlViewController.identifier) as? MusicControlViewController
            
        }
        
        if musicControlVCTopPicks == nil {
            musicControlVCTopPicks = storyBoard.instantiateViewController(withIdentifier: MusicControlViewController.identifier) as? MusicControlViewController
        }
        
        guard let musicControlVC = musicControlVC else { return }
        guard let musicControlVCTopPicks = musicControlVCTopPicks else { return }
        
        musicControlVC.modalPresentationStyle = .overFullScreen
        musicControlVC.modalTransitionStyle = .coverVertical
        
        CommonData.shared.openMusicPlayer = { musicModelArray, index, isTopPicks in
            
            if isTopPicks {
                musicControlVCTopPicks.musicModelElementArray = musicModelArray
                musicControlVCTopPicks.currentIndex = index
                self.present(musicControlVCTopPicks, animated: true)
                
            } else {
                musicControlVC.musicModelElementArray = musicModelArray
                musicControlVC.currentIndex = index
                self.present(musicControlVC, animated: true)
            }
            
            
        }
    }
}


extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CollectionViewMenuCell else { return UICollectionViewCell() }
        
        cell.configureCell(menus[indexPath.row], selectedIndex, indexPath)
        
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width - 10) / 2, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        pageLoad(index: selectedIndex)
        collectionViewMenu.reloadData()
    }
}



extension DashboardViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let indexOf = controllers.firstIndex(of: viewController) else { return nil }
        
        return indexOf > 0 ? controllers[indexOf - 1] : nil
        
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        guard let indexOf = controllers.firstIndex(of: viewController) else { return nil }
        
        return indexOf < controllers.count - 1 ? controllers[indexOf + 1] : nil
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            
            if let currentPage = pageViewController.viewControllers?.last {
                
                if let index = controllers.firstIndex(of: currentPage) {
                    
                    oldIndex = index
                    selectedIndex = index
                    
                    collectionViewMenu.reloadData()
                    
                }
                
            }
            
        }
    }
}
