//
//  File.swift
//  
//
//  Created by Darren Ford on 12/4/2023.
//

import Foundation

class TestFilesContainer {

	// Note:  DateFormatter is thread safe
	// See https://developer.apple.com/documentation/foundation/dateformatter#1680059
	private static let iso8601Formatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX ISO8601
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HHmmssZ"
		return dateFormatter
	}()

	private let root: Subfolder
	var rootFolder: URL { self.root.folder }
	init(named name: String) throws {
		let baseURL = FileManager.default.temporaryDirectory.appendingPathComponent(name)

		let url = baseURL.appendingPathComponent(Self.iso8601Formatter.string(from: Date()))
		try? FileManager.default.removeItem(at: url)
		try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
		self.root = Subfolder(url)
		Swift.print("TestContainer(\(name) - Generated files at: \(url)")

		let latest = baseURL.appendingPathComponent("_latest")
		try? FileManager.default.removeItem(at: latest)
		try! FileManager.default.createSymbolicLink(at: latest, withDestinationURL: url)
	}

	func subfolder(with components: String...) throws -> Subfolder {
		var subfolder = self.rootFolder
		components.forEach { subfolder.appendPathComponent($0) }
		try FileManager.default.createDirectory(at: subfolder, withIntermediateDirectories: true)
		return Subfolder(subfolder)
	}

	class Subfolder {
		let folder: URL

		init(_ parent: URL) {
			self.folder = parent
		}
		init(named name: String, parent: URL) throws {
			let subf = parent.appendingPathComponent(name)
			try FileManager.default.createDirectory(at: subf, withIntermediateDirectories: true)
			self.folder = subf
		}

		func subfolder(with components: String...) throws -> Subfolder {
			var subfolder = self.folder
			components.forEach { subfolder.appendPathComponent($0) }
			try FileManager.default.createDirectory(at: subfolder, withIntermediateDirectories: true)
			return Subfolder(subfolder)
		}

		@discardableResult func write(
			_ data: Data,
			to file: String
		) throws -> URL {
			let tempURL = self.folder.appendingPathComponent(file)
			try data.write(to: tempURL)
			return tempURL
		}

		@discardableResult func write(
			_ string: String,
			to file: String,
			encoding: String.Encoding = .utf8
		) throws -> URL {
			let tempURL = self.folder.appendingPathComponent(file)
			try string.write(to: tempURL, atomically: true, encoding: encoding)
			return tempURL
		}
	}
}
