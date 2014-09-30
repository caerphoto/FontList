//
//  AppDelegate.m
//  FontList
//
//  Created by Andrew Farrell on 21/09/2014.
//  Copyright (c) 2014 Andrew Farrell. All rights reserved.
//

#import "AppDelegate.h"
#import "AFColoredTableCellView.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

@synthesize previewText;
@synthesize fontSize;
@synthesize fontFamilies;
@synthesize filteredFontFamilies;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSFontManager *manager = [NSFontManager sharedFontManager];
    NSArray *unsortedSysFonts = [manager availableFontFamilies];
    fontFamilies = [unsortedSysFonts sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    unsortedSysFonts = nil;

    previewText = @"The quick brown fox jumps over the lazy dog";
    fontSize = [self.fontSizeField integerValue];
    
    [self.mainListView setDelegate:(id)self];
    [self.mainListView setDataSource:(id)self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    fontFamilies = nil;
}

- (IBAction)takePreviewTextFrom:(id)sender {
    NSString *newText = [sender stringValue];
    if (newText != nil && [newText length] == 0) {
        newText = [self.previewTextField.cell placeholderString];
    }
    previewText = newText;
    
    [self.mainListView reloadData];
}

- (IBAction)takeFontSizeFrom:(id)sender {
    NSInteger newValue = [sender integerValue];
    
    if ([[sender identifier] isEqualToString:@"FontSizeField"]) {
        self.fontSizeStepper.integerValue = newValue;
    } else {
        self.fontSizeField.integerValue = newValue;
    }
    
    fontSize = newValue;
    [self.mainListView reloadData];
}

- (IBAction)takeColorFrom:(NSColorWell *)sender {
    // Don't need to do anything else - the view rendering code will handle it.
    [self.mainListView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)mainFontList {
    return [fontFamilies count];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return fontSize * 1.5;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSString *fontName = [fontFamilies objectAtIndex:row];

    if ([tableColumn.identifier isEqualToString:@"NameColumn"]) {
        NSTableCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        result.textField.stringValue = fontName;
        return result;
        
    } else {
        AFColoredTableCellView *result = [[AFColoredTableCellView alloc] init];
        result.backgroundFill = self.backgroundColorWell.color;
        result.textColor = self.textColorWell.color;
        result.font = fontName;//[NSFont fontWithName:fontName size:fontSize];
        result.fontSize = (CGFloat)fontSize;
        result.text = previewText;

        return result;
    }

    return nil;
}

@end
