//
//  Toast.swift
//  RSSReader
//
//  Created by Fabijan Mihanović on 02.02.2024..
//

import UIKit

import UIKit

enum ToastAction: Equatable {
    case addedNewFeed

    var icon: UIImage? {
        switch self {
        case .addedNewFeed:
            return UIImage(systemName: "checkmark.circle.fill")
        }
    }

    var message: String {
        switch self {
        case .addedNewFeed:
            return "toast.new.feed.added".localize()
        }
    }

}

class Toast {

    static func show(for action: ToastAction, controller: UIViewController?, anchor: UIView? = nil, padding: CGFloat = 0) {
        show(
            message: action.message,
            image: action.icon,
            controller: controller,
            anchor: anchor,
            padding: padding
        )
    }

    static func show(message: String, image: UIImage? = nil, controller: UIViewController?, anchor: UIView? = nil, padding: CGFloat = 0) {
        guard let controller = controller else { return }

        let toastContainer = UIView(frame: .zero)
        toastContainer.alpha = 0
        toastContainer.setShadow()
        toastContainer.layer.cornerRadius = 8
        toastContainer.backgroundColor = .systemGreen

        let icon = UIImageView(image: image)
        icon.tintColor = .white

        let toastLabel = UILabel(frame: .zero)
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.textAlignment = .left
        toastLabel.textColor = .white
        toastLabel.font = .systemFont(ofSize: 11, weight: .medium)

        toastContainer.addSubview(icon)
        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)

        icon.snp.makeConstraints { make in
            make.centerY.equalTo(toastContainer.snp.centerY)
            make.leading.equalTo(toastContainer.snp.leading).offset(10)
            make.width.height.equalTo(16)
        }

        toastLabel.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(8)
            make.top.equalTo(toastContainer.snp.top).offset(6)
            make.bottom.equalTo(toastContainer.snp.bottom).inset(6)
            make.trailing.equalToSuperview().inset(10)
        }

        toastContainer.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualToSuperview().offset(16)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
            make.centerX.equalToSuperview()

            if let anchor {
                make.bottom.equalTo(anchor.snp.top).offset(padding)
            } else {
                make.bottom.equalTo(controller.view.safeAreaLayoutGuide.snp.bottom).inset(padding)
            }
        }

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
