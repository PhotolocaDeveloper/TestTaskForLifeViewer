import UIKit
import RxSwift
import RxCocoa

final class MainScreenViewController: UIViewController {
    let contentView = MainScreenView()
    let viewModel = MainScreenViewModel()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        contentView.widgetsCollectionView.delegate = self
        contentView.widgetsCollectionView.dataSource = self
        contentView.widgetsCollectionView.reloadData()
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
}
