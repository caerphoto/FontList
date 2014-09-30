//
//  AppDelegate.m
//  FontList
//
//  Created by Andrew Farrell on 21/09/2014.
//  Copyright (c) 2014 Andrew Farrell. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

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

- (NSInteger)numberOfRowsInTableView:(NSTableView *)mainFontList {
    NSUInteger count = [fontFamilies count];
    return count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return lroundf(fontSize * 1.5);
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    NSString *contentText;
    NSString *fontName = [fontFamilies objectAtIndex:row];
    
    if ([tableColumn.identifier isEqualToString:@"NameColumn"]) {
        contentText = fontName;
    } else {
        cellView.textField.font = [NSFont fontWithName:fontName size:fontSize];
        //cellView.textField.font

        if (previewText == nil) {
            contentText = [[self.previewTextField cell] placeholderString];
        } else {
            contentText = [previewText substringFromIndex:0];
        }
        
    }
    
    cellView.textField.stringValue = contentText;
    return cellView;
}

@end
