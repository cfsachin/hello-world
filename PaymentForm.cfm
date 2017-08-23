<cfscript>
	Variables.authObj = CreateObject('Component','AuthorizeNet');
	Variables.frmData = structNew();

	frmData.refID = 'A111111';
	frmData.amount = '10';
	frmData.cardNumber = '4111111111111111';
	frmData.expirationDate = '1220';
	frmData.cardCode = '999';

	frmData.lineItems = structNew();
	frmData.lineItems.lineItem = ArrayNew(1);

	frmData.lineItems.lineItem[1] =	structNew();
	frmData.lineItems.lineItem[1].itemId 		= '1';
	frmData.lineItems.lineItem[1].name 			= 'vase';
	frmData.lineItems.lineItem[1].description 	= 'Cannes logo';
	frmData.lineItems.lineItem[1].quantity 		= '18';
	frmData.lineItems.lineItem[1].unitPrice 	= '45.00';

	frmData.tax				=	structNew();
	frmData.tax.amount		=	'4.26';
	frmData.tax.name		=	'level2 tax name';
	frmData.tax.description	=	'level2 tax';

	frmData.duty				=	structNew();
	frmData.duty.amount			=	'4.26';
	frmData.duty.name			=	'level2 tax name';
	frmData.duty.description	=	'level2 tax';

	frmData.shipping				=	structNew();
	frmData.shipping.amount			=	'4.26';
	frmData.shipping.name			=	'level2 tax name';
	frmData.shipping.description	=	'level2 tax';

	frmData.customer	=	structNew();
	frmData.customer.id	=	'768768768';

	frmData.billTo				=	structNew();
	frmData.billTo.firstName	=	'Ellen';
	frmData.billTo.lastName		=	'Johnson';
	frmData.billTo.company		=	'Souveniropolis';
	frmData.billTo.address		=	'14 Main Street';
	frmData.billTo.city			=	'Pecan Springs';
	frmData.billTo.state		=	'TX';
	frmData.billTo.zip			=	'44628';
	frmData.billTo.country		=	'USA';

	frmData.shipTo				=	structNew();
	frmData.shipTo.firstName	=	'China';
	frmData.shipTo.lastName		=	'Bayles';
	frmData.shipTo.company		=	'Thyme for Tea';
	frmData.shipTo.address		=	'12 Main Street';
	frmData.shipTo.city			=	'Pecan Springs';
	frmData.shipTo.state		=	'TX';
	frmData.shipTo.zip			=	'44628';
	frmData.shipTo.country		=	'USA';

	frmData.customerIP			=	CGI.REMOTE_ADDR;

	try{
		authObj.SendOrderToAuthorizeNet(frmData);
	}
	catch(any e){
		writedump("#e#");
	}

</cfscript>
