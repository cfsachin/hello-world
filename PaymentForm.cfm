<cfscript>
	Variables.authObj = CreateObject('Component','AuthorizeNet');
	Variables.frmData = structNew();

	frmData.x_method  	= 	'CC';
	frmData.x_type  	=	'AUTH_CAPTURE';
	frmData.x_amount  	=	10;
	frmData.x_card_num	=	'4111111111111111';
	frmData.x_exp_date	=	'1220';
	frmData.x_card_code	=	'999';
	frmData.x_first_name=	'Sachin';
	frmData.x_last_name	= 	'Chawla';
	frmData.x_address	=	'Faridabad';
	frmData.x_city		=	'Faridabad';
	frmData.x_state		=	'Haryana';
	frmData.x_zip		=	'121003';
	frmData.x_country	=	'India';
	frmData.x_phone		=	'9899904993';
	frmData.x_email		=	'sachinchawlamca@gmail.com';
	frmData.x_customer_ip	=	cgi.REMOTE_ADDR;

	try{
		authObj.SendOrderToAuthorizeNet(frmData);
	}
	catch(any e){
		writedump("#e#");
	}

</cfscript>
