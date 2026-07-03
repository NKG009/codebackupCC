public class SendOrderAcknowledgementLWCController {
    

    @AuraEnabled
    public static void generateAndEmailPdf(Id orderId) {

        // 1. Generate PDF
        PageReference pdfPage = Page.OrderpdfgeneratorVF; // VF Page name
        pdfPage.getParameters().put('id', orderId);

        Blob pdfBlob = pdfPage.getContentAsPDF();

        // 2. Attach PDF to Order (Files)
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Order_' + orderId;
        cv.PathOnClient = 'Order_' + orderId + '.pdf';
        cv.VersionData = pdfBlob;
        insert cv;

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [
            SELECT ContentDocumentId
            FROM ContentVersion
            WHERE Id = :cv.Id
        ].ContentDocumentId;
        cdl.LinkedEntityId = orderId;
        cdl.ShareType = 'V';
        insert cdl;

        // 3. Get Order + Contact for email
        Order ord = [
            SELECT Id, OrderNumber, ShipToContact.Email
            FROM Order
            WHERE Id = :orderId
        ];

        // 4. Email PDF
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('Order_' + ord.OrderNumber + '.pdf');
        efa.setBody(pdfBlob);
        efa.setContentType('application/pdf');

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { ord.ShipToContact.Email });
        mail.setSubject('Order Confirmation - ' + ord.OrderNumber);
        mail.setPlainTextBody(
            'Dear Customer,\n\nPlease find attached your order confirmation.\n\nRegards,\nKITZ'
        );
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { efa });

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}