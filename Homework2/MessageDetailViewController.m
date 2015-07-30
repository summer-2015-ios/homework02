//
//  MessageDetailViewController.m
//  Homework2
//
//  Created by student on 7/30/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "MessageDetailViewController.h"
#import <ParseUI.h>

@interface MessageDetailViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profilePicIV;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profilePicIV.layer.cornerRadius = self.profilePicIV.frame.size.width/2;
    self.profilePicIV.clipsToBounds = YES;
    self.profilePicIV.image = [UIImage imageNamed:@"avatar-placeholder-2"];
    self.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@", ((PFUser*)self.message[@"from"])[@"firstName"], ((PFUser*)self.message[@"from"])[@"lastName"]];
    if((PFFile *) ((PFUser*)self.message[@"from"])[@"profilePic"]){
        self.profilePicIV.file = (PFFile *) ((PFUser*)self.message[@"from"])[@"profilePic"];
        [self.profilePicIV loadInBackground];
    }
    self.messageLabel.text = self.message[@"text"];
    self.message[@"isRead"] = @YES;
    [self.message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            NSLog(@"error saving read status %@", error);
            return;

        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
