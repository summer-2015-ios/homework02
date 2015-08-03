//
//  InviteViewController.m
//  Homework2
//
//  Created by student on 7/31/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "InviteViewController.h"
#import <Parse.h>

@interface InviteViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTV;
@property (weak, nonatomic) IBOutlet UITextView *textTV;

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)submitClicked:(UIButton *)sender {
    if(self.emailTV.text.length == 0 || self.textTV.text.length == 0){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"All fields mandatory"
                                                                       message:@"Please enter all fields"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"to"] = self.emailTV.text;
   
    NSString* body = [NSString stringWithFormat:@"%@ <br/> %@", self.textTV.text, [NSString stringWithFormat:@"<a href=\"hw2://www.uncc.edu/?email=%@\">Click Here!</a>", self.emailTV.text]];
    NSLog(@"email body : %@", body);
    params[@"text"] = body;
    PFUser* user = [PFUser currentUser];
    params[@"subject"] = [NSString stringWithFormat:@"Invitation from %@ %@ to try out forums app", user[@"firstName"], user[@"lastName"]];
    [PFCloud callFunctionInBackground:@"sendEmail"
                       withParameters:params
                                block:^(id object, NSError *error) {
                                    if(error){
                                        NSLog(@"Sending email failed : %@", error);
                                        return;
                                    }
                                    
                                     [self performSegueWithIdentifier:@"inviteToUsersSegue" sender:self];
                                }
     ];
   
}

@end
