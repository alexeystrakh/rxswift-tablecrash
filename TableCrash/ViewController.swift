//
//  ViewController.swift
//  TableCrash
//
//  Created by Alexey Strakh on 4/10/23.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var viewModel = MyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        refreshPeriodically()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadData()
    }
    
    private func bindData() {
        viewModel.itemList.bind(to: tableView.rx.items) { table, index, item in
            if item.type == "type1" {
                if let cell1 = table.dequeueReusableCell(withIdentifier: "MyItemCell1") as? MyItemCell1 {
                    cell1.bindItem(item)
                    return cell1
                }
            } else if item.type == "type2" {
                if let cell2 = table.dequeueReusableCell(withIdentifier: "MyItemCell2") as? MyItemCell2 {
                    cell2.bindItem(item)
                    return cell2
                }
            }
            return UITableViewCell()
        }.disposed(by: viewModel.disposeBag)
    }
    
    // !NOTE: this is just for testing purposes, in real app the loadData method is called on every page appearance after navigation forward, back, app activation)
    private func refreshPeriodically() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.viewModel.loadData()
            self?.refreshPeriodically()
        }
    }
}

class MyViewModel {
    var disposeBag = DisposeBag()
    var itemList = BehaviorRelay(value: [MyItem]())
    
    func loadData() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            var items = [MyItem]()
            for i in 0...100 {
                items.append(
                    MyItem(id: "id\(i)",
                           name: "name\(i) \(Date())",
                           type: i%3 == 0 ? "type1":"type2"))
            }
            
            DispatchQueue.main.async {
                self?.itemList.accept(items)
            }
        }
    }
}

class MyItemCell1: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    func bindItem(_ item: MyItem) {
        label.text = item.name
    }
}

class MyItemCell2: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    func bindItem(_ item: MyItem) {
        label.text = item.name
    }
}

struct MyItem {
    var id: String?
    var name: String?
    var type: String?
}
