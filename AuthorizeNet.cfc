component displayname="AuthorizeNet" hint="Talk to Authorize.net API"{
	Variables.apiTestURL = "https://apitest.authorize.net/xml/v1/request.api";
	Variables.apiLiveURL = "https://api.authorize.net/xml/v1/request.api";
	Variables.apiVersion = 3.1;
	Variables.transactionKey = '6d85aNJW392zSeDE';
	Variables.loginId = '4fT62PFdna';

	Variables.responseDelimeter = "|";
	Variables.payLoadStruct = structNew();

	public string function SendOrderToAuthorizeNet(required struct payload, string options default="#structNew()#")
	returnformat="JSON" {
		structInsert(payLoadStruct, "x_invoice_num", arguments.options.orderID, "yes");

		structInsert(payLoadStruct, "x_version", Variables.apiVersion, "yes");
		structInsert(payLoadStruct, "x_tran_key", Variables.transactionKey, "yes");
		structInsert(payLoadStruct, "x_login", Variables.loginId, "yes");
		structInsert(payLoadStruct, "x_delim_data", "TRUE", "yes");

		structInsert(payLoadStruct, "x_delim_char", Variables.responseDelimeter, "yes");
		structInsert(payLoadStruct, "x_relay_response", "FALSE", "yes");

		//SET x_test_request EQ "TRUE" for PROD
		structInsert(payLoadStruct, "x_test_request", "FALSE", "yes");

		writedump(#payLoadStruct#);

	}

}
