//
//  DigitField.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 20/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit

class DigitField: UITextField {

    
    override func deleteBackward() {
        super.deleteBackward()
    NSNotificationCenter.defaultCenter().postNotificationName("deletePressed", object: nil)
    }
    
}
