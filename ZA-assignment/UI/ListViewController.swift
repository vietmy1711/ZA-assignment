//
//  ListViewController.swift
//  ZA-assignment
//
//  Created by VinBrain on 15/04/2022.
//

import UIKit

class ListViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    weak var rightBarButton: UIBarButtonItem! {
        return UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(onLogoutClicked))
    }
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var viewModel = ListViewModel(delegate: self)
    
    private var photoModels: [PhotoModel] = [] {
        didSet {
            if photoModels.count > 0 {
                tableView.isHidden = false
            } else {
                tableView.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.getPhotos()
    }
    
    func setupViews() {
        self.title = "Gallery"
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: PhotoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PhotoTableViewCell.identifier)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
    }
    
    
    @objc func refreshData() {
        self.refreshControl.beginRefreshing()
        viewModel.getPhotos(forceRefresh: true)
        
    }
    
    @objc func onLogoutClicked() {
        viewModel.logout()
    }
    
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath)            as? PhotoTableViewCell {
            cell.photoModel = photoModels[indexPath.row]
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        }
        return PhotoTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photoModels.count
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= 10.0 {
            self.viewModel.getPhotos()
        }
    }
}

//MARK: PhotoTableViewCellDelegate
extension ListViewController: PhotoTableViewCellDelegate {
    func didTapLikeButton(index: Int) {
        viewModel.likePhoto(photoModel: photoModels[index])
    }
}

//MARK: ListViewDelegate
extension ListViewController: ListViewDelegate {
    func didLikePhoto(photoModel: PhotoModel) {
        DispatchQueue.main.async { [weak self] in
            if let index = self?.photoModels.firstIndex(where: { e in
                e.id == photoModel.id
            }) {
                self?.photoModels[index] = photoModel
                self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: UITableView.RowAnimation.none)
            }
        }
    }
    
    func didLikePhotoFailed(error: ErrorType) {
        DispatchQueue.main.async { [weak self] in
            self?.showErrorMessage(error)
        }
    }
    
    func didGetPhotosSuccess(photoModels: [PhotoModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.photoModels = photoModels
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    func didGetPhotosFailed(error: ErrorType) {
        DispatchQueue.main.async { [weak self] in
            self?.showErrorMessage(error)
            self?.refreshControl.endRefreshing()
        }
    }
    
    func didLogout() {
        navigationController?.popViewController(animated: true)
    }
    
}
