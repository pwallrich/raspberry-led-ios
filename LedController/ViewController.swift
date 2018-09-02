//
//  ViewController.swift
//  LedController
//
//  Created by Philipp Wallrich on 02.09.18.
//  Copyright © 2018 Philipp Wallrich. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var colorWheel: ColorWheel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
    }

    func setBindings() {
        Observable.combineLatest(
            redSlider.rx.value,
            greenSlider.rx.value,
            blueSlider.rx.value)
            .throttle(0.1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { (red, green, blue) in
                self.updateValues(
                    red: Int(red),
                    green: Int(green),
                    blue: Int(blue))
            }).disposed(by: disposeBag)

        colorWheel.rx.color
            .throttle(0.1, scheduler: MainScheduler.instance)
            .subscribe(onNext: {(color) in
            self.updateValuesWith(color: color)
        }).disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func updateValuesWith(color: UIColor) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        updateValues(red: Int(red*255), green: Int(green*255), blue: Int(blue*255))
    }

    func updateSliderValues() {
        updateValues(
            red: Int(redSlider.value),
            green: Int(greenSlider.value),
            blue: Int(blueSlider.value))
    }

    func updateValues(red: Int, green: Int, blue: Int) {
        print("going to update red: \(red), green: \(green), blue: \(blue)")
        SocketIOManager.shared.setLeds(
            red: red,
            green: green,
            blue: blue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
/*
extension ViewController: ColorWheelDelegate {
    func hueAndSaturationSelected(_ hue: CGFloat, saturation: CGFloat) {
        let color = UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        SocketIOManager.shared.setLeds(
            red: Int(red*255), green: Int(green*255), blue: Int(blue*255))

    }

    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizerState) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        SocketIOManager.shared.setLeds(
            red: Int(red*255), green: Int(green*255), blue: Int(blue*255))
    }


}

*/
