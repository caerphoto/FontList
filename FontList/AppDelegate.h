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
@property (weak) IBOutlet NSTextField *filterField;
@property (weak) IBOutlet NSButton *chkItalic;
@property (weak) IBOutlet NSButton *chkBold;
@property (weak) IBOutlet NSTextField *statusBar;

@property (copy) NSString *filterText;
@property (copy) NSString *previewText;
@property (copy) NSArray *fontFamilies;
@property (copy) NSMutableArray *filteredFontFamilies;
@property (assign) NSUInteger fontSize;

- (IBAction)takeFilterFrom:(id)sender;
- (IBAction)takePreviewTextFrom:(id)sender;
- (IBAction)takeFontSizeFrom:(id)sender;
- (IBAction)takeColorFrom:(NSColorWell *)sender;
- (IBAction)styleFilterWasChangedBy:(id)sender;

- (void)loadSettings;
- (NSString *)styleStringFromFlags:(NSUInteger)flags;
- (NSUInteger)styleFlagsForFontName:(NSString *)fontName;
- (void)applyFilters;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)mainFontList;
- (NSView *)tableView:(NSTableView *)mainFontList viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

@end
