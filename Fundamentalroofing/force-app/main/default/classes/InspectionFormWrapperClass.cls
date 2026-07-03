public class InspectionFormWrapperClass {
    public List<FieldDef> GeneralInformation;
    public List<FieldDef> GeneralPropertyDescription;
    public List<FieldDef> otherinfo;
    public List<RepairDef> repairs;
    public List<FileDef> alluploadedfiles;
    public PhotoDef frontphoto;
    public InsuranceRecommendation insuranceRecommendation;
    public PassRecommendation passRecommendation;
    public CashRecommendation cashRecommendation;
    
    public class InsuranceRecommendation {
        public String instructions { get; set; }
        public String dateOfLoss { get; set; }
        public String Other { get; set; }
    }
    
    public class PassRecommendation {
        public String instructions { get; set; }
        public String Other { get; set; }
    }
	
    public class CashRecommendation {
        public ShingleLineColour shingleLine;
        public ShingleLineColour shingleColor;
        public List<FormField> formFields;
        public String Squares;
        public String BaseRate;
        public String SteepRoofCharge;
        public String TwoStoryCharge;
        public String Total;
        public String DateOfLoss;
    }
    
     public class ShingleLineColour {
        public String manufacturer;
        public String series;
        public String color;
    }

   
    public class FormField {
        public string id;
        public String value;
        public Boolean isPicklist;
       // public List<Option> options;
    }
    
    public class FieldDef {
        public Integer id;
        public String label;
        public string value;
        public list<Option>values;
        public String type;
        public Boolean isOtherSelected;
        public String valOther;
    }
    public class Option {
        public String label;
        public String value;
        public Boolean selected;
    }
    
    public class RepairDef {
        public String id;
        public String name;
        public String unit;
        public Decimal price;
        public Integer quantity;
        public Decimal total;
        public Boolean isChecked;
    }
    
    public class FileDef {
        public String id;
        public String filename;
        public Boolean isfileuploaded;
        public String cdid;
        public String fileurl;
        public String selectedOption;
        public Boolean isOtherSelected;
        public String valOther;
    }
    
    public class PhotoDef {
        public String filename;
        public Boolean isfileuploaded;
        public String cdid;
        public String fileurl;
        public String selectedOption;
    }
    
    
    
    
    
    
}