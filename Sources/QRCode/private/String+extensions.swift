//
//  String+extensions.swift
//  
//
//  Created by Darren Ford on 10/11/21.
//

import Foundation

extension String {
	var urlQuerySafe: String? {
		self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
	}
}
