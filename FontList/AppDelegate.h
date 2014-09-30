//
//  AppDelegate.h
//  FontList
//
//  Created by Andrew Farrell on 21/09/2014.
//  Copyright (c) 2014 Andrew Farrell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (weak) IBOutlet NSTableView *mainListView;
@property (weak) IBOutlet NSTextField *previewTextField;
@property (weak) IBOutlet NSTextField *fontSizeField;
@property (weak) IBOutlet NSStepper *fontSizeStepper;
@property (weak) IBOutlet NSTableCellView *listCell;

- (IBAction)takePreviewTextFrom:(id)sender;
- (IBAction)takeFontSizeFrom:(id)sender;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)mainFontList;
- (NSView *)tableView:(NSTableView *)mainFontList viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

@end

NSString *previewText;
NSArray *fontFamilies;
NSArray *filteredFontFamilies;
NSUInteger fontSize;