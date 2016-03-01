//
//  SOCTableViewController.m
//  StackOverflowChallenge
//
//  Created by Cafex-Development on 28/02/16.
//  Copyright © 2016 Cafex-Development. All rights reserved.
//

#import "SOCTableViewController.h"
#import "SOCApiRequestManager.h"
#import "Constants.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UILoadingView.h"
#import "SOCAppDelegate.h"
#import "User.h"

#define CellNameLabelTagValue               10
#define CellGoldLabelTagValue               20
#define CellSilverLabelTagValue             30
#define CellBronzeLabelTagValue             40

@interface SOCTableViewController ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) NSMutableArray *managedUsers;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation SOCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //initialize managedObjectContext from AppDelegate's shared managedObjectContext
    if (!self.managedObjectContext) {
        self.managedObjectContext = ((SOCAppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    }
    [self initializeFetchedResultsController];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // if CoreData object graph is empty, fetch response from stackoverflow server
    if ([[[self.fetchedResultsController sections] firstObject] numberOfObjects] <= 0) {
        [self fetchUsersFromServer];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 Fetch response from stackoverflow user api.
 */
-(void)fetchUsersFromServer
{
    _managedUsers = [[NSMutableArray alloc]init];
    
    [self.tableView setHidden:YES];
    UILoadingView *loadingsvc = [[UILoadingView alloc]initWithFrame:self.loadingView.frame];
    [_loadingView addSubview:loadingsvc];
    SOCApiRequestManager *apiManager = [[SOCApiRequestManager alloc]init];
    [apiManager fetchUsersWithUrl:kUsersEndPoint completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error == nil)
        {
            NSOperationQueue *jsonQueue = [[NSOperationQueue alloc] init];
            [jsonQueue addOperationWithBlock:^{
                
                // Background work
                NSError *error1;
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error1];
                NSArray *jsonUsers = [jsonDict objectForKey:@"items"];
                for (id userDict in jsonUsers) {
                    User *user = (User*)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
                    user.name = [userDict objectForKey:@"display_name"];
                    user.goldBadge = [NSNumber numberWithInt:[[[userDict objectForKey:@"badge_counts"] objectForKey:@"gold"] intValue]];
                    user.silverBadge = [NSNumber numberWithInt:[[[userDict objectForKey:@"badge_counts"] objectForKey:@"silver"] intValue]];
                    user.bronzeBadge = [NSNumber numberWithInt:[[[userDict objectForKey:@"badge_counts"] objectForKey:@"bronze"] intValue]];
                    user.gravatar = [userDict objectForKey:@"profile_image"];
                    [_managedUsers addObject:user];
                }
                [self saveUser:_managedUsers];
                NSLog(@"Users %lu", (unsigned long)[_managedUsers count]);
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Main thread work (UI usually)
                    [_loadingView sendSubviewToBack:self.view];
                    [self initializeFetchedResultsController];
                    [self.tableView setHidden:NO];
                    [self.tableView reloadData];
                    
                }];
            }];
            
            
            
        }
    }];

}
#pragma mark - Table view data source
/**
 Set number of sections based on fetchedResultsController'sections
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}
/**
 set data source of tableView based on records in CoreData object graph.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    // Fetch Record
    User *socuser = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Here we use the new provided sd_setImageWithURL: method to load the web image
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:socuser.gravatar]
                      placeholderImage:[UIImage imageNamed:@"placeholder"]];
    UILabel *nameLabel = (UILabel*)[cell viewWithTag:CellNameLabelTagValue];
    nameLabel.text = socuser.name;
    UILabel *goldLabel = (UILabel*)[cell viewWithTag:CellGoldLabelTagValue];
    goldLabel.text = [NSString stringWithFormat:@"%@",socuser.goldBadge];
    UILabel *silverLabel = (UILabel*)[cell viewWithTag:CellSilverLabelTagValue];
    silverLabel.text = [NSString stringWithFormat:@"%@",socuser.silverBadge];
    UILabel *bronzeLabel = (UILabel*)[cell viewWithTag:CellBronzeLabelTagValue];
    bronzeLabel.text = [NSString stringWithFormat:@"%@",socuser.bronzeBadge];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Core Data stack

/**
 Save records in CoreData object graph.
 */
-(void)saveUser:(NSArray*)jsonUsers
{
    for (User *user in jsonUsers) {
        
        NSError *error;
        [self.managedObjectContext save:&error];
        if (error) {
            NSLog(@"error in saving data %@", error);
        }
    }
}

/**
Fetch records from CoreData object graph.
*/
- (void)initializeFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    NSSortDescriptor *lastNameSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    [request setSortDescriptors:@[lastNameSort]];
    
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil]];
    [[self fetchedResultsController] setDelegate:self];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}
@end
