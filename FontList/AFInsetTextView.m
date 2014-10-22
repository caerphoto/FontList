//
//  AFInsetTextView.m
//  FontList
//
//  Created by Andrew Farrell on 22/10/2014.
//  Copyright (c) 2014 Andrew Farrell. All rights reserved.
//  Implementation based on answer at
//  http://stackoverflow.com/questions/1951272/giving-an-nstextview-some-padding-a-margin

#import "AFInsetTextView.h"

@implementation AFInsetTextView

- (void)awakeFromNib {
    [super setTextContainerInset:NSMakeSize(15.0f, 10.0f)];
}

@end
