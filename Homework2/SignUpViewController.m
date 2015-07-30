//
//  SignUpViewController.m
//  InClass07
//
//  Created by student on 7/16/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/PFUser.h>

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameTV;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTV;
@property (weak, nonatomic) IBOutlet UITextField *emailTV;
@property (weak, nonatomic) IBOutlet UITextField *passwordTV;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTV;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitBtnClicked:(id)sender {
    // error checks here
    if(self.passwordTV.text && ![self.passwordTV.text isEqualToString:self.confirmPasswordTV.text]){
        
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sign Up Error"
                                                                           message:@"Passwords do not match"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;

    }
    if([self.emailTV.text length] ==0  || [self.passwordTV.text length]== 0 || [self.emailTV.text length] ==0 || [self.firstNameTV.text length] ==0 || [self.lastNameTV.text length] ==0 ){
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sign Up Error"
                                                                       message:@"All are mandatory fields"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;

    }
    
    PFUser* user = [PFUser user];
    user.username = self.emailTV.text;
    user.password = self.passwordTV.text;
    user.email = self.emailTV.text;
    user[@"firstName"] = self.firstNameTV.text;
    user[@"lastName"] = self.lastNameTV.text;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sign Up Error"
                                                                           message:[error description]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        [self performSegueWithIdentifier:@"signUpToEventsSegue" sender:self];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
