//
//  PTStatusFilterController.h
//  Pwitter
//
//  Created by Akihiro Noguchi on 3/01/09.
//  Copyright 2009 Aki. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PTStatusFilterController : NSObject {
    IBOutlet id fStatusController;
    IBOutlet id fMainActionHandler;
}
- (IBAction)showAll:(id)sender;
- (IBAction)showMessages:(id)sender;
- (IBAction)showReplies:(id)sender;
- (IBAction)showRetweets:(id)sender;
- (IBAction)showUpdates:(id)sender;
- (IBAction)showError:(id)sender;
- (IBAction)showFavorites:(id)sender;
- (IBAction)showMyPosts:(id)sender;
@end
