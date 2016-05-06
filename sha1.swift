import Foundation

extension String {
	/**
	 Make a sha1 Hash for the string.

	 - Returns: sha1 hashed string
	 */
	public var sha1: String {
		get {
			return SHA1Hashing().hash(self)
		}
	}
}

extension Int {
	func tostring(i: Int) -> String {
		if (i == 16) {// hexadecimal
			return String(format: "%2X", self)
				.lowercaseString
				.stringByReplacingOccurrencesOfString(" ", withString: "")
		}
		else if (i == 8) {// octal
			return String(self, radix: 8, uppercase: false)
				.lowercaseString
				.stringByReplacingOccurrencesOfString(" ", withString: "")
		}
		else if (i == 2) {// binary
			return String(self, radix: 2, uppercase: false)
				.lowercaseString
				.stringByReplacingOccurrencesOfString(" ", withString: "")
		}
		else {
			return String(self)
		}
	}
}

class SHA1Hashing {
	var H0 = 0x67452301;
	var H1 = 0xEFCDAB89;
	var H2 = 0x98BADCFE;
	var H3 = 0x10325476;
	var H4 = 0xC3D2E1F0;
	
	init() {}
	
	func rotate(n: Int, _ s: Int) -> Int {
		return ((n << s) & 0xFFFFFFFF) | (n >> (32 - s))
	}
	
	func convert_hex(val: Int) -> String {
		var _str = ""
        for i in (0...7).reverse() {
			let _tmp = (val >> (i * 4)) & 0x0f // >>> ?
			_str = _str.stringByAppendingString(_tmp.tostring(16))
		}
        
		return _str
	}
	
	func hash(str: String) -> String {
		let str_len = str.length
		var W = Array<Int>() ;
		
		var word_array = Array<Int>() ;
        
        for i in 0.stride(to: str_len - 3, by: 4) {
			let j = str.charCodeAt(i) << 24 | str.charCodeAt(i + 1) << 16 | str.charCodeAt(i + 2) << 8 | str.charCodeAt(i + 3) ;
			word_array.append(j)
		}
        
		var i: Int = 0
		switch (str_len % 4) {
		case 0:
			i = 0x080000000;
			break;
		
		case 1:
			i = str.charCodeAt(str_len - 1) << 24 | 0x0800000;
			break;
		
		case 2:
			i = str.charCodeAt(str_len - 2) << 24 | str.charCodeAt(str_len - 1) << 16 | 0x08000;
			break;
		
		case 3:
			i = str.charCodeAt(str_len - 3) << 24 | str.charCodeAt(str_len - 2) << 16 | str.charCodeAt(str_len - 1) <<
			8 | 0x80;
			break;
		
		default:
			break;
		}
		word_array.append(i)
		
		while ((word_array.count % 16) != 14) {
			word_array.append(0)
		}
		
		word_array.append(str_len >> 29) // >>> ?
		word_array.append((str_len << 3) & 0x0ffffffff)
        
        for blockstart in 0.stride(to: word_array.count, by: 16) {
            for i in (0...15) {
				W.append(word_array[blockstart + i])
			}
            for i in (16...79) {
				W.append(self.rotate(W[i - 3] ^ W[i - 8] ^ W[i - 14] ^ W[i - 16], 1))
			}
            
			var A = H0;
			var B = H1;
			var C = H2;
			var D = H3;
			var E = H4;
			
            for i in (0...19) {
				let temp = (self.rotate(A, 5) + ((B & C) | (~B & D)) + E + W[i] + 0x5A827999) & 0x0ffffffff;
				E = D;
				D = C;
				C = self.rotate(B, 30) ;
				B = A;
				A = temp;
			}

            for i in (20...39) {
				let temp = (self.rotate(A, 5) + (B ^ C ^ D) + E + W[i] + 0x6ED9EBA1) & 0x0ffffffff;
				E = D;
				D = C;
				C = self.rotate(B, 30) ;
				B = A;
				A = temp;
			}
			
            for i in (40...59) {
				let temp = (self.rotate(A, 5) + ((B & C) | (B & D) | (C & D)) + E + W[i] + 0x8F1BBCDC) & 0x0ffffffff;
				E = D;
				D = C;
				C = self.rotate(B, 30) ;
				B = A;
				A = temp;
			}

            for i in (60...79) {
				let temp = (self.rotate(A, 5) + (B ^ C ^ D) + E + W[i] + 0xCA62C1D6) & 0x0ffffffff;
				E = D;
				D = C;
				C = self.rotate(B, 30) ;
				B = A;
				A = temp;
			}
			
			H0 = (H0 + A) & 0x0ffffffff;
			H1 = (H1 + B) & 0x0ffffffff;
			H2 = (H2 + C) & 0x0ffffffff;
			H3 = (H3 + D) & 0x0ffffffff;
			H4 = (H4 + E) & 0x0ffffffff;
		}
		
		var temp: String = "\(self.convert_hex(H0))\(self.convert_hex(H1))\(self.convert_hex(H2))\(self.convert_hex(H3))\(self.convert_hex(H4))";
        print(temp)
		temp = temp.lowercaseString
		temp = temp.stringByReplacingOccurrencesOfString(" ", withString: "")
		
		if (W.count != 80) {
			print("Something is gone terrible wrong!")
		}
		
		return temp
	}
}

func sha1(str: String) -> String {
	return SHA1Hashing().hash(str)
}