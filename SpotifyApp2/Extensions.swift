//
//  Extensions.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 6.04.23.
//

import Foundation
import UIKit

extension UIView {
    var height: CGFloat {
        return frame.size.height
    }
    var width: CGFloat {
        return frame.size.width
    }
    var left: CGFloat {
        return frame.origin.x
    }
    var top: CGFloat {
        return frame.origin.y
    }
    var right: CGFloat {
        return left + width
    }
    var bottom: CGFloat {
        return top + height
    }
}

extension String {
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

}
