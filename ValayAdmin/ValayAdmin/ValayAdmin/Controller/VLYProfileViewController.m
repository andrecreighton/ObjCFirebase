//
//  VLYProfileViewController.m
//  ValayAdmin
//
//  Created by Andre Creighton on 7/28/17.
//  Copyright © 2017 Andre Creighton. All rights reserved.
//

#import "VLYProfileViewController.h"
#import "VLYContractor.h"
#import <SDWebImage/UIImageView+WebCache.h>

@import Firebase;
@import FirebaseDatabase;

@interface VLYProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *cellPhoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameOfServiceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoDocImageView;

@property (weak, nonatomic) IBOutlet UILabel *serviceTypeLabel;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRDatabaseReference *flagRef;
@property (strong, nonatomic) VLYContractor *contractor;
@property (strong, nonatomic) NSMutableString *subString;
@end

@implementation VLYProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    [self loadUser];
    
    self.subString = [NSMutableString new];
}


-(void)loadUser{
    
    
    NSLog(@"LOAD USER");
    NSLog(@"%@", self.contractorId);
    
    self.ref = [[[[FIRDatabase database] reference] child:@"contractors"] child:self.contractorId];
    
    [self.ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSLog(@"%@", snapshot.value);
        
        NSMutableArray *newArray = [[NSMutableArray alloc]initWithObjects:snapshot.value, nil];
        
    
        self.contractor = [[VLYContractor alloc] initWithUserId:newArray[0][@"id"]
                                                           name:newArray[0][@"name"]
                                                  streetAddress:newArray[0][@"otherInfo"][@"street"]
                                                           city:newArray[0][@"otherInfo"][@"city"]
                                                          state:newArray[0][@"otherInfo"][@"state"]
                                                        zipCode:newArray[0][@"otherInfo"][@"postalCode"]
                                                       photoUrl:newArray[0][@"photoData"]
                                                     photoIdUrl:newArray[0][@"photoDoc"][@"documentUrl"]
                                                          email:newArray[0][@"email"]
                                                        contact:newArray[0][@"phoneNumber"]
                                                        service:newArray[0][@"serviceProviding"][@"service"]
                                                    subServices:newArray[0][@"services"]

                           ];
        
        [self updateUI];
        
        
    }];
    
}

-(void)updateUI{
    
    
    [self.navigationItem setTitle:self.contractor.name];
    
    self.emailLabel.text = self.contractor.email;
    
    self.cellPhoneLabel.text = self.contractor.contact;
                                
    if(self.contractor.streetAddress == NULL && self.contractor.city == NULL && self.contractor.state == NULL && self.contractor.state == NULL && self.contractor.zipCode == NULL){
        
        self.addressLabel.text = @"No address available";
    }else{
        
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@,%@ %@",self.contractor.streetAddress, self.contractor.city, self.contractor.state, self.contractor.zipCode];
        
    }
    
    self.nameOfServiceLabel.text = self.contractor.serviceName;
    
    for (NSString *subService in self.contractor.subServices){
        
        [self.subString appendFormat:@"%@ ",subService];
    
        
    }

    self.serviceTypeLabel.text = self.subString;
    
    NSLog(@"%@", self.contractor.photoUrl);
    
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:self.contractor.photoUrl] placeholderImage:[UIImage imageNamed:@"User"]];
    
    [self.photoDocImageView sd_setImageWithURL:[NSURL URLWithString:self.contractor.photoIdUrl]];
    

}




- (IBAction)whenApproveButtonTapped:(id)sender {
    
    //present
    
    [self alertControllerApproveWithMessage:@"Approve"];
    
    
}

- (IBAction)whenDeniedButtonTapped:(id)sender {
    
    [self alertControllerDeniedWithMessage:@"Decline"];
    
    
}


-(void)alertControllerApproveWithMessage:(NSString *)message{
    
    NSString *alertMessage = [NSString stringWithFormat:@"%@ this contractor?", message];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
   
        
    }];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        
        //change flag value to 1.
        
        [self changeFlagToApprove];
        
        
        
    }];
    
    
    [alertController addAction:noAction];
    [alertController addAction:yesAction];
    
    
    
    [self presentViewController:alertController animated:true completion:nil];
    
}

-(void)alertControllerDeniedWithMessage:(NSString *)message{
    
    NSString *alertMessage = [NSString stringWithFormat:@"%@ this contractor?", message];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        //change flag value to 2.
        
        [self changeFlagToDecline];
        
        
        
    }];
    
    
    [alertController addAction:noAction];
    [alertController addAction:yesAction];
    
    
    
    [self presentViewController:alertController animated:true completion:nil];
    
}



-(void)changeFlagToApprove{
    
    NSLog(@"Approve");
    
    [[[[[[FIRDatabase database] reference] child:@"contractors"] child:self.contractorId] child:@"flag"] setValue:@"1"];
    
    [self.navigationController popViewControllerAnimated:true];
    
    
}

-(void)changeFlagToDecline{
    
    NSLog(@"Decline");
    
 
    [[[[[[FIRDatabase database] reference] child:@"contractors"] child:self.contractorId] child:@"flag"] setValue:@"2"];
    
    [self.navigationController popViewControllerAnimated:true];
    
    

}
- (IBAction)whenBackButtonTapped:(id)sender {
    
    
    
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)clearUser:(id)sender {
    
    NSString *alertMessage = @"Clear this user?";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"YES ACTION");

                
                [[[[[FIRDatabase database] reference] child:@"contractors"] child:self.contractorId] removeValue];
                [self.navigationController popViewControllerAnimated:true];
        
        }];
    
    
    [alertController addAction:cancelAction];
    [alertController addAction:yesAction];
    
    
    
    [self presentViewController:alertController animated:true completion:nil];
    

}

-(void)messageForErrorDeletingUser{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Uh-oh" message:@"Error trying to delete user. Try again" preferredStyle:UIAlertControllerStyleAlert];

    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    
    [alertController addAction:yesAction];
    
    
    
    [self presentViewController:alertController animated:true completion:nil];
    
}


@end
