//
//  Common.m
//  Homework2
//
//  Created by student on 8/3/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "Common.h"
@import UIKit;

@implementation Common

+(void) colorTextView:(UITextView*) textView{
    [textView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [textView.layer setBorderWidth:1.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    textView.layer.cornerRadius = 5;
    textView.clipsToBounds = YES;
}

@end
