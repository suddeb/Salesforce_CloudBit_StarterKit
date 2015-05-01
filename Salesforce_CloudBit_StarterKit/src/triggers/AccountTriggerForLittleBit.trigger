trigger AccountTriggerForLittleBit on Account (after insert,after update) {
	for(Account anAccount : [SELECT ID FROM ACCOUNT WHERE ID IN: Trigger.new AND Rating = 'Hot']){
		LittleBitConnector.sendOutputReqAsync(100,10000); //100% Power, 10 Seconds (10,000 milliseconds)
	}
	
	for(Account anAccount : [SELECT ID FROM ACCOUNT WHERE ID IN: Trigger.new AND Rating = 'Warm']){
		LittleBitConnector.sendOutputReqAsync(75,10000); //75% Power, 10 Seconds (10,000 milliseconds)
	}
	
	for(Account anAccount : [SELECT ID FROM ACCOUNT WHERE ID IN: Trigger.new AND Rating = 'Cold']){
		LittleBitConnector.sendOutputReqAsync(50,10000); //50% Power, 10 Seconds (10,000 milliseconds)
	}
}