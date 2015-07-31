//
//  ForumMesageViewController.m
//  Homework2
//
//  Created by student on 7/30/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "ForumMesageViewController.h"
#import <Parse.h>

@interface ForumMesageViewController ()
@property (weak, nonatomic) IBOutlet UITextView *msgTxt;

@end

@implementation ForumMesageViewController

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
- (IBAction)submitClicked:(id)sender {
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
