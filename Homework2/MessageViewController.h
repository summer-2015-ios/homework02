//
//  MessageViewController.h
//  Homework2
//
//  Created by student on 7/30/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse.h>

@interface MessageViewController : UIViewController
@property PFUser* toUser;
@property Class sourceVC;
@end
