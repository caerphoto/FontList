//
//  BKGradientView.h
//  FontList
//
//  Created by Andrew Farrell on 02/10/2014.
//  Based on code from http://www.katoemba.net/makesnosenseatall/2008/01/09/nsview-with-gradient-background/
//  Copyright (c) 2014 Andrew Farrell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BKGradientView : NSView {
    NSColor *startingColor;
    NSColor *endingColor;
    NSInteger angle;
}

// Define the variables as properties
@property(nonatomic, retain) IBOutlet NSColor *startingColor;
@property(nonatomic, retain) IBOutlet NSColor *endingColor;
@property(assign) NSInteger angle;

@end
