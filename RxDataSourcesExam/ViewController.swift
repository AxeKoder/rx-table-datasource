//
//  ViewController.swift
//  RxDataSourcesExam
//
//  Created by Daeho Park on 2023/09/17.
//

import UIKit
import RxSwift
import RxDataSources

struct MyModel {
    var message: String
    var isDone: Bool = false
}

extension MyModel: IdentifiableType, Equatable {
    var identity: String {
        UUID().uuidString
    }
}

struct MySection {
    var headerTitle: String
    var items: [Item]
}

extension MySection: AnimatableSectionModelType {
    typealias Item = MyModel
    
    var identity: String {
        headerTitle
    }
    
    init(original: MySection, items: [MyModel]) {
        self = original
        self.items = items
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var sectionSubject = BehaviorSubject(value: [MySection]())
    var disposeBag = DisposeBag()
    
    var sections = [
        MySection(headerTitle: "첫 번째", items: [MyModel(message: "Lofl"), MyModel(message:"Lofl의 iOS")]),
        MySection(headerTitle: "두 번째", items: [MyModel(message: "Lofl의 iOS앱 개발 알아가기"), MyModel(message:"Lofl의 iOS앱 개발 알아가기\nLofl의 iOS앱 개발 알아가기")]),
        MySection(headerTitle: "3 번째", items: [MyModel(message: "Lofl의 iOS앱 개발 알아가기"), MyModel(message:"Lofl의 iOS앱 개발 알아가기\nLofl의 iOS앱 개발 알아가기")]),
        MySection(headerTitle: "4 번째", items: [MyModel(message: "Lofl의 iOS앱 개발 알아가기"), MyModel(message:"Lofl의 iOS앱 개발 알아가기\nLofl의 iOS앱 개발 알아가기")]),
        MySection(headerTitle: "5 번째", items: [MyModel(message: "Lofl의 iOS앱 개발 알아가기"), MyModel(message:"Lofl의 iOS앱 개발 알아가기\nLofl의 iOS앱 개발 알아가기")]),
        MySection(headerTitle: "6 번째", items: [MyModel(message: "Lofl의 iOS앱 개발 알아가기"), MyModel(message:"Lofl의 iOS앱 개발 알아가기\nLofl의 iOS앱 개발 알아가기")]),
        MySection(headerTitle: "7 번째", items: [MyModel(message: "Lofl의 iOS앱 개발 알아가기\nLofl의 iOS앱 개발 알아가기\nLofl의 iOS앱 개발 알아가기\nLofl의 iOS앱 개발 알아가기")])
    ]
    
    var dataSource = RxTableViewSectionedReloadDataSource<MySection> { dataSource, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identity, for: indexPath) as? MyTableViewCell else { return UITableViewCell() }
        cell.bind(item: item)
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
        setupHeaderSectionTitle()
        bind()
    }
    
    private func setupView() {
        let cellNib = UINib(nibName: MyTableViewCell.identity, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: MyTableViewCell.identity)
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        sectionSubject.onNext(sections)
    }
    
    private func setupHeaderSectionTitle() {
        dataSource.titleForHeaderInSection = { dataSource, index in
            dataSource.sectionModels[index].headerTitle
        }
    }

    private func bind() {
        sectionSubject
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

