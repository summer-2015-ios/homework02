//
//  ForumMesageViewController.m
//  Homework2
//
//  Created by student on 7/30/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "ForumMesageViewController.h"
#import <Parse.h>
#import "Common.h"

@interface ForumMesageViewController ()
@property (weak, nonatomic) IBOutlet UITextView *msgTxt;

@end

@implementation ForumMesageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Common colorTextView:self.msgTxt];
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
- (IBAction)submitClicked:(id)sender {
    if(self.msgTxt.text.length == 0){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Create Forum Error"
                                                                       message:@"A message is mandatory"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    PFObject* forum = [PFObject objectWithClassName:@"Forum"];
    forum[@"user"] = [PFUser currentUser];
    forum[@"text"] = self.msgTxt.text;
    [forum saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error) {
            NSLog(@"error saving forum %@", error);
            return;
        }
        [self performSegueWithIdentifier:@"forumMsgToForumsSegue" sender:self];
    }];
}

@end
