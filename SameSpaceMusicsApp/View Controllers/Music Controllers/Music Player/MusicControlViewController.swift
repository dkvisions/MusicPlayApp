//
//  MusicControlViewController.swift
//  SameSpaceMusicsApp
//
//  Created by Rahul Vishwakarma on 20/01/24.
//

import UIKit
import FSPagerView

class MusicControlViewController: UIViewController {
    
    
    var musicControlViewModel: MusicControlViewModel!
    
    
    let gradient: CAGradientLayer = CAGradientLayer()
    
    let sharedAv = MusicControllAVPlayer.shared
    
    var currentColor = UIColor()
    var currentImage = UIImage()
    
    var playingMusicIndex = -1
    
    var timer: Timer?
    
    var isPlayButton = true
    var imagePlayName = "play"
    var imagePauseName = "pause"
    var isMusicPlaying = false
    
    //------------
    var musicModelElementArray: [MusicModelElement]!
    var currentIndex = 0
    //-------------;
    
    var isFirstTimeViewDidAppear = true
    let sharedCommonObj = CommonData.shared
    
    @IBOutlet weak var pagerContainerView: UIView!
    
    @IBOutlet weak var topStack: UIStackView!
    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    
    @IBOutlet weak var viewProgressContainer: UIView!
    @IBOutlet weak var WidthOfProgressView: NSLayoutConstraint!
    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var curentTime: UILabel!
    @IBOutlet weak var labelLastPlayTime: UILabel!
    
    
    @IBOutlet weak var imagePrivious: UIImageView!
    @IBOutlet weak var imagePlayPause: UIImageView!
    @IBOutlet weak var imageNext: UIImageView!
    
    //------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        musicControlViewModel = MusicControlViewModel()
        addSwipDownGeture()
        addGestures()
        bindViewModel()
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTimeViewDidAppear {
            isFirstTimeViewDidAppear = false
            setupFSPagerView()
            setUpUI()
            
        } else if playingMusicIndex != currentIndex {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600)) { [self] in
                pagerView.scrollToItem(at: currentIndex, animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(800)) { [self] in
                    getSetColor(index: currentIndex)
                }
 
            }
            setUpUI()
        }
        
        if isMusicPlaying {
            labelLastPlayTime.text = sharedAv.getDuration()
        }
    }
    
    
    //---------
    
    func setUpUI() {
    
        let data = musicModelElementArray[currentIndex]
        labelTitle.text = data.name
        labelDescription.text = data.artist
        fetchMusic(index: currentIndex)
    }
    //------------------------------------------
    func addGestures() {
        
        let playPauseTap = UITapGestureRecognizer(target: self, action: #selector(playPauseTap))
        imagePlayPause.isUserInteractionEnabled = true
        imagePlayPause.addGestureRecognizer(playPauseTap)
        
        let backPress = UITapGestureRecognizer(target: self, action: #selector(backPress))
        imagePrivious.isUserInteractionEnabled = true
        imagePrivious.addGestureRecognizer(backPress)
        
        
        let nextPress = UITapGestureRecognizer(target: self, action: #selector(nextPress))
        imageNext.isUserInteractionEnabled = true
        imageNext.addGestureRecognizer(nextPress)
    }
    
    func addSwipDownGeture() {

        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissController))
        gesture.direction = .down
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(gesture)
    }
    
    //----------------------------------------------------

    @objc func dismissController() {
        
        let transition: CATransition = CATransition()
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window!.layer.add(transition, forKey: nil)

        
        if isPlayButton {
            MusicControllAVPlayer.shared.isMusicStillPlaying(currentImage, labelTitle.text ?? "", true, currentColor)
        } else {
            MusicControllAVPlayer.shared.isMusicStillPlaying(currentImage, labelTitle.text ?? "", false, currentColor)
        }
        resetTimer()
        self.dismiss(animated: true)
    }
    
    @objc func playPauseTap() {
        
        guard isMusicPlaying else { return }
        isPlayButton.toggle()
        
        print(isPlayButton)
        imagePlayPause.image = UIImage(named: isPlayButton ? imagePauseName : imagePlayName)
        isPlayButton ? sharedAv.play() : sharedAv.pause()
        
        resetTimer(isStart: false)
    }
    
    func playButtonState(playState: Bool) {
        isPlayButton = playState
        imagePlayPause.image = UIImage(named: isPlayButton ? imagePauseName : imagePlayName)
    }
    
    @objc func backPress() {
        
        guard musicModelElementArray.count > 0 else { return }
        
        sharedAv.pause()
        let preIndex = currentIndex > 0 ? currentIndex - 1 : musicModelElementArray.count - 1
        currentIndex = preIndex
        self.pagerView.scrollToItem(at: preIndex, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [self] in
            getSetColor(index: currentIndex)
        }
        setUpUI()
        resetTimer()
    }
    
    @objc func nextPress() {
        
        guard musicModelElementArray.count > 0 else { return }
        sharedAv.pause()

        let nextIndex = currentIndex < musicModelElementArray.count - 1 ? currentIndex + 1 : 0
        currentIndex = nextIndex
        self.pagerView.scrollToItem(at: nextIndex, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [self] in
            getSetColor(index: currentIndex)
        }
        setUpUI()
        resetTimer()
    }

    //------------------------------------------
    
    
    func setupFSPagerView() {
        
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.itemSize = CGSize(width: pagerView.frame.width - 80, height: pagerView.frame.height - 10)
        pagerView.isInfinite = false
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
    
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [self] in
            pagerView.scrollToItem(at: currentIndex, animated: false)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(800)) { [self] in
                getSetColor(index: currentIndex)
            }
        }
    
        //
    }
    //------------------------------------------
    func fetchMusic(index: Int) {
        musicControlViewModel.fetchMusic(url: musicModelElementArray[index].url)
    }
    
    func bindViewModel() {
        
        musicControlViewModel.bind = { [self] status in
            
            switch status {
            case .loading:
                
                isMusicPlaying = false
                playButtonState(playState: false)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    sharedCommonObj.addActivity(view: self.view)
                }
            case .success:
                
                sharedCommonObj.removeActivity()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(400)) { [weak self] in
                    
                    guard let self = self else { return }
                    sharedCommonObj.removeActivity()
                    playMusicAv(path: musicControlViewModel.filePath)
                    print(musicControlViewModel.filePath)
                }
                
            case .failed(_):
                DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(400)) { [self] in
                    sharedCommonObj.removeActivity()
                    
                    resetTimer()
                }
                
            }
        }
        
        MusicControllAVPlayer.shared.didFinishPlaying = { [self] _ in
            self.playButtonState(playState: false)
            resetTimer()
            
            if isMusicPlaying {
                curentTime.text = sharedAv.getDuration()
                labelLastPlayTime.text = sharedAv.getDuration()
            }
        }
    }
    
    
    func playMusicAv(path: String) {
        
        do {
            let duration = try MusicControllAVPlayer.shared.startMusicAvPlayer(path: path)
            curentTime.text = "0:0"
            labelLastPlayTime.text = duration
            isMusicPlaying = true
            playButtonState(playState: true)
            playingMusicIndex = currentIndex
            calcProgressWidth()
            
        } catch {
            isMusicPlaying = false
            playButtonState(playState: false)
        }
        
    }
    
    
    func calcProgressWidth() {
        
        let widhContainer = viewProgressContainer.frame.width
        let totalDuration = sharedAv.avPlayer.duration
        
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timerCurrent in
            guard let self = self else { return }
            let currentDuration = sharedAv.avPlayer.currentTime
            let percentageDuration = currentDuration * 100 / totalDuration
            WidthOfProgressView.constant = widhContainer * percentageDuration / 100
           
            timer = timerCurrent
            curentTime.text = sharedAv.getDuration(currenTime: true)
        }
    }
    
    func resetTimer(isStart: Bool = true) {
        
        if isStart {
            
            timer?.invalidate()
            curentTime.text = "0:0"
            labelLastPlayTime.text = "0:0"
            timer = nil
            
        } else {
        
            if isPlayButton {
                calcProgressWidth()
            } else {
                timer?.invalidate()
            }
        }
        
        
    }
}


extension MusicControlViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        musicModelElementArray.count
    }
    

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        configureFSPagerCell(cell, musicModelElementArray[index])
        return cell
    }
    
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
       
        currentIndex = pagerView.currentIndex
        sharedAv.pause()
        
        resetTimer()
        setUpUI()
        
        getSetColor(index: currentIndex)
        
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
    }
    //-------------------------------------------------------------------------------
    
    private func configureFSPagerCell(_ cell: FSPagerViewCell, _ data: MusicModelElement) {
        
        let urlString = "\(RequestUrls.baseUrl)\(RequestUrls.coverImage.rawValue)\(data.cover)"
        cell.imageView?.sd_setImage(with: URL(string: urlString))
        cell.imageView?.contentMode = .scaleToFill
    
    }
}



extension MusicControlViewController {
    
    func getSetColor(index: Int) {
        
        gradient.removeFromSuperlayer()

        let cell = pagerView.cellForItem(at: index)
        
        if let imageView = cell?.imageView, let image = imageView.image {
           
            if let color1 = image.getPixelColor(pos: CGPoint(x: 5, y: 5)) {
                
                currentColor = color1
                currentImage = image
                if
                    let color2 = image.getPixelColor(pos: CGPoint(x: imageView.frame.width - 5, y: imageView.frame.height - 5)) {
                    
                    gradient.colors = [color1.cgColor, color2.withAlphaComponent(0.4).cgColor]
                    gradient.locations = [0.0 , 1.0]
                    gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
                    gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
                    gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)

                    self.view.layer.insertSublayer(gradient, at: 0)
                }
            }
        }
    }
    
}



