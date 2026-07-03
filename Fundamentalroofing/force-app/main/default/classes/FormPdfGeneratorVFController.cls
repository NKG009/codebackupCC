public class FormPdfGeneratorVFController {
    
    
    public String formHtml { get; set; }
    public String formTitle { get; set; }
    public String formattedDate { get; set; }
    public String formid { get; set; }

    public FormPdfGeneratorVFController() {
        formid = ApexPages.currentPage().getParameters().get('formid');
        formTitle=ApexPages.currentPage().getParameters().get('formTitle');
		formHtml = InspectionFormLWCController.createbody(formid);
        DateTime dt = DateTime.newInstance(system.today(), Time.newInstance(0, 0, 0, 0));
        formattedDate = dt.format('EEEE, MMMM d, yyyy');
        
    }



}