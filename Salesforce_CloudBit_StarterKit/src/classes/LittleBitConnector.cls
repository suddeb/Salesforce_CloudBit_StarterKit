public class LittleBitConnector {
	private static String endPoint;
	private static String authorization;
	
	//Since my intention is to callout to littleBits from a Trigger, I need to do it Asynchronously.
    @future(callout=true) //callout = true allows HTTP Callout from Apex in Async Context
    public static void sendOutputReqAsync(integer percent, integer duration)
    {
        fetchLittleBitConfiguration();
        LittleBitConnector.sendOutputReq(new OutPutToLitteBit(percent,duration));
    }
    
    //This method will fetch LittleBit Configuration from Custom Settings
    public static void fetchLittleBitConfiguration(){
    	LittleBitConfiguration__c myLittleBitConfiguration = LittleBitConfiguration__c.getValues('Bunty');
    	endPoint = myLittleBitConfiguration.Endpoint__c;
    	authorization = myLittleBitConfiguration.Authorization__c;
    }
    
    //This method will callout to the littleBits Cloud Device
    public static void sendOutputReq(OutPutToLitteBit outputPayload)
    {
        HttpRequest req = new HttpRequest(); 
        
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setEndpoint(endPoint);
        req.setHeader('Authorization',authorization);
        
        //Set the HTTPRequest body 
        req.setBody(JSON.serialize(outputPayload));
        Http http = new Http();
        
        try {
            //Execute web service call here  
            HTTPResponse res = http.send(req); 
            //Helpful debug messages
            System.debug(res.toString());
            System.debug('STATUS:'+res.getStatus());
            System.debug('STATUS_CODE:'+res.getStatusCode());
        } catch(System.CalloutException e) {
            //Exception handling goes here....
        }  
    }
    
    //Request Payload in Apex to hold the values we are sending to littleBits.
    public class OutPutToLitteBit
    {
        //Percent is the amount of output voltage you want to send from 0 to 100% as an integer
        public integer percent {get;set;}
        //Duration is the time you want to set the voltage. 3000 milliseconds is the default as specified in API docs.
        public integer duration_ms {get;set;}
        
        public OutPutToLitteBit(integer inputPercent, integer inputDuration)
        {
            this.percent = inputPercent;
            this.duration_ms = inputDuration;
        }
    }
}