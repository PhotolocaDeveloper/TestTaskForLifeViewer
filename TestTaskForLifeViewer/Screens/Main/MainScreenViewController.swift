import UIKit

final class MainScreenViewController: UIViewController {
    private let contentView = MainScreenView()
    private let viewModel = MainScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        contentView.widgetsCollectionView.register(PhotoWidgetCell.self, forCellWithReuseIdentifier: PhotoWidgetCell.cellId)
        contentView.widgetsCollectionView.delegate = self
        contentView.widgetsCollectionView.dataSource = self
        contentView.widgetsCollectionView.reloadData()
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
}

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoWidgetCell.cellId, for: indexPath) as? PhotoWidgetCell else {fatalError()}
        return cell
    }
}
