//
//  BusinessDetailViewController.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 31/01/23.
//

import UIKit

class BusinessDetailViewController: UIViewController {
    private let tableView: UITableView = UITableView()
    var tableViewDataSource: DefaultTableViewDataSource?
    let viewModel: BusinessesDetailViewModelType
    init(viewModel: BusinessesDetailViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.title = viewModel.name
        setupView()
        viewModel.getDetail()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {

        self.tableViewDataSource = DefaultTableViewDataSource(
            tableView: tableView,
            tableViewModelDelegate: self,
            mapCellViewModelDelegate: self,
            registerCellDelegate: self
        )
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.estimatedRowHeight = 2
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

extension BusinessDetailViewController: GetListViewModelProtocol {
    func listViewModel() -> ListViewModelProtocol {
        self.viewModel
    }
}
extension BusinessDetailViewController: MapCellViewModel {
    func identifierFor(itemViewModel: ItemViewModelProtocol) -> String {
        switch itemViewModel {
        case is ImageLibCellViewModel:
            return ImagesTableViewCell.reuseIdentifier()
        case is OpenHoursFirstCellViewModel:
            return HeadingSubheadingWithAccessory.reuseIdentifier()
        case is HeadingSubHeadingCellViewModel:
            return HeadingSubheadingWithAccessory.reuseIdentifier()
        case is LoaderTableViewCellViewModel:
            return LoaderTableViewCell.reuseIdentifier()
        default:
            Logger.log(itemViewModel.self)
            return ""
        }
    }
    
    
}
extension BusinessDetailViewController: RegisterCellProtocol {
    func registerCell() {
        let tableViewCells: [TableViewCell.Type] = [HeadingSubheadingWithAccessory.self, LoaderTableViewCell.self, ImagesTableViewCell.self]
        
        for tableViewCell in tableViewCells {
            self.tableView.register(tableViewCell, forCellReuseIdentifier: tableViewCell.reuseIdentifier())
        }
    }
}

extension BusinessDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.itemClicked(at: indexPath)
    }
}
