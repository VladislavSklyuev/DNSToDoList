import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let todoService = CoreDataManager(coreDataStack: CoreDataStack())
        let todoRepository = ToDosRepository(todoService: todoService)
        let viewModel = ToDosViewModel(toDoRepository: todoRepository)
        
        let todosVC = MainViewController()
        todosVC.viewModel = viewModel

        window?.rootViewController = todosVC
        window?.makeKeyAndVisible()
    }
}
