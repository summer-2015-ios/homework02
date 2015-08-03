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
#import "InboxViewController.h"
#import "UserViewController.h"
#import "MessageDetailViewController.h"
#import "Common.h"

@interface MessageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicIV;
@property (weak, nonatomic) IBOutlet UITextView *msgTV;

@end

@implementation MessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [Common colorTextView:self.msgTV];
    self.profilePicIV.layer.cornerRadius = self.profilePicIV.frame.size.width/2;
    self.profilePicIV.clipsToBounds = YES;
    if(self.toUser){
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.toUser[@"firstName"], self.toUser[@"lastName"]];
        self.profilePicIV.image = [UIImage imageNamed:@"avatar-placeholder-2"];
        if((PFFile *) self.toUser[@"profilePic"]){
            self.profilePicIV.file = (PFFile *) self.toUser[@"profilePic"];
            [self.profilePicIV loadInBackground];
        }
    }else{
        [self.nameButton setHidden:NO];
        [self.nameLabel setHidden:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"sendMessageToSelectUserSegue"]){
        NSLog(@"");
    }
}

- (IBAction)submitClicked:(id)sender {
    if(!self.toUser || self.msgTV.text.length == 0){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Send Message Error"
                                                                       message:@"A recipient and message is mandatory"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
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
- (IBAction)cancelClicked:(id)sender {
    if(self.sourceVC == [InboxViewController class]){
        [self performSegueWithIdentifier:@"messageToInboxSegueByCancel" sender:self];
        return;
    }else if (self.sourceVC == [UserViewController class]){
        [self performSegueWithIdentifier:@"messageToUserSegueByCancel" sender:self];
    }else if(self.sourceVC == [MessageDetailViewController class]){
        [self performSegueWithIdentifier:@"messageToMessageDetailSegueByCancel" sender:self];
    }
}
-(void) goBackToInitiator{
    if(self.sourceVC == [UserViewController class]){
        [self performSegueWithIdentifier:@"messageToUserSegueBySubmit" sender:self];
    }else if(self.sourceVC == [InboxViewController class]){
        [self performSegueWithIdentifier:@"messageToInboxSegueBySubmit" sender:self];
    } else if(self.sourceVC == [MessageDetailViewController class]){
        [self performSegueWithIdentifier:@"messageToMessageDetailSegueBySubmit" sender:self];
    }
}
- (IBAction)selectUserClicked:(UIButton *)sender {
    
}

#pragma mark - Unwind
-(IBAction)backFromULVC:(UIStoryboardSegue*)segue{
    NSLog(@"selected User : %@", self.toUser);
    [self.nameButton setHidden:YES];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.toUser[@"firstName"], self.toUser[@"lastName"]];
    self.profilePicIV.image = [UIImage imageNamed:@"avatar-placeholder-2"];
    if((PFFile *) self.toUser[@"profilePic"]){
        self.profilePicIV.file = (PFFile *) self.toUser[@"profilePic"];
        [self.profilePicIV loadInBackground];
    }
    [self.nameLabel setHidden:NO];
}

@end
