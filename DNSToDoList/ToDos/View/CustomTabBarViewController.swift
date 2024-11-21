import UIKit

//final class CustomTabBarViewController: UITabBarController {
//    
//    // TODO: -> Меньше шрифт
//    @Autolayout private var centerLabelOnTabBar: UILabel = {
//        // TODO: -> Кол-во задач реальное
//        $0.text = "7 задач"
//        $0.textColor = .white
//        return $0
//    }(UILabel())
//    
//    @Autolayout private var addNoteButton: UIButton = {
//        $0.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
//        $0.tintColor = .yellow
//        return $0
//    }(UIButton())
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .black
//        addActions()
//        setTabs()
//        setupConstraints()
//    }
//    
//    private func setTabs() {
//        let mainVC = MainViewController()
//        setViewControllers([mainVC], animated: false)
//    }
//    
//    private func addActions() {
//        addNoteButton.addTarget(self, action: #selector(addNewTodo), for: .touchUpInside)
//    }
//    
//    private func setupConstraints() {
//        tabBar.addSubview(centerLabelOnTabBar)
//        tabBar.addSubview(addNoteButton)
//        
//        NSLayoutConstraint.activate([
//            centerLabelOnTabBar.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
//            centerLabelOnTabBar.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: 10),
//            
//            addNoteButton.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor, constant: -20),
//            addNoteButton.centerYAnchor.constraint(equalTo: centerLabelOnTabBar.centerYAnchor)
//        ])
//    }
//    
//    @objc private func addNewTodo() {
//        let next = NextVC()
//        navigationController?.pushViewController(next, animated: true)
//    }
//
////    func setPageIndex(index: Int) {
////        selectedIndex = index
////        messageVC.tabBarItem.badgeValue = nil
////    }
//}
