//
//  VLYMainViewController.m
//  ValayAdmin
//
//  Created by Andre Creighton on 7/27/17.
//  Copyright © 2017 Andre Creighton. All rights reserved.
//

#import "VLYMainViewController.h"
#import "ContractorTableViewCell.h"
#import "VLYContractor.h"
#import "VLYProfileViewController.h"
@import Firebase;
@import FirebaseDatabase;

@interface VLYMainViewController()<UITableViewDelegate,UITableViewDataSource>


@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray *arrayForPendingContractors;
@property (strong, nonatomic) NSMutableArray *arrayContractors;
@property (strong, nonatomic) NSMutableArray *arrayForApprovedContractors;
@property (strong, nonatomic) NSMutableArray *arrayForDeniedContractors;
@property (weak, nonatomic) IBOutlet UITableView *contractorTableView;
@property (weak, nonatomic) IBOutlet UIView *loadingActivityView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;


@end

@implementation VLYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self grabFirebaseDataForPending];
    
    _contractorTableView.delegate = self;
    _contractorTableView.dataSource = self;
    
    
    UINib *nib = [UINib nibWithNibName:@"ContractorTableViewCell" bundle:nil];
    [self.contractorTableView registerNib:nib forCellReuseIdentifier:@"contractorCell"];
    
    self.arrayContractors = [NSMutableArray new];
    
    
    self.arrayForPendingContractors = [NSMutableArray new];
    self.arrayForDeniedContractors  = [NSMutableArray new];
    self.arrayForApprovedContractors = [NSMutableArray new];
    
    self.loadingActivityView.alpha = 1;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.contractorTableView reloadData];
    
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"%lu", self.arrayContractors.count);
    
    return self.arrayContractors.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ContractorTableViewCell *cell = [_contractorTableView dequeueReusableCellWithIdentifier:@"contractorCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.serviceLbl.text = @"Service";
    
    cell.contractorNameLbl.text = self.arrayContractors[indexPath.row][@"name"];
    
    NSString *service = self.arrayContractors[indexPath.row][@"serviceProviding"][@"service"];
    
    if (service == NULL) {
        
        cell.serviceLbl.text = @"Service";
    }else{
        
        cell.serviceLbl.text = service;
        
    }
    
    return cell;
    
    
}

-(void)grabFirebaseDataForDeclined{
    
    NSLog(@"grabFirebaseDataForDeclined");
    
    self.ref = [[[FIRDatabase database] reference] child:@"contractors"];
    
    [self.ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        
        NSMutableArray *newArray = [NSMutableArray new];
        
        [self.arrayForDeniedContractors removeAllObjects];
        
        
        [newArray addObjectsFromArray: [snapshot.value allValues]];
        
        
        
        
        for (NSDictionary *contractorData in newArray) {
            
            
            if([contractorData[@"flag"] isEqualToString:@"2"]) {
                
                // Get contractors who has a key 'flag' and add them to Array.
                NSLog(@"%@", contractorData);
                
                [self.arrayForDeniedContractors addObject:contractorData];
                
                
            }
            
            
        }
        
        [self.arrayContractors addObjectsFromArray:self.arrayForDeniedContractors];

        [self.contractorTableView reloadData];
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.loadingActivityView.alpha = 0;
            
        }];
        
        
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
        
    }];
    
    
}

-(void)grabFirebaseDataForApproved{
    
    NSLog(@"grabFirebaseDataForApproved");
    
    self.ref = [[[FIRDatabase database] reference] child:@"contractors"];
    
    [self.ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        

        
        NSMutableArray *newArray = [NSMutableArray new];
        
        [self.arrayForApprovedContractors removeAllObjects];
        
        
        [newArray addObjectsFromArray: [snapshot.value allValues]];
        
        
        
        for (NSDictionary *contractorData in newArray) {
            
            
            if([contractorData[@"flag"] isEqualToString:@"1"]) {
                
                // Get contractors who has a key 'flag' and add them to Array.
                NSLog(@"%@", contractorData);
                
                [self.arrayForApprovedContractors addObject:contractorData];
                
            
                
            }
            
            
        }
        
        [self.arrayContractors addObjectsFromArray:self.arrayForApprovedContractors];
        [self.contractorTableView reloadData];
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.loadingActivityView.alpha = 0;
            
        }];
        
        
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
        
    }];
    

}

-(void)grabFirebaseDataForPending{
    
    NSLog(@"grabFirebaseDataForPending");
    
    self.ref = [[[FIRDatabase database] reference] child:@"contractors"];
    
    
    
    [self.ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        
        
        NSMutableArray *newArray = [NSMutableArray new];
        [self.arrayForPendingContractors removeAllObjects];
        
        
        [newArray addObjectsFromArray: [snapshot.value allValues]];
        
        
        
        for (NSDictionary *contractorData in newArray) {
            
            
            if([contractorData[@"flag"] isEqualToString:@"0"]) {
                
                // Get contractors who has a key 'flag' and add them to Array.
                
                
                [self.arrayForPendingContractors addObject:contractorData];
               
                
                
            }
            
            
        }
        [self.arrayContractors addObjectsFromArray:self.arrayForPendingContractors];
        
        [self.contractorTableView reloadData];
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.loadingActivityView.alpha = 0;
            
        }];
        
        
    } withCancelBlock:^(NSError * _Nonnull error) {
       
        NSLog(@"%@", [error localizedDescription]);

        
        
    }];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 80;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [self performSegueWithIdentifier:@"contractor" sender:self];
    
    
}


- (IBAction)segmentTapped:(id)sender {
    
    if(self.segmentedControl.selectedSegmentIndex == 1){
        //Proceed to show contractors who are approved
        
        [self.arrayContractors removeAllObjects];
        self.loadingActivityView.alpha = 1;
        [self grabFirebaseDataForApproved];
        
        NSLog(@"Selected index 1");
    
    }else if(self.segmentedControl.selectedSegmentIndex == 0){
        //Show contractors who are pending
        
        [self.arrayContractors removeAllObjects];
        self.loadingActivityView.alpha = 1;
        [self grabFirebaseDataForPending];
        
        NSLog(@"Selected index 0");
        
    }else if(self.segmentedControl.selectedSegmentIndex == 2){
        //Show contractors who are declined
        
        [self.arrayContractors removeAllObjects];
        self.loadingActivityView.alpha = 1;
        [self grabFirebaseDataForDeclined];
        
        NSLog(@"Selected index 2");
        
        
    }
    
}

- (IBAction)refreshButtonTapped:(id)sender {
    
    if(self.segmentedControl.selectedSegmentIndex == 1){
        
        self.loadingActivityView.alpha = 1;
        [self.arrayContractors removeAllObjects];
        [self grabFirebaseDataForApproved];
        
        
        NSLog(@"Selected index 1");
        
    }else if(self.segmentedControl.selectedSegmentIndex == 0){

        self.loadingActivityView.alpha = 1;
        [self.arrayContractors removeAllObjects];
        [self grabFirebaseDataForPending];
        
        
        NSLog(@"Selected index 0");
        
        
        
    }else if(self.segmentedControl.selectedSegmentIndex == 2){
        
        self.loadingActivityView.alpha = 1;
        [self.arrayContractors removeAllObjects];
        [self grabFirebaseDataForDeclined];
        
        
        NSLog(@"Selected index 2");
        
        
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    NSLog(@"performSegueWithIdentifier");
    
    if([segue.identifier isEqualToString:@"contractor"]){
        
        NSLog(@"Identifier");
        
        NSIndexPath *indexPath = [self.contractorTableView indexPathForSelectedRow];
        VLYProfileViewController *profileVC = segue.destinationViewController;
        profileVC.contractorId = self.arrayContractors[indexPath.row][@"id"];
        
        
    }
    
    
}

@end
