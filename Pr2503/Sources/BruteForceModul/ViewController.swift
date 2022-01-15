import UIKit

class ViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!

    // MARK: - Pproperties

    private let queue = OperationQueue()

    private var isTealScreen: Bool = false {
        didSet {
            if isTealScreen {
                self.view.backgroundColor = .systemTeal
            } else {
                self.view.backgroundColor = .white
            }
        }
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        modeNotStartCracking()
    }

    // MARK: - Buttons actions

    @IBAction func changeColorButton(_ sender: Any) {
        isTealScreen.toggle()
    }

    @IBAction func generateAndCrackingPassword(_ sender: Any) {

        modeStartCracking()

        // В переменную password передается  значение из textField
        let password = textField.text ?? "0000"

        // Строка с паролем делится на массив из строк по 2 символа
        let splitedPassword = password.split()

        var arrayBruteForcePassword = [BruteForcePassword]()

        // Каждая мини строка из массива отправляется в операцию
        splitedPassword.forEach { i in
            arrayBruteForcePassword.append(BruteForcePassword(password: i))
        }

        // Каждая операция отправляется в очередь
        arrayBruteForcePassword.forEach { operation in
            queue.addOperation(operation)
        }

        queue.addBarrierBlock { [unowned self] in
            OperationQueue.main.addOperation {
                self.modeCompletedCracking()
            }
        }
    }

    // MARK: - Mode functions

    func modeNotStartCracking() {
        label.text = "Нажите кнопку, чтобы сгенирировать и отгадать пароль"
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
        passwordButton.setTitle("Начать", for: .normal)
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    func modeStartCracking() {
        label.text = "Подбирается пароль..."
        textField.text = String.random()
        passwordButton.isEnabled = false
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    func modeCompletedCracking() {
        label.text = "Пароль взломан: \n \(self.textField.text ?? "Error") \n Нажмите кнопку, чтобы попробовать еще раз"
        textField.isSecureTextEntry = false
        passwordButton.isEnabled = true
        passwordButton.setTitle("Начать", for: .normal)
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
