public with sharing class AdyenPaymentMethodsRequest {
     public static PaymentMethodsRequest createPaymentMethodsRequest(ccrz__E_Cart__c cart, Merchant__mdt merchant){
            PaymentMethodsRequest paymentMethodsRequest = new PaymentMethodsRequest();
            paymentMethodsRequest.merchantAccount = merchant.Name__c;
            paymentMethodsRequest.amount = AdyenUtil.getAdyenAmount(cart);
            paymentMethodsRequest.shopperReference = cart.ccrz__Account__c;
            paymentMethodsRequest.allowedPaymentMethods = new List<String> {'card', 'ideal'};
            //TODOBAS countryCode from address
            paymentMethodsRequest.countryCode = 'US';
            return paymentMethodsRequest;
     }

     public static PaymentMethodsResponse getPaymentMethods(Merchant__mdt merchant, PaymentMethodsRequest request){
     PaymentMethodsResponse paymentMethods = new PaymentMethodsResponse();
     AdyenClient client = new AdyenClient(merchant.API_Key__c, merchant.PaymentMethods_Endpoint__c);
     String jsonString = JSON.serialize(request, true);
     jsonString = Util.makeAdyenCompatible(jsonString);
     HttpResponse httpResponse = client.request(client.config, jsonString);

     if(AdyenUtil.isHttpResponseOK(httpResponse.getStatusCode())) {
        paymentMethods = (PaymentMethodsResponse) JSON.deserialize(Util.makeSalesforceCompatible(httpResponse.getBody()), PaymentMethodsResponse.class);
     } else {
        System.Debug('## Response code ' + httpResponse.getStatusCode() + 'from /paymentMethods call');
        System.Debug('## /paymentMethods raw response: ' + httpResponse.getBody());
     }
     return paymentMethods;
 }
}