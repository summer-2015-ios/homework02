//
//  UsersViewController.m
//  Homework2
//
//  Created by student on 7/30/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "UsersViewController.h"
#import <Parse.h>
#import <MBProgressHUD.h>
#import <ParseUI.h>
#import "UserViewController.h"

@interface UsersViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray* users;
@end

@implementation UsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUsers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadUsers{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery* usersQuery = [PFUser query];
    [usersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error) {
            NSLog(@"error fetching events %@", error);
            return;
        }
        self.users = [NSArray arrayWithArray:objects];
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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
    
    PFImageView *userProfilePic = (PFImageView*)[cell viewWithTag:2000];
    userProfilePic.layer.cornerRadius = userProfilePic.frame.size.width / 2;
    userProfilePic.clipsToBounds = YES;
    
    userProfilePic.image = [UIImage imageNamed:@"avatar-placeholder-2"];
    if((PFFile *) user[@"profilePic"]){
        userProfilePic.file = (PFFile *) user[@"profilePic"];
        [userProfilePic loadInBackground];
    }
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"usersToUserSegue"]) {
        UserViewController* vc = [segue destinationViewController];
        UITableViewCell* cell = (UITableViewCell*) sender;
        long row = [self.tableView indexPathForCell:cell].row;
        vc.user = (PFUser*)self.users[row];
        NSLog(@"Sending model %@", vc.user);
    }
}


@end
