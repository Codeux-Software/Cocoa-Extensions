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
	/// Removes \r and \n from end of data until
	/// a byte is found that is neither of those.
	var withoutNewlinesAtEnd: Data
	{
		var offsetAmount = 0

		for index in (startIndex ..< endIndex).reversed() {
			let byte = self[index]

			if (byte == 0x0d || byte == 0x0a) {
				offsetAmount += 1
			} else {
				break
			}
		}

		if (offsetAmount > 0) {
			return Data(dropLast(offsetAmount))
		}

		return self
	}

	var IPv4Address: String?
	{
		if (isEmpty) {
			return nil
		}

		let bufferLength = INET_ADDRSTRLEN

		var buffer = [CChar](repeating: 0, count: Int(bufferLength))

		if (inet_ntop(AF_INET, [UInt8](self), &buffer, socklen_t(bufferLength)) == nil) {
			return nil
		}

		return String(cString: buffer)
	}

	var IPv6Address: String?
	{
		if (isEmpty) {
			return nil
		}

		let bufferLength = INET6_ADDRSTRLEN

		var buffer = [CChar](repeating: 0, count: Int(bufferLength))

		if (inet_ntop(AF_INET6, [UInt8](self), &buffer, socklen_t(bufferLength)) == nil) {
			return nil
		}

		return String(cString: buffer)
	}
}
