//
//  ViewController.m
//  Homework2
//
//  Created by student on 7/30/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "ViewController.h"
#import <Parse.h>
#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import "SignUpViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *loginTV;
@property (weak, nonatomic) IBOutlet UITextField *passwordTV;
//@property NSString* emailFromUrl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(segueToSignUp:)
//                                                 name:@"emailFromUrlReceived"
//                                               object:nil];

    if([PFUser currentUser]){
        // go to Main
        [self performSegueWithIdentifier:@"loginToMainVCSegue" sender:self];
        return;
    }else{
        NSLog(@"no logged in user");
//        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
//        if(delegate.emailFromUrl.length){
//            [self performSegueWithIdentifier:@"signUpSegue" sender:self];
//        }
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"VC disappeared");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"emailFromUrlReceived" object:nil];
}
-(void)dealloc{
}
-(void) segueToSignUp:(NSNotification*) notification{
    NSLog(@"Notification received: trying to segue");
    self.emailFromUrl = notification.userInfo[@"email"];
    [self performSegueWithIdentifier:@"signUpSegue" sender:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginClicked:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PFUser logInWithUsernameInBackground:self.loginTV.text
                                 password:self.passwordTV.text block:^(PFUser *user, NSError *error) {
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
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
                                     // go to mainVC
                                     [self performSegueWithIdentifier:@"loginToMainVCSegue" sender:self];
                                     return;
                                     
                                 }];
}

-(IBAction)cancelFromSinUp:(UIStoryboardSegue* )segue{
    NSLog(@"Cancel back from Signup");
}
- (IBAction)createNewACClicked:(UIButton *)sender {
    //self.emailFromUrl = nil;
    [self performSegueWithIdentifier:@"signUpSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"signUpSegue"]){
        //AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        if(self.emailFromUrl.length){
            SignUpViewController* vc = segue.destinationViewController;
            vc.emailFromInvite = self.emailFromUrl;
        }
//        else{
//             AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
//            delegate.emailFromUrl = nil;
//        }
    }
}

@end
