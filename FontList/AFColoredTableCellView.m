//
//  AFColoredTableCellView.m
//  FontList
//
//  Created by Andrew Farrell on 30/09/2014.
//  Copyright (c) 2014 Andrew Farrell. All rights reserved.
//

#import "AFColoredTableCellView.h"

@implementation AFColoredTableCellView

- (void)drawRect:(NSRect)dirtyRect {
    //[super drawRect:dirtyRect];
    
    NSRect bounds = [self bounds];
    NSPoint origin = NSMakePoint(bounds.origin.x, bounds.origin.y);
    bounds.origin.y += 1;
    origin.x += 5;
    [self.backgroundFill setFill];
    NSRectFill(bounds);
    
    NSFont *font = [NSFont fontWithName:self.font size:self.fontSize];
    
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName,
                                self.textColor, NSForegroundColorAttributeName,
                                nil];
    
    [self.text drawAtPoint:origin withAttributes:attributes];
}

@end
