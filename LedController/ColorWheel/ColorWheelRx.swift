//
//  ColorWheelRx.swift
//  LedController
//
//  Created by Philipp Wallrich on 02.09.18.
//  Copyright © 2018 Philipp Wallrich. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: ColorWheel {
    var color: ControlProperty<UIColor> {
        let source = self.observeWeakly(UIColor.self, "currentColor")
            .filter{ c in
                return c != nil

            }.map {$0!}
            .takeUntil(deallocated)

        let observer = Binder(base) { (view, color: UIColor) in
            view.currentColor = color
        }
       return ControlProperty(values: source, valueSink: observer)
    }
}
