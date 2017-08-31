	Variables.username = "";
	Variables.password = "";
	Variables.server = "";
	
	public function	init(required string clientId, required string clientSecret, boolean sandbox default="true" ){
		
		Variables.username	=	arguments.clientId;
		Variables.password	=	arguments.clientSecret;
		
		if(arguments.sandbox){
			Variables.server	=	'https://api.sandbox.paypal.com';
		}
		else{
			Variables.server	=	'https://api.paypal.com';
		}
		
		return this;
	} 
	
	private struct function	getAuthToken(){
		//init some vars
		var returnStruct = structNew();
		var returnStruct.status='';
		var returnStruct.msg='';
		var fContent='';

		try{
			cfhttp(method="POST", charset="utf-8", url="#apiTestURL#", result="result",username="#variables.username#", password="#variables.password#") {
			    cfhttpparam(type="header",name="Content-Type", value="application/x-www-form-urlencoded");
			    cfhttpparam(type="header",name="Accept-Language", value="en-US,en;q=0.8,id;q=0.6");
			    cfhttpparam(type="formfield",name="grant_type", value="client_credentials");
			}

			fContent	=	deSerializeJSON(result.fileContent);

			writedump(fContent);

			/*if(result.statusCode EQ '200 OK'){
				if(fContent.messages.resultCode EQ 'OK'){
					returnStruct.status='200';
					returnStruct.msg=fContent;

				}
				else if(fContent.messages.resultCode EQ 'Error'){
					returnStruct.status='500';
					returnStruct.msg='#fContent.messages.message[1].code#:#fContent.messages.message[1].text#';
				}
			}*/

		}
		catch(any e){
			returnStruct.status=500;
			returnStruct.msg='failed to contact Authorize.net';
		}

		return returnStruct;		
	}
