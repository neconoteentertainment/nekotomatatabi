import UIKit
import UniformTypeIdentifiers

final class ShareViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  private let appGroupId = "group.com.neconote.nekotomatatabi"
  private let pendingFavoritesKey = "pending_favorite_sites_v1"

  private let prefectures = [
    "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県",
    "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県",
    "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県",
    "静岡県", "愛知県", "三重県", "滋賀県", "京都府", "大阪府", "兵庫県",
    "奈良県", "和歌山県", "鳥取県", "島根県", "岡山県", "広島県", "山口県",
    "徳島県", "香川県", "愛媛県", "高知県", "福岡県", "佐賀県", "長崎県",
    "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"
  ]

  private let titleField = UITextField()
  private let urlLabel = UILabel()
  private let picker = UIPickerView()
  private let saveButton = UIButton(type: .system)
  private var sharedURL: URL?
  private var suggestedTitle = ""

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    loadSharedPage()
  }

  private func configureUI() {
    view.backgroundColor = UIColor(red: 0.10, green: 0.085, blue: 0.075, alpha: 1)

    let heading = UILabel()
    heading.text = "ねことまた旅に登録"
    heading.textColor = UIColor(red: 0.91, green: 0.73, blue: 0.45, alpha: 1)
    heading.font = .boldSystemFont(ofSize: 21)

    titleField.placeholder = "サイト名"
    titleField.textColor = .label
    titleField.backgroundColor = UIColor(red: 0.98, green: 0.95, blue: 0.87, alpha: 1)
    titleField.layer.cornerRadius = 10
    titleField.setLeftPadding(12)
    titleField.clearButtonMode = .whileEditing
    titleField.heightAnchor.constraint(equalToConstant: 44).isActive = true

    urlLabel.text = "URLを読み込んでいます…"
    urlLabel.textColor = .secondaryLabel
    urlLabel.font = .systemFont(ofSize: 12)
    urlLabel.numberOfLines = 2

    let destinationLabel = UILabel()
    destinationLabel.text = "保存先の都道府県"
    destinationLabel.textColor = .white
    destinationLabel.font = .boldSystemFont(ofSize: 15)

    picker.dataSource = self
    picker.delegate = self
    picker.backgroundColor = UIColor(red: 0.98, green: 0.95, blue: 0.87, alpha: 1)
    picker.layer.cornerRadius = 12
    picker.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    picker.heightAnchor.constraint(equalToConstant: 150).isActive = true

    saveButton.setTitle("お気に入りに登録", for: .normal)
    saveButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
    saveButton.backgroundColor = UIColor(red: 0.91, green: 0.73, blue: 0.45, alpha: 1)
    saveButton.tintColor = UIColor(red: 0.14, green: 0.10, blue: 0.08, alpha: 1)
    saveButton.layer.cornerRadius = 12
    saveButton.isEnabled = false
    saveButton.alpha = 0.55
    saveButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    saveButton.addTarget(self, action: #selector(saveFavorite), for: .touchUpInside)

    let cancelButton = UIButton(type: .system)
    cancelButton.setTitle("キャンセル", for: .normal)
    cancelButton.tintColor = .white
    cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)

    let stack = UIStackView(arrangedSubviews: [
      heading, titleField, urlLabel, destinationLabel, picker, saveButton, cancelButton
    ])
    stack.axis = .vertical
    stack.spacing = 12
    stack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stack)

    NSLayoutConstraint.activate([
      stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
      stack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
    ])
  }

  private func loadSharedPage() {
    guard let item = extensionContext?.inputItems.first as? NSExtensionItem else {
      showLoadError()
      return
    }

    suggestedTitle = (item.attributedTitle?.string ?? item.attributedContentText?.string ?? "")
      .trimmingCharacters(in: .whitespacesAndNewlines)
    let providers = item.attachments ?? []

    if let provider = providers.first(where: { $0.hasItemConformingToTypeIdentifier(UTType.url.identifier) }) {
      provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] value, _ in
        let url: URL?
        if let received = value as? URL {
          url = received
        } else if let received = value as? NSURL {
          url = received as URL
        } else if let text = value as? String {
          url = URL(string: text)
        } else {
          url = nil
        }
        DispatchQueue.main.async { self?.accept(url: url) }
      }
      return
    }

    if let provider = providers.first(where: { $0.hasItemConformingToTypeIdentifier(UTType.text.identifier) }) {
      provider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { [weak self] value, _ in
        let text = value as? String ?? ""
        DispatchQueue.main.async { self?.accept(url: URL(string: text)) }
      }
      return
    }

    showLoadError()
  }

  private func accept(url: URL?) {
    guard let url, let scheme = url.scheme?.lowercased(), scheme == "http" || scheme == "https" else {
      showLoadError()
      return
    }
    sharedURL = url
    urlLabel.text = url.absoluteString
    titleField.text = suggestedTitle.isEmpty ? (url.host ?? url.absoluteString) : suggestedTitle
    saveButton.isEnabled = true
    saveButton.alpha = 1
  }

  private func showLoadError() {
    DispatchQueue.main.async { [weak self] in
      self?.urlLabel.text = "このページのURLを取得できませんでした。Safariからもう一度お試しください。"
      self?.saveButton.isEnabled = false
      self?.saveButton.alpha = 0.55
    }
  }

  @objc private func saveFavorite() {
    guard let sharedURL else { return }
    saveButton.isEnabled = false

    let now = Date()
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    let entry: [String: Any] = [
      "id": "share_\(Int(now.timeIntervalSince1970 * 1_000_000))",
      "prefecture": prefectures[picker.selectedRow(inComponent: 0)],
      "title": titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines).nonEmpty
        ?? sharedURL.host
        ?? sharedURL.absoluteString,
      "url": sharedURL.absoluteString,
      "createdAt": formatter.string(from: now)
    ]

    guard let defaults = UserDefaults(suiteName: appGroupId) else {
      showSaveError()
      return
    }

    var pending: [[String: Any]] = []
    if let encoded = defaults.string(forKey: pendingFavoritesKey),
       let data = encoded.data(using: .utf8),
       let stored = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
      pending = stored
    }
    pending.append(entry)

    guard let data = try? JSONSerialization.data(withJSONObject: pending),
          let encoded = String(data: data, encoding: .utf8) else {
      showSaveError()
      return
    }

    defaults.set(encoded, forKey: pendingFavoritesKey)
    extensionContext?.completeRequest(returningItems: nil)
  }

  private func showSaveError() {
    saveButton.isEnabled = true
    let alert = UIAlertController(
      title: "保存できませんでした",
      message: "時間をおいて、もう一度お試しください。",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }

  @objc private func cancel() {
    extensionContext?.cancelRequest(withError: NSError(
      domain: "com.neconote.nekotomatatabi.share",
      code: NSUserCancelledError
    ))
  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    prefectures.count
  }
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    prefectures[row]
  }
}

private extension UITextField {
  func setLeftPadding(_ width: CGFloat) {
    let padding = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 1))
    leftView = padding
    leftViewMode = .always
  }
}

private extension String {
  var nonEmpty: String? { isEmpty ? nil : self }
}
