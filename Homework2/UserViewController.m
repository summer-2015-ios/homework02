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

@interface UserViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *changePhotoBtn;
@property (weak, nonatomic) IBOutlet PFImageView *userProPicIV;
@property UIImagePickerController* libraryUI;
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
    if((PFFile *) self.user[@"profilePic"]){
        self.userProPicIV.file = (PFFile *) self.user[@"profilePic"];
        [self.userProPicIV loadInBackground];
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
    [self createPhotoAlbumViewer];
}
-(void) createPhotoAlbumViewer{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        NSLog(@"photo library view not available");
        return;
    }
    //NSArray* mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
   // NSLog(@"media Types %@", mediaTypes);
    self.libraryUI = [[UIImagePickerController alloc] init];
    self.libraryUI.mediaTypes = @[@"public.image"];
    self.libraryUI.allowsEditing = YES;
    self.libraryUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.libraryUI.delegate = self;
    [self presentViewController:self.libraryUI
                       animated:YES
                     completion:nil];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
  //  NSLog(@"Got info %@", info);
    [self.libraryUI dismissViewControllerAnimated:YES completion:nil];
    UIImage* selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.user[@"profilePic"] = [PFFile fileWithData:UIImagePNGRepresentation(selectedImage)];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error) {
            NSLog(@"error saving profile pic %@", error);
            return;
        }
        self.userProPicIV.image = selectedImage;
    }];
}
@end
