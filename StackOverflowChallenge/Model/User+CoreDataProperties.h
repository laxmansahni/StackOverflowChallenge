//
//  User+CoreDataProperties.h
//  
//
//  Created by Cafex-Development on 29/02/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)
//properties of ManagedObjetModel User
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *goldBadge;
@property (nullable, nonatomic, retain) NSNumber *silverBadge;
@property (nullable, nonatomic, retain) NSNumber *bronzeBadge;
@property (nullable, nonatomic, retain) NSString *gravatar;
@end

NS_ASSUME_NONNULL_END
