		var requestJSON 	= 	structNew();
		var merchantStruct 	= 	structNew();
		var transactStruct 	= 	structNew();
		var paymentStruct 	= 	structNew();
		var lineItemStruct 	= 	structNew();
		var dutyStruct 		= 	structNew();
		var shippingStruct 	= 	structNew();
		var taxStruct 		= 	structNew();
		var billTo			=	structNew();
		var shipTo			=	structNew();
		var items			=	ArrayNew(1);
		var metadata        =   structNew();

		requestJSON['createTransactionRequest'] = structNew();

		//Add Merchant Details
		merchantStruct['name'] = variables.loginId;
		merchantStruct['transactionKey'] = variables.transactionKey;
		requestJSON['createTransactionRequest']['merchantAuthentication'] = merchantStruct;

		//Add Ref ID
		if(structKeyExists(arguments.payload,'refID')){
			requestJSON['createTransactionRequest']['refId'] =	arguments.payload.refid;
		}
		else{
			requestJSON['createTransactionRequest']['refId'] =	'11111';
		}

       //structClear(metadata);
       refMetadata  =   structNew();
       refMetadata['refId'] = structNew();
       refMetadata['refId']['type']    =   'string';

       requestJSON.createTransactionRequest.setMetadata(refMetadata);


		//TransactionRequest
		transactStruct['transactionType'] = 'authCaptureTransaction';
		transactStruct['amount'] = arguments.payload.amount;
		requestJSON['createTransactionRequest']['transactionRequest']				=	transactStruct;
       
       //structClear(metadata);	
       amtMetaData  =   structNew();
       amtMetaData['amount'] = structNew();
       amtMetaData['amount']['type']    =   'string';	
       
       requestJSON['createTransactionRequest']['transactionRequest'].setMetaData(amtMetaData); 


		//Payment Info
		requestJSON['createTransactionRequest']['transactionRequest']['payment'] = structNew();		
		paymentStruct['creditCard']	= structNew();
		paymentStruct['creditCard']['cardNumber']		=	arguments.payload.cardNumber;
		paymentStruct['creditCard']['expirationDate']	=	arguments.payload.expirationDate;
		paymentStruct['creditCard']['cardCode']			=	arguments.payload.cardCode;
	   //structClear(metadata);
	   payMetaData  =   structNew();
       payMetaData['cardNumber'] = structNew();
       payMetaData['cardNumber']['type']    =   'string';
       payMetaData['expirationDate'] = structNew();
       payMetaData['expirationDate']['type']    =   'string';
       payMetaData['cardCode'] = structNew();
       payMetaData['cardCode']['type']    =   'string';       


		requestJSON['createTransactionRequest']['transactionRequest']['payment']	=	paymentStruct;
		
		requestJSON['createTransactionRequest']['transactionRequest']['payment']['creditCard'].setMetaData(payMetaData);		


		//Lineitems as Array of struct
		if(structKeyExists(arguments.payLoad,'lineItems') AND structKeyExists(arguments.payLoad.lineItems,'lineItem')){
			items = arguments.payLoad.lineItems.lineItem;
			for (recs in items) {
				lineItemStruct['itemId']		=	recs.itemId;
				lineItemStruct['name']			=	recs.name;
				lineItemStruct['description']	=	recs.description;
				lineItemStruct['quantity']		=	recs.quantity;
				lineItemStruct['unitPrice']		=	recs.unitPrice;
			
			  
			   lineItemMetaData =   structNew();
			   lineItemMetaData['itemId']   =   structNew();
			   lineItemMetaData['itemId']['type'] = 'string';
			   lineItemMetaData['quantity']   =   structNew();
			   lineItemMetaData['quantity']['type'] = 'string';
			   lineItemMetaData['unitPrice']   =   structNew();
			   lineItemMetaData['unitPrice']['type'] = 'string';			   
			   
			   requestJSON['createTransactionRequest']['transactionRequest']['lineItems']['lineItem']	=	lineItemStruct;
			   
                requestJSON['createTransactionRequest']['transactionRequest']['lineItems']['lineItem'].setMetaData(lineItemMetaData);			   
			}
		}

		//Tax Information
		if(structKeyExists(arguments.payLoad,'tax')){
				taxStruct['amount']			=	arguments.payLoad.tax.amount;
				taxStruct['name']			=	arguments.payLoad.tax.name;
				taxStruct['description']	=	arguments.payLoad.tax.description;
				
				taxMetaData =   structNew();
				taxMetaData['amount']   =   structNew();
				taxMetaData['amount']['type']   =   'string';
				
			requestJSON['createTransactionRequest']['transactionRequest']['tax']	=	taxStruct;
			requestJSON['createTransactionRequest']['transactionRequest']['tax'].setMetaData(taxMetaData);
		}

		//Duty Information
		if(structKeyExists(arguments.payLoad,'duty')){
				dutyStruct['amount']		=	arguments.payLoad.duty.amount;
				dutyStruct['name']			=	arguments.payLoad.duty.name;
				dutyStruct['description']	=	arguments.payLoad.duty.description;
				
				dutyMetaData =   structNew();
				dutyMetaData['amount']   =   structNew();
				dutyMetaData['amount']['type']   =   'string';				
				requestJSON['createTransactionRequest']['transactionRequest']['duty']	=	dutyStruct;
				
				requestJSON['createTransactionRequest']['transactionRequest']['duty'].setMetaData(dutyMetaData);
		}

		//Shipping Information
		if(structKeyExists(arguments.payLoad,'shipping')){
				shippingStruct['amount']		=	arguments.payLoad.shipping.amount;
				shippingStruct['name']			=	arguments.payLoad.shipping.name;
				shippingStruct['description']	=	arguments.payLoad.shipping.description;
				
				shipMetaData =   structNew();
				shipMetaData['amount']   =   structNew();
				shipMetaData['amount']['type']   =   'string';				
				requestJSON['createTransactionRequest']['transactionRequest']['shipping']	=	shippingStruct;
				
                requestJSON['createTransactionRequest']['transactionRequest']['shipping'].setMetaData(shipMetaData);			
		}

		//PO Number
		if(structKeyExists(arguments.payLoad,'poNumber')){
			
			    poMetaData  =   structNew();
			    poMetaData['poNumber']  =   structNew();
			    poMetaData['poNumber']['type']  =   'string';
			  requestJSON['createTransactionRequest']['transactionRequest']['poNumber']	=	arguments.payLoad.poNumber;
			  requestJSON['createTransactionRequest']['transactionRequest'].setMetaData(poMetaData);			  
		}

		//Customer ID Number
		if(structKeyExists(arguments.payLoad,'customer')){
			
			        idMetaData  =   structNew();
			        idMetaData['id']    =   structNew();
			        idMetaData['id']['type']    =   'string';
			    requestJSON['createTransactionRequest']['transactionRequest']['customer']['id']	=	arguments.payLoad.customer.id;
			    
			    requestJSON['createTransactionRequest']['transactionRequest']['customer'].setMetaData(idMetaData);
			    
		}

		//billTo Information
		if(structKeyExists(arguments.payLoad,'billTo')){
				billToStruct['firstName']		=	arguments.payLoad.billTo.firstName;
				billToStruct['lastName']		=	arguments.payLoad.billTo.lastName;
				billToStruct['company']			=	arguments.payLoad.billTo.company;
				billToStruct['address']			=	arguments.payLoad.billTo.address;
				billToStruct['city']			=	arguments.payLoad.billTo.city;
				billToStruct['state']			=	arguments.payLoad.billTo.state;
				billToStruct['zip']				=	arguments.payLoad.billTo.zip;
				billToStruct['country']			=	arguments.payLoad.billTo.country;

			    billStruct  =   structNew();
			    billStruct['zip']   =   structNew();
			    billStruct['zip']['type']   =   'string';
				requestJSON['createTransactionRequest']['transactionRequest']['billTo']	=	billToStruct;
				
				requestJSON['createTransactionRequest']['transactionRequest']['billTo'].setMetaData(billStruct);
		}

		//shipTo Information
		if(structKeyExists(arguments.payLoad,'shipTo')){
				shipToStruct['firstName']		=	arguments.payLoad.shipTo.firstName;
				shipToStruct['lastName']		=	arguments.payLoad.shipTo.lastName;
				shipToStruct['company']			=	arguments.payLoad.shipTo.company;
				shipToStruct['address']			=	arguments.payLoad.shipTo.address;
				shipToStruct['city']			=	arguments.payLoad.shipTo.city;
				shipToStruct['state']			=	arguments.payLoad.shipTo.state;
				shipToStruct['zip']				=	arguments.payLoad.shipTo.zip;
				shipToStruct['country']			=	arguments.payLoad.shipTo.country;

				shipStruct  =   structNew();
			    shipStruct['zip']   =   structNew();
			    shipStruct['zip']['type']   =   'string';
				requestJSON['createTransactionRequest']['transactionRequest']['shipTo']	=	shipToStruct;
				
				requestJSON['createTransactionRequest']['transactionRequest']['shipTo'].setMetaData(shipStruct);
		}

		//Customer IP
		if(structKeyExists(arguments.payLoad,'customerIP')){
		
				custIPStruct  =   structNew();
			    custIPStruct['customerIP']   =   structNew();
			    custIPStruct['customerIP']['type']   =   'string';
				requestJSON['createTransactionRequest']['transactionRequest']['customerIP']	=	arguments.payLoad.customerIP;
                requestJSON['createTransactionRequest']['transactionRequest'].setMetaData(custIPStruct);				
		}

		//TransactionRequest Type
		transactSettingStruct 	=	structNew();
		transactSettingStruct['setting']	=	structNew();
		transactSettingStruct['setting']['settingName']	=	'testRequest';
		transactSettingStruct['setting']['settingValue']	=	'false';
		
		transactStruct  =   structNew();
		transactStruct['settingValue']  =   structNew();
		transactStruct['settingValue']['type']  =   'string';

		requestJSON['createTransactionRequest']['transactionRequest']['transactionSettings']	=	transactSettingStruct;
		
		requestJSON['createTransactionRequest']['transactionRequest']['transactionSettings']['setting'].setMetaData(transactStruct);		
		
		writedump('#serializeJSON(requestJSON)#');

		cfhttp(method="GET", charset="utf-8", url="#apiTestURL#", result="result") {
		    cfhttpparam(type="header",name="Content-Type", value="application/json,text/javascript,*/*");
		    cfhttpparam(type="header",name="Accept-Language", value="en-US,en;q=0.8,id;q=0.6");
		    cfhttpparam(type="body", value="#serializeJSON(requestJSON)#");
		}

		writedump('#result#');
	}

}
