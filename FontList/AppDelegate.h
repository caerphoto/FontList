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
@property (weak) IBOutlet NSColorWell *textColorWell;
@property (weak) IBOutlet NSColorWell *backgroundColorWell;



@property (copy) NSString *previewText;
@property (copy) NSArray *fontFamilies;
@property (copy) NSArray *filteredFontFamilies;
@property (assign) NSUInteger fontSize;

- (IBAction)takePreviewTextFrom:(id)sender;
- (IBAction)takeFontSizeFrom:(id)sender;
- (IBAction)takeColorFrom:(NSColorWell *)sender;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)mainFontList;
- (NSView *)tableView:(NSTableView *)mainFontList viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

@end