import UIKit
import SafariServices

final class ViewController: UIViewController {
  private var rootView: View {
    view as! View
  }
  
  override func loadView() {
    self.view = View()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupInteractions()
  }
  
  func setupInteractions() {
    rootView.didTapSafariButton = { [weak self] in
      guard let self = self, let url = URL(string: self.rootView.inputField.text) else {
        return
      }
      
      let safariVC = SFSafariViewController(url: url)
      self.present(safariVC, animated: true, completion: nil)
    }
    
    rootView.didTapWebViewButton = { [weak self] in
      guard let self = self, let url = URL(string: self.rootView.inputField.text) else {
        return
      }
      
      let viewController = WebViewController(url: url)
      self.present(viewController, animated: true, completion: nil)
    }
  }
}

final class View: UIView {
  let inputField = UITextView()
  let safariButton = UIButton()
  let webViewButton = UIButton()
  
  var didTapSafariButton: (() -> Void)?
  var didTapWebViewButton: (() -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    setup()
    style()
    layout()
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  func setup() {
    addSubview(inputField)
    addSubview(safariButton)
    addSubview(webViewButton)
    
    safariButton.addTarget(self, action: #selector(tappedSafariButton), for: .touchUpInside)
    webViewButton.addTarget(self, action: #selector(tappedWebViewButton), for: .touchUpInside)
  }
  
  func style() {
    backgroundColor = .systemBackground
    
    inputField.layer.borderColor = UIColor.systemGray.cgColor
    inputField.layer.borderWidth = 1
    inputField.text = "https://payment.truelayer-sandbox.com/test-redirect"
    
    safariButton.setTitle("Open Safari", for: .normal)
    safariButton.backgroundColor = .systemBlue
    
    webViewButton.setTitle("Open WebView", for: .normal)
    webViewButton.backgroundColor = .systemPurple
  }
  
  func layout() {
    inputField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      inputField.widthAnchor.constraint(equalToConstant: 250),
      inputField.heightAnchor.constraint(equalToConstant: 100),
      inputField.centerXAnchor.constraint(equalTo: centerXAnchor),
      inputField.centerYAnchor.constraint(equalTo: topAnchor, constant: 150)
    ])
    
    safariButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      safariButton.widthAnchor.constraint(equalToConstant: 160),
      safariButton.heightAnchor.constraint(equalToConstant: 40),
      safariButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      safariButton.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])

    webViewButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      webViewButton.widthAnchor.constraint(equalToConstant: 160),
      webViewButton.heightAnchor.constraint(equalToConstant: 40),
      webViewButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      webViewButton.topAnchor.constraint(equalTo: safariButton.bottomAnchor, constant: 30),
    ])
  }
  
  @objc
  func tappedSafariButton() {
    didTapSafariButton?()
  }
  
  @objc
  func tappedWebViewButton() {
    didTapWebViewButton?()
  }
}
