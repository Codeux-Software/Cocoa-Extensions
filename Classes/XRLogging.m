/* *********************************************************************

        Copyright (c) 2010 - 2016 Codeux Software, LLC
     Please see ACKNOWLEDGEMENT for additional information.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

 * Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
 * Neither the name of "Codeux Software, LLC", nor the names of its 
   contributors may be used to endorse or promote products derived 
   from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.

 *********************************************************************** */

NS_ASSUME_NONNULL_BEGIN

void _LogToConsoleNSLogShim(const char *formatter, const char *filename, const char *function, unsigned long line, ...)
{
	COCOA_EXTENSIONS_DEPRECATED_WARNING
}

void _LogToConsoleNSLogShim_v2(u_int8_t type, const char *filename, const char *function, unsigned long line, const char *formatter, ...)
{
	COCOA_EXTENSIONS_DEPRECATED_WARNING
}

NSString *_LogToConsoleFormatMessage_v1(u_int8_t type, const char *filename, const char *function, unsigned long line, const char *formatter, ...)
{
	NSCParameterAssert(formatter != NULL);
	NSCParameterAssert(filename != NULL);
	NSCParameterAssert(function != NULL);

	const char *typeString = NULL;

	switch (type) {
		case LogToConsoleTypeInfo:
		{
			typeString = "Info";

			break;
		}
		case LogToConsoleTypeDebug:
		{
			typeString = "Debug";

			break;
		}
		case LogToConsoleTypeError:
		{
			typeString = "Error";

			break;
		}
		case LogToConsoleTypeFault: {
			typeString = "Fault";

			break;
		}
		default:
		{
			typeString = "Default";

			break;
		}
	}

	/* It would be faster to use a version of vsprintf() here but the reason
	 that I don't is because that requires managing buffer size which NSString
	 takes care of for us when formatting. */
	NSString *formatString = [NSString stringWithFormat:@"[%s] %s [Line %d]: %s", typeString, function, line, formatter];

	va_list arguments;
	va_start(arguments, formatter);

	NSString *formattedString = [[NSString alloc] initWithFormat:formatString arguments:arguments];

	va_end(arguments);

	return formattedString;
}

NS_ASSUME_NONNULL_END
