//
//  BKGradientView.m
//  FontList
//
//  Created by Andrew Farrell on 02/10/2014.
//  Copyright (c) 2014 Andrew Farrell. All rights reserved.
//

#import "BKGradientView.h"

@implementation BKGradientView

// Automatically create accessor methods
@synthesize startingColor;
@synthesize endingColor;
@synthesize angle;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setStartingColor:[NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0]];
        [self setEndingColor:[NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0.2]];
        [self setAngle:270];
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    if (endingColor == nil || [startingColor isEqual:endingColor]) {
        // Fill view with a standard background color
        [startingColor set];
        NSRectFill(rect);
    }
    else {
        // Fill view with a top-down gradient
        // from startingColor to endingColor
        NSGradient* aGradient = [[NSGradient alloc]
                                 initWithStartingColor:startingColor
                                 endingColor:endingColor];
        [aGradient drawInRect:[self bounds] angle:angle];
    }
}
@end
