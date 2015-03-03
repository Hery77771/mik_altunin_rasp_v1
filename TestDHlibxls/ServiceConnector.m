//
//  ServiceConnector.m
//  Service Reader
//
//  Created by Divan Visagie on 2012/08/25.
//  Copyright (c) 2012 Divan Visagie. All rights reserved.
//

#import "ServiceConnector.h"

@implementation ServiceConnector{
    NSData *receivedData;;
}

-(void)updateChangeDate{
    
    //build up the request that is to be sent to the server
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.mati-sched.tk/index.php"]];
    
    
    //initialize an NSURLConnection  with the request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!connection){
        NSLog(@"Connection Failed");
    }
}

#pragma mark - Data connection delegate -

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{ // executed when the connection receives data
    
    receivedData = data;
    /* NOTE: if you are working with large data , it may be better to set recievedData as NSMutableData 
             and use  [receivedData append:Data] here, in this event you should also set recievedData to nil
             when you are done working with it or any new data received could end up just appending to the 
             last message received*/
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{ //executed when the connection fails
    
    NSLog(@"Connection failed with error: %@",error.localizedDescription);
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
    /*This message is sent when there is an authentication challenge ,our server does not have this requirement so we do not need to handle that here*/
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSLog(@"Request Complete,recieved %d bytes of data",receivedData.length);
    
    [self.delegate requestReturnedData:receivedData];//send the data to the delegate
}

@end
