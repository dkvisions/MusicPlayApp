//
//  MusicListViewController.swift
//  SameSpaceMusicsApp
//
//  Created by Rahul Vishwakarma on 20/01/24.
//

import UIKit
import NVActivityIndicatorView

class MusicListViewController: UIViewController {

    @IBOutlet weak var tableViewMusicLists: UITableView!
    var songsModelElemetArray = [MusicModelElement]()
    var viewModel: MusicViewModel!
    
    var isFirstTimeViewAppeared = true
    var istopTrack = false
    let sharedCommonObj = CommonData.shared
    
    let textNoData = "No data available"
    var labelNoData: UILabel!
    
    let listCellIdentifier = "MusicListTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewSetUp()
        
        viewModel = MusicViewModel()
        bindData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if isFirstTimeViewAppeared {
            viewModel.fetchSong()
            isFirstTimeViewAppeared.toggle()
        }
        
    }
    
    
    func bindData() {
        
        
        viewModel.bindData = { [self] status in
            
            switch status {
            case .loading:
                
                DispatchQueue.main.async { [weak self] in
                    
                    guard let self = self else { return }
                    sharedCommonObj.addActivity(view: self.view)
                }
                
                
            case .success:
                
                sharedCommonObj.removeActivity()
                songsModelElemetArray = viewModel.songsModelElemetArray
                
                
                if istopTrack {
                    songsModelElemetArray = songsModelElemetArray.filter { $0.topTrack == true }
                }
                
                DispatchQueue.main.async { [weak self] in
                    
                    guard let self = self else { return }
                    tableViewMusicLists.reloadData()
                }
                
            case .failed(_):
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(400)) { [self] in
                    addNoDataLabel()
                    sharedCommonObj.removeActivity()
                }
                
                
            }
            
        }
    }
    
    func addNoDataLabel() {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            labelNoData = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
            view.addSubview(labelNoData)
            sharedCommonObj.addCenterConstraints(labelNoData, self.view)
        }
        
        
    }
    
    func tableViewSetUp() {
        
        let xibCell = UINib(nibName: listCellIdentifier, bundle: nil)
        tableViewMusicLists.register(xibCell, forCellReuseIdentifier: listCellIdentifier)
        
        tableViewMusicLists.delegate = self
        tableViewMusicLists.dataSource = self
        
    }
    
    func playMusic(index: Int) {
        CommonData.shared.openMusicPlayer(songsModelElemetArray, index, istopTrack)
        
    }
}

extension MusicListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songsModelElemetArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: listCellIdentifier) as? MusicListTableViewCell else { return UITableViewCell() }
    
        cell.configureCell(data: songsModelElemetArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playMusic(index: indexPath.row)
    }
    
}
