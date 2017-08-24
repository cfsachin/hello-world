component displayname="AuthorizeNet" hint="Talk to Authorize.net API"{
	Variables.apiTestURL = "https://apitest.authorize.net/xml/v1/request.api";
	Variables.apiLiveURL = "https://apitest.authorize.net/xml/v1/request.api";
	Variables.apiVersion = 3.1;
	Variables.transactionKey = '6d85aNJW392zSeDE';
	Variables.loginId = '4fT62PFdna';

	Variables.responseDelimeter = "|";
	Variables.payLoadStruct = structNew();

	public string function SendOrderToAuthorizeNet(required struct payload)
	returnformat="JSON" {

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
				requestJSON['createTransactionRequest']['transactionRequest']['lineItems']['lineItem']	=	lineItemStruct;
			}
		}

		//Tax Information
		if(structKeyExists(arguments.payLoad,'tax')){
				taxStruct['amount']			=	arguments.payLoad.tax.amount;
				taxStruct['name']			=	arguments.payLoad.tax.name;
				taxStruct['description']	=	arguments.payLoad.tax.description;
				requestJSON['createTransactionRequest']['transactionRequest']['tax']	=	taxStruct;
		}

		//Duty Information
		if(structKeyExists(arguments.payLoad,'duty')){
				dutyStruct['amount']		=	arguments.payLoad.duty.amount;
				dutyStruct['name']			=	arguments.payLoad.duty.name;
				dutyStruct['description']	=	arguments.payLoad.duty.description;
				requestJSON['createTransactionRequest']['transactionRequest']['duty']	=	dutyStruct;
		}

		//Shipping Information
		if(structKeyExists(arguments.payLoad,'shipping')){
				shippingStruct['amount']		=	arguments.payLoad.shipping.amount;
				shippingStruct['name']			=	arguments.payLoad.shipping.name;
				shippingStruct['description']	=	arguments.payLoad.shipping.description;
				requestJSON['createTransactionRequest']['transactionRequest']['shipping']	=	shippingStruct;
		}

		//PO Number
		if(structKeyExists(arguments.payLoad,'poNumber')){
				requestJSON['createTransactionRequest']['transactionRequest']['poNumber']	=	arguments.payLoad.poNumber;
		}

		//Customer ID Number
		if(structKeyExists(arguments.payLoad,'customer')){
				requestJSON['createTransactionRequest']['transactionRequest']['customer']['id']	=	arguments.payLoad.customer.id;
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

				requestJSON['createTransactionRequest']['transactionRequest']['billTo']	=	billToStruct;
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

				requestJSON['createTransactionRequest']['transactionRequest']['shipTo']	=	shipToStruct;
		}

		//Customer IP
		if(structKeyExists(arguments.payLoad,'customerIP')){
				requestJSON['createTransactionRequest']['transactionRequest']['customerIP']	=	arguments.payLoad.customerIP;
		}

		//TransactionRequest Type
		transactSettingStruct 	=	structNew();
		transactSettingStruct['setting']	=	structNew();
		transactSettingStruct['setting']['settingName']	=	'testRequest';
		transactSettingStruct['setting']['settingValue']	=	'false';

		requestJSON['createTransactionRequest']['transactionRequest']['transactionSettings']	=	transactSettingStruct;
		writedump('#serializeJSON(requestJSON)#');

		cfhttp(method="GET", charset="utf-8", url="#apiTestURL#", result="result") {
		    cfhttpparam(type="header",name="Content-Type", value="application/json,text/javascript,*/*");
		    cfhttpparam(type="header",name="Accept-Language", value="en-US,en;q=0.8,id;q=0.6");
		    cfhttpparam(type="body", value="#serializeJSON(requestJSON)#");
		}

		writedump('#result#');
	}

}
