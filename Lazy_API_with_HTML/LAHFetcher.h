//
//  LAHFetcher.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHProtocols.h"
#import "LAHRecognizer.h"
@class LAHGreffier;
@interface LAHFetcher : LAHRecognizer {
    NSString *_key;
    LAHPropertyGetter _property;
    LAHGreffier *_greffier;
}
@property(nonatomic, copy)NSString *key;
@property(nonatomic, copy)LAHPropertyGetter property;
@property(nonatomic, assign)LAHGreffier *greffier;
- (id)initWithKey:(NSString*)key property:(LAHPropertyGetter)property;
- (id)initWithKey:(NSString*)key property:(LAHPropertyGetter)property firstChild:(LAHNode*)firstChild variadicChildren:(va_list)children;
- (id)initWithKey:(NSString*)key property:(LAHPropertyGetter)property children:(LAHNode*)firstChild, ... NS_REQUIRES_NIL_TERMINATION;
@end
