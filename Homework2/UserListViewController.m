//
//  UserListViewController.m
//  Homework2
//
//  Created by student on 7/30/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "UserListViewController.h"
#import <Parse.h>
#import <ParseUI.h>
#import <MBProgressHUD.h>
#import "MessageViewController.h"

@interface UserListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray* users;
@property PFUser* selectedUser;
@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUsers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - UITableViewDataSource implementation
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.users.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }
    UILabel* title = (UILabel*)[cell viewWithTag:2001];
    PFUser *user = (PFUser*)self.users[indexPath.row];
    title.text =  [NSString stringWithFormat:@"%@ %@", user[@"firstName"], user[@"lastName"]];
    PFImageView* userProfilePic = (PFImageView*)[cell viewWithTag:2000];
    userProfilePic.layer.cornerRadius = userProfilePic.frame.size.width / 2;
    userProfilePic.clipsToBounds = YES;
    // userProfilePic.vi
    userProfilePic.image = [UIImage imageNamed:@"avatar-placeholder-2"];
    if((PFFile *) user[@"profilePic"]){
        userProfilePic.file = (PFFile *) user[@"profilePic"];
        [userProfilePic loadInBackground];
    }
    return cell;
}


-(void) loadUsers{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery* usersQuery = [PFUser query];
    [usersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error) {
            NSLog(@"error fetching events %@", error);
            return;
        }
        self.users = [NSMutableArray arrayWithArray:objects];
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedUser = self.users[indexPath.row];
    [self performSegueWithIdentifier:@"uLVCToMessageVCWithUserSelectionSegue" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"uLVCToMessageVCWithUserSelectionSegue"]){
        MessageViewController* vc = (MessageViewController*)self.presentingViewController;
        vc.selectedUser = self.selectedUser;
    }
}


@end
