/**
 * Created by Musaddekur Rahman on 2020-08-06.
 * Des: This wrapper class is used to generate Configuration (JSON) as part of TimesheetLine creation process
 */

public with sharing class GenerateTimesheetLnConfig {
    public Period period = new Period();
    public Filter filter = new Filter();
    public String notify;

    public class Period {
        public String selectionClause;
        public String orderByClause;
    }

    public class Filter{
        public List<String> IP_Consultant1LookupSplitShare = new List<String>();
        public List<String> sirenum_Site = new List<String>();
        public List<String> sirenum_Contact = new List<String>();
    }
}