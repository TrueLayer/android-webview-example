import UIKit
import WebKit

final class WebViewController: UIViewController {
  private var url: URL!
  
  private var rootView: WebView {
    view as! WebView
  }
  
  init(url: URL) {
    super.init(nibName: nil, bundle: nil)
    
    self.url = url
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    self.view = WebView()

    rootView.webViewVC.load(URLRequest(url: url))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupInteractions()
  }
  
  func setupInteractions() {
    rootView.didTapCloseButton = { [weak self] in
      self?.dismiss(animated: true)
    }
  }
}

final class WebView: UIView {
  let closeWebViewButton = UIButton()
  let webViewVC = WKWebView()
  
  var didTapCloseButton: (() -> Void)?
  
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
    addSubview(closeWebViewButton)
    addSubview(webViewVC)
    
    closeWebViewButton.addTarget(self, action: #selector(tappedCloseButton), for: .touchUpInside)
    webViewVC.uiDelegate = self
    webViewVC.navigationDelegate = self
  }
  
  func style() {
    backgroundColor = .systemBackground
    
    closeWebViewButton.setTitle("Close", for: .normal)
    closeWebViewButton.setTitleColor(.systemBlue, for: .normal)
  }
  
  func layout() {
    closeWebViewButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      closeWebViewButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      closeWebViewButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
    ])
    closeWebViewButton.sizeToFit()
    
    webViewVC.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      webViewVC.topAnchor.constraint(equalTo: closeWebViewButton.bottomAnchor, constant: 8),
      webViewVC.bottomAnchor.constraint(equalTo: bottomAnchor),
      webViewVC.leadingAnchor.constraint(equalTo: leadingAnchor),
      webViewVC.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }
  
  @objc func tappedCloseButton() {
    didTapCloseButton?()
  }
}

extension WebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      print(navigationAction.request.url);
      if let url = navigationAction.request.url, !url.absoluteURL.description.contains("payment.truelayer-sandbox.com") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

extension WebView: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
      print(navigationAction.request.url);
        if let url = navigationAction.request.url, !url.absoluteURL.description.contains("payment.truelayer-sandbox.com") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return nil
        } else {
            let newWebView = WKWebView(frame: webView.frame, configuration: configuration)
            newWebView.uiDelegate = self
            addSubview(newWebView)
            return newWebView
        }
    }
}
