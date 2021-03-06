/* Copyright (c) 2010 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>

#if !GDATA_REQUIRE_SERVICE_INCLUDES || GDATA_INCLUDE_OAUTH

#if !TARGET_OS_IPHONE

#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_5

#import "GDataOAuthWindowController.h"
#import "GDataOAuthSignIn.h"

@interface GDataOAuthWindowController ()
@property (nonatomic, copy) NSURLRequest *initialRequest;

- (void)destroyWindow;
- (void)handlePrematureWindowClose;
- (BOOL)shouldUseKeychain;
@end

const char *kKeychainAccountName = "OAuth";

@implementation GDataOAuthWindowController

// IBOutlets
@synthesize keychainCheckbox = keychainCheckbox_;
@synthesize webView = webView_;
@synthesize webCloseButton = webCloseButton_;
@synthesize webBackButton = webBackButton_;

// regular ivars
@synthesize initialRequest = initialRequest_;
@synthesize keychainApplicationServiceName = keychainApplicationServiceName_;
@synthesize userData = userData_;

- (id)initWithScope:(NSString *)scope
           language:(NSString *)language
     appServiceName:(NSString *)keychainAppServiceName
     resourceBundle:(NSBundle *)bundle {
  // convenient entry point for Google authentication
  return [self initWithScope:scope
                    language:language
             requestTokenURL:nil
           authorizeTokenURL:nil
              accessTokenURL:nil
              authentication:nil
              appServiceName:keychainAppServiceName
              resourceBundle:bundle];
}

- (id)initWithScope:(NSString *)scope
           language:(NSString *)language
    requestTokenURL:(NSURL *)requestURL
  authorizeTokenURL:(NSURL *)authorizeURL
     accessTokenURL:(NSURL *)accessURL
     authentication:(GDataOAuthAuthentication *)auth
     appServiceName:(NSString *)keychainAppServiceName
     resourceBundle:(NSBundle *)bundle {
  if (bundle == nil) {
    bundle = [NSBundle mainBundle];
  }

  NSString *nibName = [[self class] authNibName];
  NSString *nibPath = [bundle pathForResource:nibName
                                       ofType:@"nib"];
  self = [super initWithWindowNibPath:nibPath
                                owner:self];
  if (self != nil) {
    if (auth) {
      // use the supplied auth and OAuth endpoint URLs
      signIn_ =  [[GDataOAuthSignIn alloc] initWithAuthentication:auth
                                                  requestTokenURL:requestURL
                                                authorizeTokenURL:authorizeURL
                                                   accessTokenURL:accessURL
                                                         delegate:self
                                               webRequestSelector:@selector(signIn:displayRequest:)
                                                 finishedSelector:@selector(signIn:finishedWithAuth:error:)];
    } else {
      // use default Google auth and endpoint values
      signIn_ = [[GDataOAuthSignIn alloc] initWithGoogleAuthenticationForScope:scope
                                                                      language:language
                                                                      delegate:self
                                                            webRequestSelector:@selector(signIn:displayRequest:)
                                                              finishedSelector:@selector(signIn:finishedWithAuth:error:)];
    }

    // the display name defaults to the bundle's name, falling back on the
    // executable name
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *displayName = [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if ([displayName length] == 0) {
      displayName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
      if ([displayName length] == 0) {
        displayName = [[bundle executablePath] lastPathComponent];
      }
    }
    [self setDisplayName:displayName];

    [self setKeychainApplicationServiceName:keychainAppServiceName];

    // to allow the user to autorelease this upon creation, the controller will
    // retain itself until after the controller calls back to the user, or is
    // explicitly cancelled
    //
    // This retain is balanced in -cancelSigningIn and when the user is called
    // back in -signIn:finishedWithAuth:error:
    [self retain];
  }
  return self;
}

- (void)dealloc {
  [signIn_ release];
  [initialRequest_ release];
  [sheetModalForWindow_ release];
  [keychainApplicationServiceName_ release];
  [userData_ release];
  [super dealloc];
}

- (void)awakeFromNib {
  // load the requested initial sign-in page
  [webView_ setResourceLoadDelegate:self];
  [[webView_ mainFrame] loadRequest:[self initialRequest]];

  // hide the keychain checkbox if we're not supporting keychain
  BOOL hideKeychainCheckbox = ![self shouldUseKeychain];
  [keychainCheckbox_ setHidden:hideKeychainCheckbox];
}

+ (NSString *)authNibName {
  // subclasses may override this to specify a custom nib name
  return @"GDataOAuthWindow";
}

#pragma mark -

- (void)signInSheetModalForWindow:(NSWindow *)parentWindowOrNil
                         delegate:(id)delegate
                 finishedSelector:(SEL)finishedSelector {
  // check the selector on debug builds
  AssertSelectorNilOrImplementedWithArguments(delegate, finishedSelector,
    @encode(GDataOAuthWindowController *), @encode(GDataOAuthAuthentication *),
    @encode(NSError *), 0);

  delegate_ = delegate;
  finishedSelector_ = finishedSelector;
  sheetModalForWindow_ = [parentWindowOrNil retain];
  hasDoneFinalRedirect_ = NO;
  hasCalledFinished_ = NO;

  [signIn_ startSigningIn];
}

- (void)cancelSigningIn {
  // The user has explicitly asked us to cancel signing in
  // (so no further callback is required)
  hasCalledFinished_ = YES;

  // The signIn object's cancel method will close the window
  [signIn_ cancelSigningIn];
  hasDoneFinalRedirect_ = YES;

  // we no longer need to retain ourselves
  //
  // this balances the retain in the init method
  [self autorelease];
}

- (IBAction)closeWindow:(id)sender {
  // dismiss the window/sheet before we call back the client
  [self destroyWindow];
  [self handlePrematureWindowClose];
}

#pragma mark SignIn callbacks

- (void)signIn:(GDataOAuthSignIn *)signIn displayRequest:(NSURLRequest *)request {
  // this is the signIn object's webRequest method, telling the controller
  // to either display the request in the webview, or close the window
  //
  // All web requests and all window closing goes through this routine

#if DEBUG
  if ((isWindowShown_ && request != nil)
      || (!isWindowShown_ && request == nil)) {
    NSLog(@"Window state unexpected for request %@", [request URL]);
    return;
  }
#endif

  if (request != nil) {
    // display the request
    [self setInitialRequest:request];

    if (sheetModalForWindow_) {
      NSWindow *sheetWindow = [self window];

      [NSApp beginSheet:sheetWindow
         modalForWindow:sheetModalForWindow_
          modalDelegate:self
         didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
            contextInfo:nil];
    } else {
      // modeless
      [self showWindow:self];
    }
    isWindowShown_ = YES;
  } else {
    // request was nil
    [self destroyWindow];
  }
}

- (void)destroyWindow {
  // no request; close the window (but not immediately, in case
  // we're called in response to some window event)
  if (sheetModalForWindow_) {
    [NSApp endSheet:[self window]];
  } else {
    [[self window] performSelector:@selector(close)
                        withObject:nil
                        afterDelay:0.1];
  }
  isWindowShown_ = NO;
}

- (void)handlePrematureWindowClose {
  if (!hasDoneFinalRedirect_) {
    // tell the sign-in object to tell the user's finished method
    // that we're done
    [signIn_ windowWasClosed];
    hasDoneFinalRedirect_ = YES;
  }
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
  [sheet orderOut:self];

  [sheetModalForWindow_ release];
  sheetModalForWindow_ = nil;
}

- (void)signIn:(GDataOAuthSignIn *)signIn finishedWithAuth:(GDataOAuthAuthentication *)auth error:(NSError *)error {
  if (!hasCalledFinished_) {
    hasCalledFinished_ = YES;

    if (error == nil) {
      BOOL shouldUseKeychain = [self shouldUseKeychain];
      if (shouldUseKeychain) {
        GDataOAuthAuthentication *auth = [signIn_ authentication];
        BOOL canAuthorize = [auth canAuthorize];
        BOOL isKeychainChecked = ([keychainCheckbox_ state] == NSOnState);

        NSString *appServiceName = [self keychainApplicationServiceName];

        if (isKeychainChecked && canAuthorize) {
          // save the auth params in the keychain
          [[self class] saveParamsToKeychainForName:appServiceName
                                     authentication:auth];
        } else {
          // remove the auth params from the keychain
          [[self class] removeParamsFromKeychainForName:appServiceName];
        }
      }
    }

    SEL sel = finishedSelector_;
    NSMethodSignature *sig = [delegate_ methodSignatureForSelector:sel];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setSelector:sel];
    [invocation setTarget:delegate_];
    [invocation setArgument:&self atIndex:2];
    [invocation setArgument:&auth atIndex:3];
    [invocation setArgument:&error atIndex:4];
    [invocation invoke];

    // we no longer need to retain ourselves
    //
    // this balances the retain in the init method
    [self autorelease];
  }
}

#pragma mark Token Revocation

+ (void)revokeTokenForGoogleAuthentication:(GDataOAuthAuthentication *)auth {
  [GDataOAuthSignIn revokeTokenForGoogleAuthentication:auth];
}

#pragma mark WebView methods

- (NSURLRequest *)webView:(WebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(WebDataSource *)dataSource {
  if (!hasDoneFinalRedirect_) {
    hasDoneFinalRedirect_ = [signIn_ requestRedirectedToRequest:request];
    if (hasDoneFinalRedirect_) {
      // signIn has told the window to close
      return nil;
    }
  }
  return request;
}

- (void)windowWillClose:(NSNotification *)note {
  [self handlePrematureWindowClose];
}

#pragma mark Keychain support

+ (NSString *)prefsKeyForName:(NSString *)appServiceName {
  NSString *result = [@"OAuth: " stringByAppendingString:appServiceName];
  return result;
}

+ (BOOL)saveParamsToKeychainForName:(NSString *)appServiceName
                     authentication:(GDataOAuthAuthentication *)auth {

  [self removeParamsFromKeychainForName:appServiceName];

  // don't save unless we have a token that can really authorize requests
  if (![auth hasAccessToken]) return NO;

  // make a response string containing the values we want to save
  NSString *password = [auth persistenceResponseString];

  SecKeychainRef defaultKeychain = NULL;
  SecKeychainItemRef *dontWantItemRef= NULL;
  const char *utf8ServiceName = [appServiceName UTF8String];
  const char *utf8Password = [password UTF8String];

  OSStatus err = SecKeychainAddGenericPassword(defaultKeychain,
                               strlen(utf8ServiceName), utf8ServiceName,
                               strlen(kKeychainAccountName), kKeychainAccountName,
                               strlen(utf8Password), utf8Password,
                               dontWantItemRef);
  BOOL didSucceed = (err == noErr);
  if (didSucceed) {
    // write to preferences that we have a keychain item (so we know later
    // that we can read from the keychain without raising a permissions dialog)
    NSString *prefKey = [self prefsKeyForName:appServiceName];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:prefKey];
  }

  return didSucceed;
}

+ (BOOL)removeParamsFromKeychainForName:(NSString *)appServiceName {

  SecKeychainRef defaultKeychain = NULL;
  SecKeychainItemRef itemRef = NULL;
  const char *utf8ServiceName = [appServiceName UTF8String];

  // we don't really care about the password here, we just want to
  // get the SecKeychainItemRef so we can delete it.
  OSStatus err = SecKeychainFindGenericPassword (defaultKeychain,
                                       strlen(utf8ServiceName), utf8ServiceName,
                                       strlen(kKeychainAccountName), kKeychainAccountName,
                                       0, NULL, // ignore password
                                       &itemRef);
  if (err != noErr) {
    // failure to find is success
    return YES;
  } else {
    // found something, so delete it
    err = SecKeychainItemDelete(itemRef);
    CFRelease(itemRef);

    // remove our preference key
    NSString *prefKey = [self prefsKeyForName:appServiceName];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:prefKey];

    return (err == noErr);
  }
}

+ (GDataOAuthAuthentication *)authForGoogleFromKeychainForName:(NSString *)appServiceName {
  GDataOAuthAuthentication *newAuth = [GDataOAuthAuthentication authForInstalledApp];
  [self authorizeFromKeychainForName:appServiceName
                      authentication:newAuth];
  return newAuth;
}

+ (BOOL)authorizeFromKeychainForName:(NSString *)appServiceName
                      authentication:(GDataOAuthAuthentication *)newAuth {
  [newAuth setToken:nil];
  [newAuth setHasAccessToken:NO];

  // before accessing the keychain, check preferences to verify that we've
  // previously saved a token to the keychain (so we don't needlessly raise
  // a keychain access permission dialog)
  NSString *prefKey = [self prefsKeyForName:appServiceName];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  BOOL flag = [defaults boolForKey:prefKey];
  if (!flag) {
    return NO;
  }

  BOOL didGetTokens = NO;

  SecKeychainRef defaultKeychain = NULL;
  const char *utf8ServiceName = [appServiceName UTF8String];
  SecKeychainItemRef *dontWantItemRef = NULL;

  void *passwordBuff = NULL;
  UInt32 passwordBuffLength = 0;

  OSStatus err = SecKeychainFindGenericPassword(defaultKeychain,
                                      strlen(utf8ServiceName), utf8ServiceName,
                                      strlen(kKeychainAccountName), kKeychainAccountName,
                                      &passwordBuffLength, &passwordBuff,
                                      dontWantItemRef);
  if (err == noErr && passwordBuff != NULL) {

    NSString *password = [[[NSString alloc] initWithBytes:passwordBuff
                                                   length:passwordBuffLength
                                                 encoding:NSUTF8StringEncoding] autorelease];

    // free the password buffer that was allocated above
    SecKeychainItemFreeContent(NULL, passwordBuff);

    if (password != nil) {
      [newAuth setKeysForResponseString:password];
      [newAuth setHasAccessToken:YES];
      didGetTokens = YES;
    }
  }
  return didGetTokens;
}

#pragma mark Accessors

- (void)setDisplayName:(NSString *)displayName {
  GDataOAuthAuthentication *auth = [self authentication];
  [auth setDisplayName:displayName];
}

- (NSString *)displayName {
  return [[self authentication] displayName];
}

- (GDataOAuthAuthentication *)authentication {
  GDataOAuthAuthentication *auth = [signIn_ authentication];
  return auth;
}

- (BOOL)shouldUseKeychain {
  BOOL hasName = ([keychainApplicationServiceName_ length] > 0);
  return hasName;
}

- (WebView *)webView {
  return webView_;
}

- (NSButton *)keychainCheckbox {
  return keychainCheckbox_;
}
@end

#endif // #if MAC_OS_X_VERSION_MIN_REQUIRED

#endif // #if !TARGET_OS_IPHONE

#endif // #if !GDATA_REQUIRE_SERVICE_INCLUDES || GDATA_INCLUDE_OAUTH
