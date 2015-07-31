//
//  ForumsViewController.m
//  Homework2
//
//  Created by student on 7/30/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "ForumsViewController.h"
#import <Parse.h>
#import <MBProgressHUD.h>
#import <ParseUI.h>

@interface ForumsViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray* forums;
@end

@implementation ForumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [self fetchForums];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) fetchForums{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery* forumsQuery = [PFQuery queryWithClassName:@"Forum"];
    [forumsQuery orderByAscending:@"createdAt"];
    [forumsQuery includeKey:@"user"];
    [forumsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error) {
            NSLog(@"error fetching messages %@", error);
            return;
        }
        self.forums = [NSMutableArray arrayWithArray:objects];
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"forumsToForumMsgSegue"]){
        
    }
}

# pragma mark - UITableViewDataSource implementation
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.forums.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }
    UILabel* textLabel = (UILabel*)[cell viewWithTag:2002];
    PFObject* forum = (PFObject*)self.forums[indexPath.row];
    textLabel.text = forum[@"text"];
    
    PFUser* user  = forum[@"user"];
    ((UILabel*)[cell viewWithTag:2001]).text = [NSString stringWithFormat:@"%@ %@", user[@"firstName"], user[@"lastName"]];
    
    PFImageView* imageView = (PFImageView*)[cell viewWithTag:2000];
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.clipsToBounds = YES;
    imageView.image = [UIImage imageNamed:@"avatar-placeholder-2"];
    if(user[@"profilePic"]){
        imageView.file = user[@"profilePic"];
        [imageView loadInBackground ];
    }
    
    if([[PFUser currentUser].objectId isEqual:user.objectId]){
        [((UIButton*)[cell viewWithTag:2003]) setHidden:NO];
    }else{
        [((UIButton*)[cell viewWithTag:2003]) setHidden:YES];
    }
    
    return cell;
}

-(IBAction)backFromForumMessageVCByCancel:(UIStoryboardSegue*)segue{
    NSLog(@"back from forum message vc by cancel");
}
-(IBAction)backFromForumMessageVCBySubmit:(UIStoryboardSegue*)segue{
    NSLog(@"back from forum message vc by submit");
}
@end
