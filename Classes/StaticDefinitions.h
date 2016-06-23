/* *********************************************************************

        Copyright (c) 2010 - 2015 Codeux Software, LLC
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

#define PointerIsEmpty(s)								((s) == NULL || (s) == nil)
#define PointerIsNotEmpty(s)							((s) != NULL && (s) != nil)

#define NSDissimilarObjects(o,n)						((o) != (n))

#define CFSafeRelease(s)								if ((s) != NULL) { CFRelease((s)); }

#define NSAssertReturn(c)								if ((c) == NO) { return; }
#define NSAssertReturnR(c, r)							if ((c) == NO) { return (r); }
#define NSAssertReturnLoopContinue(c)					if ((c) == NO) { continue; }
#define NSAssertReturnLoopBreak(c)						if ((c) == NO) { break; }

#define NSObjectIsEmptyAssert(o)						if (NSObjectIsEmpty(o)) { return; }
#define NSObjectIsEmptyAssertReturn(o, r)				if (NSObjectIsEmpty(o)) { return (r); }
#define NSObjectIsEmptyAssertLoopContinue(o)			if (NSObjectIsEmpty(o)) { continue; }
#define NSObjectIsEmptyAssertLoopBreak(o)				if (NSObjectIsEmpty(o)) { break; }

#define NSObjectIsNotEmptyAssert(o)						if (NSObjectIsNotEmpty(o)) { return; }
#define NSObjectIsNotEmptyAssertReturn(o, r)			if (NSObjectIsNotEmpty(o)) { return (r); }
#define NSObjectIsNotEmptyAssertLoopContinue(o)			if (NSObjectIsNotEmpty(o)) { continue; }
#define NSObjectIsNotEmptyAssertLoopBreak(o)			if (NSObjectIsNotEmpty(o)) { break; }

#define PointerIsEmptyAssert(o)							if (PointerIsEmpty(o)) { return; }
#define PointerIsEmptyAssertReturn(o, r)				if (PointerIsEmpty(o)) { return (r); }
#define PointerIsEmptyAssertLoopContinue(o)				if (PointerIsEmpty(o)) { continue; }
#define PointerIsEmptyAssertLoopBreak(o)				if (PointerIsEmpty(o)) { break; }

#define PointerIsNotEmptyAssert(o)						if (PointerIsNotEmpty(o)) { return; }
#define PointerIsNotEmptyAssertReturn(o, r)				if (PointerIsNotEmpty(o)) { return (r); }
#define PointerIsNotEmptyAssertLoopContinue(o)			if (PointerIsNotEmpty(o)) { continue; }
#define PointerIsNotEmptyAssertLoopBreak(o)				if (PointerIsNotEmpty(o)) { break; }

#define NSObjectIsKindOfClassAssert(o,c)				if ([(o) isKindOfClass:[c class]] == NO) { return; }
#define NSObjectIsKindOfClassAssertReturn(o, c, r)		if ([(o) isKindOfClass:[c class]] == NO) { return (r); }
#define NSObjectIsKindOfClassAssertContinue(o, c)		if ([(o) isKindOfClass:[c class]] == NO) { continue; }
#define NSObjectIsKindOfClassAssertBreak(o,c)			if ([(o) isKindOfClass:[c class]] == NO) { break; }

#define COCOA_EXTENSIONS_EXTERN							extern

#define COCOA_EXTENSIONS_DEPRECATED(reason)				__attribute__((deprecated((reason))))

#define COCOA_EXTENSIONS_DEPRECATED_ASSERT				NSAssert1(NO, @"Deprecated Method: %s", __PRETTY_FUNCTION__);
#define COCOA_EXTENSIONS_DEPRECATED_ASSERT_C			NSCAssert1(NO, @"Deprecated Method: %s", __PRETTY_FUNCTION__);

#define COCOA_EXTENSIONS_DEPRECATED_WARNING				NSLog(@"DEPRECATED: Use of the method named %s is deprecated. This method will cease to exist in a future version of this framework.\n\nCurrent Stack: %@", __PRETTY_FUNCTION__, [NSThread callStackSymbols]);
