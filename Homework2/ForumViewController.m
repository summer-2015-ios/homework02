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

@interface ForumViewController () <UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property NSMutableArray* comments;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UIImagePickerController* libraryUI;
//@property UIImage* selectedCommentImage;
@property UIImageView* commentImageIV;
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
            
            if(comment[@"commentImage"]){
                PFImageView* commentImageView = (PFImageView*)[cell viewWithTag:2004];
                commentImageView.file = comment[@"commentImage"];
                [commentImageView loadInBackground];
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
        {
            PFObject* comment = (PFObject*)self.comments[indexPath.row - 2];
            if(!comment[@"commentImage"]){
                cellIdentifier = @"commentCell";
            }else{
                cellIdentifier = @"commentCellWithImage";
            }
            break;
        }
    }
    return cellIdentifier;
}
- (IBAction)postClicked:(UIButton *)sender {
    UITableViewCell* commentCell = (UITableViewCell*) sender.superview.superview;
    UITextField* commentTF = (UITextField*)[commentCell viewWithTag:2001];
    if ([commentTF.text length] == 0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Empty Comment"
                                                                       message:@"Empty Comment not allowed"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
   
    PFImageView* commentImage = (PFImageView*)[commentCell viewWithTag:2002];
    PFObject* comment = [PFObject objectWithClassName:@"ForumComment"];
    comment[@"text"] = commentTF.text;
    comment[@"forum"] = self.forum;
    comment[@"commenter"] = [PFUser currentUser];
    if(self.commentImageIV.image){
        comment[@"commentImage"] = [PFFile fileWithData:UIImagePNGRepresentation(self.commentImageIV.image)];
    }
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error) {
            NSLog(@"error saiving comment %@", error);
            return;
        }
        self.commentImageIV.image = nil;
        commentImage.image = nil;
        commentTF.text = @"";
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self loadForumComments];
    }];
}
- (IBAction)addPhotoClicked:(UIButton *)sender {
    if(!self.commentImageIV){
        self.commentImageIV = (UIImageView*)[sender.superview viewWithTag:2002];
    }
    [self createPhotoAlbumViewer];
}
- (IBAction)deleteCommentClicked:(UIButton*)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete Comment"
                                                                   message:@"Do you really want to delete this comment?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                         UITableViewCell* commentCell = (UITableViewCell*) sender.superview.superview;
                                                         long row = ((NSIndexPath*)[self.tableView indexPathForCell:commentCell]).row;
                                                         // adjusting for comment indices;
                                                         row -=2;
                                                         PFObject* comment = self.comments[row];
                                                         [comment deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                             if(error) {
                                                                 NSLog(@"error deleting comment %@", error);
                                                                 return;
                                                             }
                                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                             [self loadForumComments];
                                                         }];

                                                     }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - Image Picker
-(void) createPhotoAlbumViewer{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        NSLog(@"photo library view not available");
        return;
    }
    self.libraryUI = [[UIImagePickerController alloc] init];
    self.libraryUI.mediaTypes = @[@"public.image"];
    self.libraryUI.allowsEditing = YES;
    // self.libraryUI.
    self.libraryUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.libraryUI.delegate = self;
    [self presentViewController:self.libraryUI
                       animated:YES
                     completion:nil];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    //  NSLog(@"Got info %@", info);
    [self.libraryUI dismissViewControllerAnimated:YES completion:nil];
    UIImage* selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.commentImageIV.image = selectedImage;
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
