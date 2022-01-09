import UIKit

class ViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!

    // MARK: - Properties

    private var password = ""
    private var isStartCracking = false
    private var isCompletedCracking = false

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
        textField.text = "500" // для рандомной генирации: String.randomString()
        password = textField.text ?? "000"

        isStartCracking = true
        correctionViews()

        if isStartCracking {
            let concurrentQueue = DispatchQueue(label: "сoncurrentQueueForPassword",
                                                qos: .default,
                                                attributes: .concurrent)
            concurrentQueue.async {
                self.bruteForce(passwordToUnlock: self.password)
            }
        }
    }

    // MARK: - Mode functions

    private func modeNotStartCracking() {
        isCompletedCracking = false
        label.text = "Нажите кнопку, чтобы сгенирировать и отгадать пароль"
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
        passwordButton.setTitle("Начать", for: .normal)
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    private func modeStartCracking() {
        isCompletedCracking = false
        passwordButton.isEnabled = false
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    private func modeCompletedCracking() {
        isCompletedCracking = true
        isStartCracking = false
        passwordButton.isEnabled = true
        passwordButton.setTitle("Начать", for: .normal)
        textField.isSecureTextEntry = false
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    // MARK: - Setup mode functions

    private func correctionViews() {
        if isStartCracking && !isCompletedCracking {
            modeStartCracking()
        } else {
            modeNotStartCracking()
        }
    }

    private func passwordTracking(password: String) {

        if self.password == password {
            label.text = "Пароль взломан: \(password) Нажмите кнопку, чтобы попробовать еще раз"
            modeCompletedCracking()
        }

        if isStartCracking {
            label.text = "Подбирается пароль: \n \(password)"
            correctionViews()
        }
    }

    // MARK: - Cracking password functions

    func bruteForce(passwordToUnlock: String) {
        let allowedCharacters: [String] = String().printable.map { String($0) }
        var password: String = ""

        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: allowedCharacters)
            print(password)

            DispatchQueue.main.async {
                self.passwordTracking(password: password)
            }
        }
        print("Пароль взломан: \(password)")
    }

    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var password = string

        if password.count <= 0 {
            password.append(characterAt(index: 0, array))
        }
        else {
            password.replace(at: password.count - 1, with: characterAt(index: (indexOf(character: password.last ?? "1", array) + 1) % array.count, array))

            if indexOf(character: password.last ?? "1", array) == 0 {
                password = String(generateBruteForce(String(password.dropLast()), fromArray: array)) + String(password.last ?? "1")
            }
        }
        return password
    }

    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character)) ?? Int()
    }

    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
        : Character("")
    }
}
