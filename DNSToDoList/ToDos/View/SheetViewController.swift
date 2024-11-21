import UIKit

class SheetViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Добавьте элементы интерфейса на ваш контроллер
        let label = UILabel()
        label.text = "Добавьте новую задачу"
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let textF1 = UITextField()
        textF1.translatesAutoresizingMaskIntoConstraints = false
        textF1.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textF1.borderStyle = .roundedRect
        let textF2 = UITextField()
        textF2.translatesAutoresizingMaskIntoConstraints = false
        textF1.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textF2.borderStyle = .roundedRect
        
        
        view.addSubview(label)
        view.addSubview(textF1)
        view.addSubview(textF2)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textF1.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textF1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textF2.topAnchor.constraint(equalTo: textF1.bottomAnchor, constant: 2),
            textF2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
