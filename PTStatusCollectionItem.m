//
//  PTStatusCollectionItem.m
//  Pwitter
//
//  Created by Akihiro Noguchi on 26/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PTStatusCollectionItem.h"
#import "PTStatusEntityView.h"
#import "PTStatusBox.h"

@implementation PTStatusCollectionItem

- (void)setSelected:(BOOL)flag {
	[super setSelected:flag];
	// tell the view that it has been selected
	PTStatusEntityView* theView = (PTStatusEntityView* )[self view];
	if([theView isKindOfClass:[PTStatusEntityView class]]) {
		[theView setSelected:flag];
		[theView setNeedsDisplay:YES];
	}
}

@end