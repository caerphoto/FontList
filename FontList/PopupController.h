//
//  PopupController.h
//  FontList
//
//  Created by Andrew Farrell on 21/10/2014.
//  Copyright (c) 2014 Andrew Farrell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PopupController : NSWindowController

@property (weak) IBOutlet NSWindow *popupPreview;
@property (unsafe_unretained) IBOutlet NSTextView *editor;
@property (weak) IBOutlet NSPopUpButton *fontStylePopup;
@property (weak) IBOutlet NSTextField *fontSize;
@property (weak) IBOutlet NSStepper *fontSizeStepper;

@property NSFont *font;
@property NSColor *textColor;
@property NSColor *backgroundColor;
@property NSUInteger listIndex;
@property NSMutableArray *windowList;

- (NSArray *)postScriptNamesFromStyles:(NSArray *) styles;
- (NSArray *)styleNamesFromStyles:(NSArray *) styles;

- (NSFont *)font;
- (void)setFont:(NSFont *)font;
- (void)setTextColor:(NSColor *)textColor;
- (void)setBackgroundColor:(NSColor *)backgroundColor;
- (IBAction)takeFontStyleFrom:(id)sender;
- (IBAction)takeFontSizeFrom:(id)sender;

@end
