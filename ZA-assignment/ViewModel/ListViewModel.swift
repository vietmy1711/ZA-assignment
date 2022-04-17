//
//  ListViewModel.swift
//  ZA-assignment
//
//  Created by VinBrain on 15/04/2022.
//

import UIKit

protocol ListViewDelegate: AnyObject {
    func didGetPhotosSuccess(photoModels: [PhotoModel])
    func didGetPhotosFailed(error: ErrorType)
    func didLikePhoto(photoModel: PhotoModel)
    func didLikePhotoFailed(error: ErrorType)
    func didLogout()
}

class ListViewModel {
    
    // MARK: - Properties
    
    weak var delegate: ListViewDelegate?
    var photoModels: [PhotoModel] = []
    
    private var hasReachedMax = false
    private var isFetching = false
    private var page = 0
    private let perPage = 20
    private let orderBy = "popular"
    
    init(delegate: ListViewDelegate) {
        self.delegate = delegate
    }
    
    func getPhotos(forceRefresh: Bool = false) {
        if (forceRefresh) {
            page = 0
            hasReachedMax = false
            AppCache.shared.empty()
        }
        guard !hasReachedMax, !isFetching else { return }
        page += 1
        isFetching = true
        PhotoRepository.shared.getPhotos(page: page, perPage: perPage, orderBy: orderBy) {  [weak self] newPhotoModels, errType in
            self?.isFetching = false
            guard let self = self else { return }
            guard errType == nil else {
                self.delegate?.didGetPhotosFailed(error: errType ?? .fetchingUnknown)
                return
            }
            self.hasReachedMax = (newPhotoModels ?? []).count <  self.perPage
            self.photoModels.append(contentsOf: (newPhotoModels ?? []))
            self.delegate?.didGetPhotosSuccess(photoModels: self.photoModels)
        }
    }
    
    func likePhoto(photoModel: PhotoModel) {
        self.delegate?.didLikePhoto(photoModel: photoModel.copy(with: !photoModel.isLiked))
        PhotoRepository.shared.likePhoto(id: photoModel.id, like: !photoModel.isLiked) { [weak self] _, errType in
            guard let self = self else { return }
            guard errType == nil else {
                self.delegate?.didLikePhoto(photoModel: photoModel)
                self.delegate?.didLikePhotoFailed(error: errType ?? .fetchingUnknown)
                return
            }
        }
    }
    
    func logout() {
        AuthRepository.shared.logOut()
        delegate?.didLogout()
    }
}
