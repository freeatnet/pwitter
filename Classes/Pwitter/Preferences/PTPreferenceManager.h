//
//  PTPreferenceManager.h
//  Pwitter
//
//  Created by Akihiro Noguchi on 26/12/08.
//  Copyright 2008 Aki. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PTStatusBox.h"


@interface PTPreferenceManager : NSObject {
	NSUserDefaults *fPrefData;
}

+ (PTPreferenceManager *)sharedSingleton;
- (void)setupPreferences;

/** API Settings **/
- (NSString *)homeUrl;
- (NSString *)apiUrl;
- (BOOL)apiSecure;


/** User credentials **/
- (void)setUserName:(NSString *)aUserName password:(NSString *)aPassword;
- (NSString *)userName;
- (NSString *)password;
- (void)clearPassword;
- (BOOL)autoLogin;

/** OAuth credentials **/
- (void)setAccessToken:(NSString *)aToken withSecret:(NSString *)aSecret;
- (NSString *)accessToken;
- (NSString *)accessSecret;

/** Update Preferences **/
- (int)timeInterval;
- (void)setTimeInterval:(int)aInterval;
- (int)messageInterval;
- (void)setMessageInterval:(int)aInterval;
- (int)statusUpdateBehavior;
- (void)setStatusUpdateBehavior:(int)aBehavior;
- (int)urlShorteningService;
- (BOOL)usePOSTMethod;
- (BOOL)updateAfterPost;
- (BOOL)receiveFromNonFollowers;

/** Visual&Behavioural Preferences **/
- (BOOL)alwaysOnTop;
- (BOOL)useClassicView;
- (BOOL)useMiniView;
- (BOOL)useTwelveHour;
- (BOOL)disableWindowShadow;
- (void)setHideDockIcon:(BOOL)aFlag;
- (BOOL)hideDockIcon;

- (BOOL)swapMenuItemBehavior;
- (BOOL)disableAnimation;
- (BOOL)hideOnDeactivate;
- (BOOL)selectOldestUnread;
- (int)maxTweets;


/** Access Options **/
- (BOOL)quickPost;
- (BOOL)quickRead;
- (BOOL)postWithModifier;
- (BOOL)hideWithQuickReadShortcut;

/** Notification Preferences **/
- (BOOL)ignoreErrors;
- (BOOL)disableGrowl;
- (BOOL)disableMessageNotification;
- (BOOL)disableReplyNotification;
- (BOOL)disableStatusNotification;
- (BOOL)disableErrorNotification;
- (BOOL)disableSoundNotification;
- (int)maxNotification;

/** Filter Settings **/
- (id)customFilters;
- (void)setCustomFilters:(id)aFilters;

@end
