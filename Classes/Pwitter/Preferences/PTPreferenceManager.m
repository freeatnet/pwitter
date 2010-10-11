//
//  PTPreferenceManager.m
//  Pwitter
//
//  Created by Akihiro Noguchi on 26/12/08.
//  Copyright 2008 Aki. All rights reserved.
//

#import "PTPreferenceManager.h"
#import "EMKeychainProxy.h"

#define APP_NAME @"Pwitter"

@implementation PTPreferenceManager

static PTPreferenceManager *sharedSingleton;

+ (PTPreferenceManager *)sharedSingleton
{
	@synchronized(self)
	{
		if (!sharedSingleton)
			[[PTPreferenceManager alloc] init];
		return sharedSingleton;
	}
	return nil;
}

+(id)alloc
{
	@synchronized(self)
	{
		NSAssert(sharedSingleton == nil, @"Attempted to allocate a second instance of a singleton.");
		sharedSingleton = [super alloc];
		[sharedSingleton setupPreferences];
		return sharedSingleton;
	}
	return nil;
}

- (void)setupPreferences {
	fPrefData = [NSUserDefaults standardUserDefaults];
	
	if (![fPrefData stringForKey:@"home_url"])
		[fPrefData setObject:@"twitter.com" forKey:@"home_url"];
	if (![fPrefData stringForKey:@"api_url"])
		[fPrefData setObject:@"api.twitter.com/1" forKey:@"api_url"];
	if (![fPrefData boolForKey:@"api_https"])
		[fPrefData setBool:TRUE forKey:@"api_https"];
	
	if ([fPrefData integerForKey:@"time_interval"] == 0)
		[fPrefData setInteger:2 forKey:@"time_interval"];
	if ([fPrefData integerForKey:@"message_interval"] == 0)
		[fPrefData setInteger:3 forKey:@"message_interval"];
	if ([fPrefData integerForKey:@"status_update_behavior"] == 0)
		[fPrefData setInteger:1 forKey:@"status_update_behavior"];
}

- (NSString *)homeUrl {
	return [fPrefData stringForKey:@"home_url"];
}

- (NSString *)apiUrl {
	return [fPrefData stringForKey:@"api_url"];
}

- (BOOL)apiSecure {
	return [fPrefData boolForKey:@"api_https"];
}

- (void)setUserName:(NSString *)aUserName password:(NSString *)aPassword {
	[fPrefData setObject:aUserName forKey:@"user_name"];
	
	EMGenericKeychainItem *lTempItem = 
	[[EMKeychainProxy sharedProxy] genericKeychainItemForService:[NSString stringWithFormat:@"%@ Password", APP_NAME]
													withUsername:[NSString stringWithFormat:@"%@@%@", aUserName, [fPrefData stringForKey:@"api_url"]]];
	if (!lTempItem) {
		[[EMKeychainProxy sharedProxy] addGenericKeychainItemForService:[NSString stringWithFormat:@"%@ Password", APP_NAME]
														   withUsername:[NSString stringWithFormat:@"%@@%@", aUserName, [fPrefData stringForKey:@"api_url"]]
															   password:aPassword];
	} else {
		[lTempItem setPassword:aPassword];
	}
}

- (void)clearPassword {
	// TODO: freeatnet: Make the Keychain actually delete the item
	EMGenericKeychainItem *lTempItem = [[EMKeychainProxy sharedProxy] 
								  genericKeychainItemForService:[NSString stringWithFormat:@"%@ Password", APP_NAME]
								withUsername:[NSString stringWithFormat:@"%@@%@", [self userName], [fPrefData stringForKey:@"api_url"]]];
	if (lTempItem) {
		[lTempItem setPassword:@""];
	}
}

- (NSString *)userName {
	return [fPrefData stringForKey:@"user_name"];
}

- (NSString *)password {
	EMGenericKeychainItem *lTempItem = 
	[[EMKeychainProxy sharedProxy] genericKeychainItemForService:[NSString stringWithFormat:@"%@ Password", APP_NAME]
								withUsername:[NSString stringWithFormat:@"%@@%@", [self userName], [fPrefData stringForKey:@"api_url"]]];
	if (!lTempItem) {
		return nil;
	} else {
		return [lTempItem password];
	}
}

- (void)setAccessToken:(NSString *)aToken {
	EMGenericKeychainItem *lTempItem = 
	[[EMKeychainProxy sharedProxy] genericKeychainItemForService:[NSString stringWithFormat:@"%@ Access Token", APP_NAME] 
													withUsername:[NSString stringWithFormat:@"%@@%@", [self userName], [self apiUrl]]];
	if (!lTempItem) {
		[[EMKeychainProxy sharedProxy] addGenericKeychainItemForService:[NSString stringWithFormat:@"%@ Access Token", APP_NAME] 
														   withUsername:[NSString stringWithFormat:@"%@@%@", [self userName], [self apiUrl]]
															   password:aToken];
	} else {
		[lTempItem setPassword:aToken];
	}
}

- (void)setAccessSecret:(NSString *)aSecret {
	EMGenericKeychainItem *lTempItem = 
	[[EMKeychainProxy sharedProxy] genericKeychainItemForService:[NSString stringWithFormat:@"%@ Access Secret", APP_NAME] 
													withUsername:[NSString stringWithFormat:@"%@@%@", [self userName], [self apiUrl]]];
	if (!lTempItem) {
		[[EMKeychainProxy sharedProxy] addGenericKeychainItemForService:[NSString stringWithFormat:@"%@ Access Secret", APP_NAME] 
														   withUsername:[NSString stringWithFormat:@"%@@%@", [self userName], [self apiUrl]]
															   password:aSecret];
	} else {
		[lTempItem setPassword:aSecret];
	}
}

- (void)setAccessToken:(NSString *)aToken withSecret:(NSString *)aSecret {
	[self setAccessToken:aToken];
	[self setAccessSecret:aSecret];
}

- (NSString *)accessToken {
	EMGenericKeychainItem *lTempItem = 
	[[EMKeychainProxy sharedProxy] genericKeychainItemForService:[NSString stringWithFormat:@"%@ Access Token", APP_NAME] 
									withUsername:[NSString stringWithFormat:@"%@@%@", [self userName], [fPrefData stringForKey:@"api_url"]]];
	if (!lTempItem) {
		return nil;
	} else {
		return [lTempItem password];
	}
}

- (NSString *)accessSecret {
	EMGenericKeychainItem *lTempItem = 
	[[EMKeychainProxy sharedProxy] genericKeychainItemForService:[NSString stringWithFormat:@"%@ Access Secret", APP_NAME] 
													withUsername:[NSString stringWithFormat:@"%@@%@", [self userName], [fPrefData stringForKey:@"api_url"]]];
	if (!lTempItem) {
		return nil;
	} else {
		return [lTempItem password];
	}
}

- (BOOL)alwaysOnTop {
	return [fPrefData boolForKey:@"always_on_top"];
}

- (BOOL)receiveFromNonFollowers {
	return [fPrefData boolForKey:@"receive_updates_from_non_followers"];
}

- (void)setTimeInterval:(int)aInterval {
	[fPrefData setInteger:aInterval forKey:@"time_interval"];
}

- (int)timeInterval {
	return [fPrefData integerForKey:@"time_interval"];
}

- (void)setMessageInterval:(int)aInterval {
	[fPrefData setInteger:aInterval forKey:@"message_interval"];
}

- (int)messageInterval {
	return [fPrefData integerForKey:@"message_interval"];
}

- (BOOL)useMiniView {
	return [fPrefData boolForKey:@"enable_mini_view"];
}

- (BOOL)autoLogin {
	return [fPrefData boolForKey:@"auto_login"];
}

- (BOOL)quickPost {
	return [fPrefData boolForKey:@"use_quick_post"];
}

- (BOOL)quickRead {
	return [fPrefData boolForKey:@"use_quick_read"];
}

- (BOOL)ignoreErrors {
	return [fPrefData boolForKey:@"ignore_errors"];
}

- (BOOL)disableGrowl {
	return [fPrefData boolForKey:@"disable_growl"];
}

- (BOOL)disableMessageNotification {
	return [fPrefData boolForKey:@"disable_message_notification"];
}

- (BOOL)disableReplyNotification {
	return [fPrefData boolForKey:@"disable_reply_notification"];
}

- (BOOL)disableStatusNotification {
	return [fPrefData boolForKey:@"disable_status_notification"];
}

- (BOOL)disableErrorNotification {
	return [fPrefData boolForKey:@"disable_error_notification"];
}

- (BOOL)disableSoundNotification {
	return [fPrefData boolForKey:@"disable_sound_notification"];
}

- (void)setStatusUpdateBehavior:(int)aBehavior {
	[fPrefData setInteger:aBehavior forKey:@"status_update_behavior"];
}

- (int)statusUpdateBehavior {
	return [fPrefData integerForKey:@"status_update_behavior"];
}

- (BOOL)swapMenuItemBehavior {
	return [fPrefData boolForKey:@"swap_menu_item_behavior"];
}

- (BOOL)useTwelveHour {
	return [fPrefData boolForKey:@"use_twelve_hour"];
}

- (BOOL)disableTopView {
	return [fPrefData boolForKey:@"disable_top_view"];
}

- (BOOL)usePOSTMethod {
	return [fPrefData boolForKey:@"use_POST_method"];
}

- (BOOL)disableWindowShadow {
	return [fPrefData boolForKey:@"disable_window_shadow"];
}

- (BOOL)hideWithQuickReadShortcut {
	return [fPrefData boolForKey:@"hide_with_quick_read_shortcut"];
}

- (BOOL)useClassicView {
	return [fPrefData boolForKey:@"use_classic_view"];
}

- (BOOL)postWithModifier {
	return [fPrefData boolForKey:@"post_with_modifier"];
}

- (BOOL)updateAfterPost {
	return [fPrefData boolForKey:@"update_after_post"];
}

- (id)customFilters {
	return [fPrefData objectForKey:@"custom_filters"];
}

- (void)setCustomFilters:(id)aFilters {
	[fPrefData setObject:aFilters forKey:@"custom_filters"];
}

- (BOOL)hideOnDeactivate {
	return [fPrefData boolForKey:@"hide_on_deactivate"];
}

- (BOOL)selectOldestUnread {
	return [fPrefData boolForKey:@"select_oldest_unread"];
}

- (int)urlShorteningService {
	return [fPrefData integerForKey:@"url_shortening_service"];
}

- (int)maxNotification {
	return [fPrefData integerForKey:@"max_notification"];
}

- (BOOL)disableAnimation {
	return [fPrefData boolForKey:@"disable_animation"];
}

- (int)maxTweets {
	int lTempInt = [fPrefData integerForKey:@"max_tweets"];
	if (lTempInt != 0) return lTempInt;
	else {
		[fPrefData setInteger:500 forKey:@"max_tweets"];
		return 500;
	}
}

- (void)setHideDockIcon:(BOOL)aFlag {
	NSString * lFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/../Info.plist"];
	if (lFilePath) {
		if ([[NSFileManager defaultManager] isWritableFileAtPath:lFilePath]) {
			NSMutableDictionary* lPlistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:lFilePath];
			[lPlistDict setValue:[NSNumber numberWithBool:aFlag] forKey:@"LSUIElement"];
			[lPlistDict writeToFile:lFilePath atomically: YES];
			[lPlistDict release];
		}
	}
}

- (BOOL)hideDockIcon {
	NSString *lFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/../Info.plist"];
	NSMutableDictionary* lPlistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:lFilePath];
	BOOL lShouldHide = [[lPlistDict objectForKey:@"LSUIElement"] boolValue];
	[lPlistDict release];
	return lShouldHide;
}

@end
