import UIKit

final class NextVC: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .white
        

        
        let textF1 = UITextField()
        textF1.translatesAutoresizingMaskIntoConstraints = false
        textF1.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textF1.borderStyle = .roundedRect
        let textF2 = UITextField()
        textF2.translatesAutoresizingMaskIntoConstraints = false
        textF1.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textF2.borderStyle = .roundedRect

        view.addSubview(textF1)
        view.addSubview(textF2)
        
        NSLayoutConstraint.activate([
            textF1.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textF1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textF2.topAnchor.constraint(equalTo: textF1.bottomAnchor, constant: 2),
            textF2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
