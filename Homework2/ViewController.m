//
//  ViewController.m
//  Homework2
//
//  Created by student on 7/30/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "ViewController.h"
#import <Parse.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *loginTV;
@property (weak, nonatomic) IBOutlet UITextField *passwordTV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    if([PFUser currentUser]){
        // go to Events
        [self performSegueWithIdentifier:@"loginToEventsSegue" sender:self];
        return;
    }else{
        NSLog(@"no logged in user");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginClicked:(UIButton *)sender {
    [PFUser logInWithUsernameInBackground:self.loginTV.text
                                 password:self.passwordTV.text block:^(PFUser *user, NSError *error) {
                                     if(error){
                                         NSLog(@"Error loging in: %@", error);
                                         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login Error"
                                                                                                        message:@"Could not login. Please verify credentials"
                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                         
                                         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                               handler:^(UIAlertAction * action) {}];
                                         
                                         [alert addAction:defaultAction];
                                         [self presentViewController:alert animated:YES completion:nil];
                                         return;
                                     }
                                     if(!user){
                                         NSLog(@"user not found");
                                         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login Error"
                                                                                                        message:@"No user found. Please verify credentials"
                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                         
                                         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                               handler:^(UIAlertAction * action) {}];
                                         
                                         [alert addAction:defaultAction];
                                         [self presentViewController:alert animated:YES completion:nil];
                                         
                                         return;
                                     }
                                     NSLog(@"User : %@", user);
                                     // go to events
                                     [self performSegueWithIdentifier:@"loginToEventsSegue" sender:self];
                                     return;
                                     
                                 }];
}

-(IBAction)cancelFromSinUp:(UIStoryboardSegue* )segue{
    NSLog(@"Cancel back from Signup");
}


@end
