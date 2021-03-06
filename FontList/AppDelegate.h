//
//  AppDelegate.h
//  FontList
//
//  Created by Andrew Farrell on 21/09/2014.
//  Copyright (c) 2014 Andrew Farrell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AFColoredTableCellView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (weak) IBOutlet NSTableView *mainListView;
@property (weak) IBOutlet NSTextField *previewTextField;
@property (weak) IBOutlet NSTextField *fontSizeField;
@property (weak) IBOutlet NSStepper *fontSizeStepper;
@property (weak) IBOutlet NSColorWell *textColorWell;
@property (weak) IBOutlet NSColorWell *backgroundColorWell;
@property (weak) IBOutlet NSTextField *filterField;
@property (weak) IBOutlet NSButton *chkItalic;
@property (weak) IBOutlet NSButton *chkBold;
@property (weak) IBOutlet NSTextField *statusBar;
@property (weak) IBOutlet NSButton *reloadButton;
@property (weak) IBOutlet NSProgressIndicator *reloadingSpinner;

@property (strong) NSMutableArray *lstPreviewWindows;

@property (weak) IBOutlet NSPanel *aboutWindow;
@property (weak) IBOutlet NSImageView *aboutIcon;

@property (copy) NSString *filterText;
@property (nonatomic, copy) NSString *previewText;
@property (copy) NSArray *fontFamilies;
@property (copy) NSMutableArray *filteredFontFamilies;
@property (assign) NSUInteger fontSize;
@property (retain) NSTimer *previewTextTimer;

- (IBAction)takeFilterFrom:(id)sender;
- (IBAction)takeFontSizeFrom:(id)sender;
- (IBAction)takeColorFrom:(NSColorWell *)sender;
- (IBAction)styleFilterWasChangedBy:(id)sender;
- (IBAction)showPopupPreviewFor:(id)sender;
- (IBAction)reloadFonts:(id)sender;
- (IBAction)viewInFontBook:(id)sender;

- (IBAction)showAboutWindow:(id)sender;

- (void)loadSettings;
- (void)saveSettings;
- (void)applyFilters;
- (void)fetchFontFamilies;
- (NSInteger)listIndexFromFontName:(NSString *)fontName;
- (void)updateUI;
- (NSString *)styleStringFromFlags:(NSUInteger)flags;
- (NSUInteger)styleFlagsForFontName:(NSString *)fontName;
- (NSFont *)fontFromCurrentStateWithName:(NSString *)fontName;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)mainFontList;
- (NSView *)tableView:(NSTableView *)mainFontList viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

@end
