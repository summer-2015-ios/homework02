//
//  UserViewController.m
//  Homework2
//
//  Created by student on 7/30/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "UserViewController.h"
#import <PFUser.h>
#import <ParseUI.h>

@interface UserViewController ()
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *changePhotoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userProPicIV;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userProPicIV.layer.cornerRadius = self.userProPicIV.frame.size.width / 2;
    self.userProPicIV.clipsToBounds = YES;
    if([self.user.objectId isEqual:[PFUser currentUser].objectId]){
        [self.changePhotoBtn setHidden:NO];
    }
    self.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user[@"firstName"], self.user[@"lastName"]];
    self.emailLabel.text = self.user.email;
    PFImageView *userProfilePic = (PFImageView*)self.userProPicIV;
//    userProfilePic.layer.cornerRadius = userProfilePic.frame.size.width / 2;
//    userProfilePic.clipsToBounds = YES;
    
    //userProfilePic.image = [UIImage imageNamed:@"avatar-placeholder-2"];
    if((PFFile *) self.user[@"profilePic"]){
        userProfilePic.file = (PFFile *) self.user[@"profilePic"];
        [userProfilePic loadInBackground];
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
- (IBAction)changePhotoClicked:(id)sender {
}

@end
