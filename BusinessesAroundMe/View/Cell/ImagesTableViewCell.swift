//
//  ImagesTableViewCell.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 31/01/23.
//

import UIKit

class ImagesTableViewCell: TableViewCell {

    
    static let collectionViewCellSize = {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: width / 1.5)

    }()
    private let pageControl: UIPageControl = UIPageControl()
    private var pageControlWidth: NSLayoutConstraint?
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = collectionViewCellSize
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        return cv
    }()
    private var viewModel: ListViewModelProtocol = ImageLibCellViewModel(sections: [])
    private var dataSource: DefaultCollectionViewDataSource?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setupPageControl() {
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor =  .color(from: .secondaryBackground)
        self.pageControl.currentPageIndicatorTintColor =  .color(from: .secondaryLabel)
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.backgroundColor = .color(from: .background)?.withAlphaComponent(0.5)
        self.pageControl.layer.cornerRadius = 5
        self.pageControl.clipsToBounds = true
        self.contentView.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            pageControl.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
    }
    fileprivate func setupCollectionView() {
        self.contentView.addSubview(collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.delegate = self
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: ImagesTableViewCell.collectionViewCellSize.height)
        ])
        
    }
    
    func setupView() {
        setupCollectionView()
        setupPageControl()
    }
}
extension ImagesTableViewCell: GetListViewModelProtocol {
    func listViewModel() -> ListViewModelProtocol {
        self.viewModel
    }
}
extension ImagesTableViewCell: MapCellViewModel {
    func identifierFor(itemViewModel: ItemViewModelProtocol) -> String {
        switch itemViewModel {
        case is ImageCellViewModelType:
            return ImageCollectionViewCell.reuseIdentifier()
        default:
            Logger.log(itemViewModel.self)
            return "\(itemViewModel.self)"
        }
    }
    
    
}
extension ImagesTableViewCell: RegisterCellProtocol {
    func registerCell() {
        let cells: [CollectionViewCell.Type] = [ImageCollectionViewCell.self]

        for cell in cells {
            self.collectionView.register(cell, forCellWithReuseIdentifier: cell.reuseIdentifier())
        }
    }
}
extension ImagesTableViewCell: ItemViewProtocol {
    func updateView(itemViewModel: ItemViewModelProtocol) {
        if let viewModel = itemViewModel as? ImageLibCellViewModel {
            self.viewModel = viewModel
            self.pageControl.numberOfPages = viewModel.numberOfSection()
            self.dataSource = .init(collectionView: collectionView, tableViewModelDelegate: self, mapCellViewModelDelegate: self, registerCellDelegate: self)
        }
    }
}

extension ImagesTableViewCell: UICollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}
