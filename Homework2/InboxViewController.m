//
//  InboxViewController.m
//  Homework2
//
//  Created by student on 7/30/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "InboxViewController.h"
#import <Parse.h>
#import <MBProgressHUD.h>
#import <ParseUI.h>
#import "MessageDetailViewController.h"
#import "MessageViewController.h"

@interface InboxViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray* messages;
@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewDidAppear:(BOOL)animated{
    [self loadMessages];
}
-(void) loadMessages{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery* messagesQuery = [PFQuery queryWithClassName:@"Message"];
    [messagesQuery whereKey:@"to" equalTo:[PFUser currentUser]];
    [messagesQuery orderByDescending:@"createdAt"];
    [messagesQuery includeKey:@"from"];
    [messagesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error) {
            NSLog(@"error fetching messages %@", error);
            return;
        }
        self.messages = [NSMutableArray arrayWithArray:objects];
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
# pragma mark - UITableViewDataSource implementation
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }
    UILabel* nameLabel = (UILabel*)[cell viewWithTag:2001];
    PFObject* message = (PFObject*)self.messages[indexPath.row];
    PFUser* sender = (PFUser*)message[@"from"];
    nameLabel.text = [NSString stringWithFormat:@"%@ %@", sender[@"firstName"], sender[@"lastName"]];
    
    ((UILabel*)[cell viewWithTag:2002]).text = message[@"text"];
    
    PFImageView* imageView = (PFImageView*)[cell viewWithTag:2000];
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.clipsToBounds = YES;
    imageView.image = [UIImage imageNamed:@"avatar-placeholder-2"];
    if(sender[@"profilePic"]){
        imageView.file = sender[@"profilePic"];
        [imageView loadInBackground ];
    }
    
    if ([(NSNumber*)message[@"isRead"] boolValue]) {
        [((UILabel*)[cell viewWithTag:2003]) setHidden:YES];
    }else{
        [((UILabel*)[cell viewWithTag:2003]) setHidden:NO];
    }
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"inboxToMessageDetailSegue"]){
        MessageDetailViewController* vc = [segue destinationViewController];
        UITableViewCell* cell = (UITableViewCell*) sender;
        long row = [self.tableView indexPathForCell:cell].row;
        vc.message = (PFObject*)self.messages[row];
        NSLog(@"Sending model %@", vc.message);
    }else if([segue.identifier isEqualToString:@"inboxToMessageSegue"]){
        MessageViewController* vc = segue.destinationViewController;
        vc.sourceVC = [self class];
    }
}
- (IBAction)deleteClicked:(UIButton *)sender {
    UITableViewCell* clickedCell = (UITableViewCell*)sender.superview.superview;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:clickedCell];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete Message"
                                                                   message:@"Do you really want to delete this message?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self.messages[indexPath.row] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                                  if(error){
                                                                      NSLog(@"error deleting message %@", error);
                                                                      return;
                                                                  }
                                                                  [self loadMessages];
                                                              }];
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {}];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
-(IBAction)backToInboxFromMessageByCancel:(UIStoryboardSegue*)segue{
    NSLog(@"back from message by cancel");
}
-(IBAction)backToInboxFromMessageBySubmit:(UIStoryboardSegue*)segue{
    NSLog(@"back from message by submit");
}

@end
