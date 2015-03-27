//
//  APIManager.m
//  block
//
//  Created by Noah Portes Chaikin on 3/2/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

//
//  APIManager.m
//  Tourist
//
//  Created by Noah Portes Chaikin on 2/25/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "APIManager.h"
#import "NSDictionary+QueryString.h"
#import "Constants.h"

@interface APIManager () {
    NSOperationQueue *operationQueue;
}
@end

@implementation APIManager

+ (APIManager *)sharedManager {
    static APIManager *sharedManager;
    if (!sharedManager) {
        sharedManager = [[self alloc] init];
    }
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)GET:(NSString *)path
sessionManager:(SessionManager *)sessionManager
     params:(NSDictionary *)params
  onSuccess:(void(^)(NSURLResponse *response, NSData *data))onSuccess
     onFail:(void(^)(NSURLResponse *response, NSData *data))onFail
    onError:(void(^)(NSError *error))onError {
    NSURLRequest *request = [self getRequestWithPath:path
                                      sessionManager:sessionManager
                                              params:params];
    [self sendRequest:request
            onSuccess:onSuccess
               onFail:onFail
              onError:onError];
}

- (void)POST:(NSString *)path
sessionManager:(SessionManager *)sessionManager
      params:(NSDictionary *)params
   onSuccess:(void(^)(NSURLResponse *response, NSData *data))onSuccess
      onFail:(void(^)(NSURLResponse *response, NSData *data))onFail
     onError:(void(^)(NSError *error))onError {
    NSURLRequest *request = [self postRequestWithPath:path
                                       sessionManager:sessionManager
                                               params:params];
    [self sendRequest:request
            onSuccess:onSuccess
               onFail:onFail
              onError:onError];
}

- (void)sendRequest:(NSURLRequest *)request
          onSuccess:(void(^)(NSURLResponse *response, NSData *data))onSuccess
             onFail:(void(^)(NSURLResponse *response, NSData *data))onFail
            onError:(void(^)(NSError *error))onError {
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:operationQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                               if (connectionError) {
                                   onError(connectionError);
                               } else if ([httpResponse statusCode] != 200) {
                                   onFail(response, data);
                               } else {
                                   onSuccess(response, data);
                               }
                           }];
}

- (NSURLRequest *)getRequestWithPath:(NSString *)path
                      sessionManager:(SessionManager *)sessionManager
                              params:(NSDictionary *)params {
    NSURL *url = [self urlWithPath:path
                            params:params
                    sessionManager:sessionManager];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"GET";
    return request;
}

- (NSURLRequest *)postRequestWithPath:(NSString *)path
                       sessionManager:(SessionManager *)sessionManager
                               params:(NSDictionary *)params {
    NSURL *url = [self urlWithPath:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[self paramsStringWithParams:params
                                      sessionManager:sessionManager] dataUsingEncoding:NSUTF8StringEncoding];
    return request;
}

- (NSURL *)urlWithPath:(NSString *)path {
    NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/", IOBaseURL]];
    return [NSURL URLWithString:path relativeToURL:baseURL];
}

- (NSURL *)urlWithPath:(NSString *)path
                params:(NSDictionary *)params
        sessionManager:(SessionManager *)sessionManager  {
    NSURL *url = [self urlWithPath:path];
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url
                                               resolvingAgainstBaseURL:YES];
    components.percentEncodedQuery = [self paramsStringWithParams:params
                                                   sessionManager:sessionManager];
    return [components URL];
}

- (NSString *)paramsStringWithParams:(NSDictionary *)dictionary
                      sessionManager:(SessionManager *)sessionManager {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    if (sessionManager) {
        [params setObject:sessionManager.sessionToken
                   forKey:@"token"];
    }
    return [params queryString];
}

@end
