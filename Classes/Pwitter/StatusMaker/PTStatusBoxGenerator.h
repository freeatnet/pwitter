//
//  PTStatusBoxGenerator.h
//  Pwitter
//
//  Created by Akihiro Noguchi on 4/01/09.
//  Copyright 2009 Aki. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PTStatusBox.h"


@interface PTStatusBoxGenerator : NSObject {
    IBOutlet id fMainController;
}
- (PTStatusBox *)constructStatusBox:(NSDictionary *)aStatusInfo isReply:(BOOL)aIsReply isRetweet:(BOOL)aIsRetweet;
- (PTStatusBox *)constructErrorBox:(NSError *)aError;
- (PTStatusBox *)constructMessageBox:(NSDictionary *)aStatusInfo;

@end
