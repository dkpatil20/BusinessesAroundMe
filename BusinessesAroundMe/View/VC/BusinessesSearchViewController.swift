//
//  BusinessesSearchViewController.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 26/01/23.
//

import UIKit

class BusinessesSearchViewController: UIViewController {

    private let tableView: UITableView = UITableView()
    var tableViewDataSource: DefaultTableViewDataSource?
    let viewModel: BusinessesSearchViewModelType
    init(viewModel: BusinessesSearchViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        // Do any additional setup after loading the view.
        self.title = "Businesses"
        self.setupView()
        self.viewModel.searchBusiness()
    }
    
    func setupView() {

        self.tableViewDataSource = DefaultTableViewDataSource(
            tableView: tableView,
            tableViewModelDelegate: self,
            mapCellViewModelDelegate: self,
            registerCellDelegate: self
        )
        tableView.delegate = self
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

extension BusinessesSearchViewController: GetListViewModelProtocol {
    func listViewModel() -> ListViewModelProtocol {
        self.viewModel
    }
}
extension BusinessesSearchViewController: MapCellViewModel {
    func identifierFor(itemViewModel: ItemViewModelProtocol) -> String {
        switch itemViewModel {
        case is BusinessListViewModel:
            return BusinessListTableViewCell.reuseIdentifier()
        case is LoaderTableViewCellViewModel:
            return LoaderTableViewCell.reuseIdentifier()
        default:
            return ""
        }
    }
    
    
}
extension BusinessesSearchViewController: RegisterCellProtocol {
    func registerCell() {
        let tableViewCells: [TableViewCell.Type] = [BusinessListTableViewCell.self, LoaderTableViewCell.self]
        
        for tableViewCell in tableViewCells {
            self.tableView.register(tableViewCell, forCellReuseIdentifier: tableViewCell.reuseIdentifier())
        }
    }
}
extension BusinessesSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel.itemAt(indexPath: indexPath) as? BusinessListViewModelType else {
            return
        }
        
        let viewModel = BusinessesDetailViewModel(
            services: BusinessesDetailService(),
            businessId: item.id, businessName: item.name, currentDayOfWeek: Date().dayNumberOfWeek() ?? 1)
        let viewController = BusinessDetailViewController(
            viewModel: viewModel
        )
        self.show(viewController, sender: self)
    }
}
