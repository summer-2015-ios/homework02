//
//  MessageViewController.m
//  Homework2
//
//  Created by student on 7/30/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "MessageViewController.h"
#import <ParseUI.h>
#import <MBProgressHUD.h>

@interface MessageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicIV;
@property (weak, nonatomic) IBOutlet UITextView *msgTV;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profilePicIV.layer.cornerRadius = self.profilePicIV.frame.size.width/2;
    self.profilePicIV.clipsToBounds = YES;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.toUser[@"firstName"], self.toUser[@"lastName"]];
    if((PFFile *) self.toUser[@"profilePic"]){
        self.profilePicIV.file = (PFFile *) self.toUser[@"profilePic"];
        [self.profilePicIV loadInBackground];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)submitClicked:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFObject* message = [PFObject objectWithClassName:@"Message"];
    message[@"from"] = [PFUser currentUser];
    message[@"to"] = self.toUser;
    message[@"text"] = self.msgTV.text;
    message[@"isRead"] = @NO;
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(error) {
            NSLog(@"error saving message %@", error);
            return;
        }
        [self goBackToInitiator];
    }];
}
-(void) goBackToInitiator{
    [self performSegueWithIdentifier:@"messageToUserSegueBySubmit" sender:self];
}
@end
