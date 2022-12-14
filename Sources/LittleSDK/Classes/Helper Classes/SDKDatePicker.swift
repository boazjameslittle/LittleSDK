//
//  DatePicker.swift
//  LittleSDK
//
//  Created by Gabriel John on 12/05/2021.
//

import UIKit

public class LittleDatePickerView: UIView {
    
    private var datePickerViewBottomConstraint: NSLayoutConstraint!
    private var doneHandler: ((Date) -> ())?

    public var datePickerView: UIDatePicker!
    public var doneButton: UIButton!
    public var cancelButton: UIButton!
    public var headerView: UIView!
    
    public var minDate: Date?
    public var maxDate: Date?
    
    //MARK: - Init
    
    public init() {
        super.init(frame: .zero)
        setup()
        setupDatePickerView()
        setupHeaderView()
        setupCancelArea()
        setLimits(maxDate: maxDate ?? Date(), minDate: minDate ?? Date())
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Setup
     
    private func setup() {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    }
    
    private func setLimits(maxDate: Date, minDate: Date) {
        datePickerView.minimumDate = minDate
        datePickerView.maximumDate = maxDate
    }
     
    private func setupDatePickerView() {
        datePickerView = UIDatePicker(frame: .zero)
        addSubview(datePickerView)
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        datePickerViewBottomConstraint = datePickerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 500)
        datePickerViewBottomConstraint.isActive = true
        datePickerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        datePickerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        }
        datePickerView.backgroundColor = .white
    }
     
     private func setupHeaderView() {
        headerView = UIView(frame: .zero)
        addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        headerView.bottomAnchor.constraint(equalTo: datePickerView.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        headerView.backgroundColor = .white
         
        doneButton = UIButton(type: .system)
        headerView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -16).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        doneButton.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)

        cancelButton = UIButton(type: .system)
        headerView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        cancelButton.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
     }
     
     private func setupCancelArea() {
        let cancelAreaButton = UIButton(frame: .zero)
        addSubview(cancelAreaButton)
        cancelAreaButton.translatesAutoresizingMaskIntoConstraints = false
        cancelAreaButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cancelAreaButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cancelAreaButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cancelAreaButton.bottomAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        cancelAreaButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
     }
    
    //MARK: - Action
    
    @objc private func done() {
        doneHandler?(datePickerView.date)
        doneHandler = nil
        dismissAnimation()
    }
     
    @objc private func cancel() {
        doneHandler = nil
        dismissAnimation()
    }
    
    //MARK: - Display & Dismiss
    
    private func addToKeyWindow() {
        
        var keyWindow = UIApplication.shared.keyWindow
        
        if #available(iOS 13.0, *) {
            keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        } 
        translatesAutoresizingMaskIntoConstraints = false
        
        if let keyWindow = keyWindow {
            keyWindow.addSubview(self)
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: keyWindow.topAnchor),
                leftAnchor.constraint(equalTo: keyWindow.leftAnchor),
                bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor),
                rightAnchor.constraint(equalTo: keyWindow.rightAnchor)
            ])
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    public func display(defaultDate: Date? = nil, doneHandler: @escaping ((Date) -> Void)) {
        self.doneHandler = doneHandler
        if let defaultDate = defaultDate {
            datePickerView.date = defaultDate
        }
        addToKeyWindow()
        displayAnimation()
    }

    private func displayAnimation() {
        datePickerViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    private func dismissAnimation() {
        datePickerViewBottomConstraint.constant = 500
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
}
