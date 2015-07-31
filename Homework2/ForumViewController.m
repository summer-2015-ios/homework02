//
//  ForumViewController.m
//  Homework2
//
//  Created by student on 7/31/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "ForumViewController.h"
#import <ParseUI.h>
#import <MBProgressHUD.h>

@interface ForumViewController () <UITableViewDataSource>
@property NSMutableArray* comments;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UIImage* selectedCommentImage;
@end

@implementation ForumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [self loadForumComments];
}
-(void) loadForumComments{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery* commentsQuery = [PFQuery queryWithClassName:@"ForumComment"];
    [commentsQuery orderByDescending:@"createdAt"];
    [commentsQuery whereKey:@"forum" equalTo:self.forum];
    [commentsQuery includeKey:@"commenter"];
    [commentsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error) {
            NSLog(@"error fetching forum comments %@", error);
            return;
        }
        self.comments = [NSMutableArray arrayWithArray:objects];
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
    return (self.comments.count + 2);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellIdentifier = [self cellIdentifierForIndexPath:indexPath];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.row) {
        case 0:
        {
            UILabel* textLabel = (UILabel*)[cell viewWithTag:2002];
            textLabel.text = self.forum[@"text"];
            
            PFUser* user  = self.forum[@"user"];
            ((UILabel*)[cell viewWithTag:2001]).text = [NSString stringWithFormat:@"%@ %@", user[@"firstName"], user[@"lastName"]];
            
            PFImageView* imageView = (PFImageView*)[cell viewWithTag:2000];
            imageView.layer.cornerRadius = imageView.frame.size.width/2;
            imageView.clipsToBounds = YES;
            imageView.image = [UIImage imageNamed:@"avatar-placeholder-2"];
            if(user[@"profilePic"]){
                imageView.file = user[@"profilePic"];
                [imageView loadInBackground ];
            }
            break;
        }
        case 1:
        {
            PFImageView* imageView = (PFImageView*)[cell viewWithTag:2000];
            imageView.layer.cornerRadius = imageView.frame.size.width/2;
            imageView.clipsToBounds = YES;
            imageView.image = [UIImage imageNamed:@"avatar-placeholder-2"];
            PFUser* user  = [PFUser currentUser];
            if(user[@"profilePic"]){
                imageView.file = user[@"profilePic"];
                [imageView loadInBackground ];
            }

            break;
        }
        default:
        {
            UILabel* textLabel = (UILabel*)[cell viewWithTag:2002];
            PFObject* comment = (PFObject*)self.comments[indexPath.row - 2];
            textLabel.text = comment[@"text"];
            
            PFUser* user  = comment[@"commenter"];
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
            break;
        }
    }
    return cell;
}

-(NSString*) cellIdentifierForIndexPath:(NSIndexPath*) indexPath{
    NSString* cellIdentifier;
    switch (indexPath.row) {
        case 0:
            cellIdentifier = @"forumMsgCell";
            break;
        case 1:
            cellIdentifier = @"postCommentCell";
            break;
        default:
            cellIdentifier = @"commentCell";
            break;
    }
    return cellIdentifier;
}
- (IBAction)postClicked:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UITableViewCell* commentCell = (UITableViewCell*) sender.superview.superview;
    UITextField* commentTF = (UITextField*)[commentCell viewWithTag:2001];
    PFImageView* commentImage = (PFImageView*)[commentCell viewWithTag:2002];
    PFObject* comment = [PFObject objectWithClassName:@"ForumComment"];
    comment[@"text"] = commentTF.text;
    comment[@"forum"] = self.forum;
    comment[@"commenter"] = [PFUser currentUser];
    if(self.selectedCommentImage){
        comment[@"commentImage"] = [PFFile fileWithData:UIImagePNGRepresentation(self.selectedCommentImage)];
    }
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error) {
            NSLog(@"error saiving comment %@", error);
            return;
        }
        self.selectedCommentImage = nil;
        commentImage.image = nil;
        commentTF.text = @"";
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self loadForumComments];
    }];
}
- (IBAction)addPhotoClicked:(UIButton *)sender {
}
- (IBAction)deleteCommentClicked:(id)sender {
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
