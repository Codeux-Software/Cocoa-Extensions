/* *********************************************************************
*
*            Copyright (c) 2018 Codeux Software, LLC
*     Please see ACKNOWLEDGEMENT for additional information.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
*
*  * Redistributions of source code must retain the above copyright
*    notice, this list of conditions and the following disclaimer.
*  * Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the
*    documentation and/or other materials provided with the distribution.
*  * Neither the name of "Codeux Software, LLC", nor the names of its
*    contributors may be used to endorse or promote products derived
*    from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
* OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
* LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
* OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
* SUCH DAMAGE.
*
*********************************************************************** */

public extension Data
{
	/// Returns byte offset from a specific amount.
	/// A positive amount returns byte offset from start.
	/// A negative amount returns byte offset from end.
	/// Zero amount returns nil because that doesn't make sense.
	/// If the byte doesn't exist at the offset, returns nil.
	func byte(offsetBy amount: Int) -> UInt8?
	{
		if (amount == 0) {
			return nil
		}

		let byteCount = count

		var byteIndex = 0

		if (amount > 0) {
			byteIndex = amount;
		} else if (amount < 0) {
			byteIndex = (byteCount + amount)
		}

		if (byteIndex < 0 || byteIndex >= byteCount) {
			return nil
		}

		return self[byteIndex]
	}

	/// Removes \r and \n from end of data until
	/// a byte is found that is neither of those.
	func newlinesTrimmedFromEnd() -> Data
	{
		var lastIndex: Int?

		for index in (0 ..< count).reversed() {
			let byte = self[index]

			if (byte == 0x0d || byte == 0x0a) {
				lastIndex = index
			} else {
				break
			}
		}

		if (lastIndex != nil) {
			return self.subdata(in: 0 ..< lastIndex!)
		}

		return self
	}
}
