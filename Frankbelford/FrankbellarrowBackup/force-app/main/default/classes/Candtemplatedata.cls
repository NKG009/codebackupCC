public class Candtemplatedata {

    List<sirenum__Shift__c> shlist = new List<sirenum__Shift__c>();
    List<sirenum__Rate_Line__c> rateline = new List<sirenum__Rate_Line__c>();
    List<sirenum__Rate_Line__c> rateline1 = new List<sirenum__Rate_Line__c>();
    List<sirenum__Rate_Line__c> rateline2 = new List<sirenum__Rate_Line__c>();
    List<sirenum__Rate_Modifier__c> ratemod = new List<sirenum__Rate_Modifier__c>();
    List<sirenum__Rate_Modifier__c> ratemod1 = new List<sirenum__Rate_Modifier__c>();
    List<sirenum__Rate_Modifier__c> ratemod2 = new List<sirenum__Rate_Modifier__c>();
    public sirenum__Placement__c ps;
    ID placeID;
    public String Sitename{get;set;}
    public String branchstreet{get;set;}
    public String branchcity{get;set;}
    public String branchCountry{get;set;}
    public String branchcounty{get;set;}
    public String branchpostal{get;set;}
    public String Shiftstart{get;set;}
    public String customsitename{get;set;}
    public String branchemail{get;set;}
    public String branchphone{get;set;}
    public String starthour{get;set;}
    public String endhour{get;set;}
    public String conownerid{get;set;}
    public String logoUrl{get;set;}

    public string flag;
    public set<id> awrid = new set<id>();
    public set<id> secid = new set<id>();
    List<sirenum__Rate_Card_Page__c> displayrates = new List<sirenum__Rate_Card_Page__c>();
    Public string department;
    Public string Candidateid;
    Public string jobroleid ;
    Public string candage;
    Public date placestart;
    Public date placeend;
    public boolean placeownerstatus;
    public String subname;
    public string ratecardid;
    Map<String,id> comparelist1 = new Map<String,id>();
    Map<String,id> comparelist2 = new Map<String,id>();
    public Candtemplatedata(ApexPages.StandardController controller) {
        //this.ps = (sirenum__Placement__c)Controller.getRecord();
        // this.ps = ApexPages.currentPage().getParameters().get('id');
        placeID = ApexPages.currentPage().getParameters().get('id');
        flag = '';
        sirenum__Placement__c place = [select id,sirenum__Contact__r.Owner.IsActive,sirenum__Site__c,sirenum__Site__r.Name
                ,IP_TempestDepartment__c,sirenum__Contact__c,sirenum__Contact__r.Ownerid
                ,sirenum__Job_Role__c,sirenum__Contact__r.Age__c,sirenum__Start_Date__c
                ,sirenum__End_Date__c, IP_Consultant1LookupSplitShare__r.Brand__c
        from sirenum__Placement__c where id =:placeID];
        department = String.valueOf(place.IP_TempestDepartment__c);
        Candidateid = place.sirenum__Contact__c;
        jobroleid = place.sirenum__Job_Role__c;
        candage = String.valueOf(place.sirenum__Contact__r.Age__c);
        placestart = place.sirenum__Start_Date__c;
        placeend = place.sirenum__End_Date__c;
        placeownerstatus = place.sirenum__Contact__r.Owner.IsActive;
        conownerid = place.sirenum__Contact__r.Ownerid;
        Sitename = place.sirenum__Site__r.Name;

        System.debug('place.IP_Consultant1LookupSplitShare__r.Brand__c >> ' + place.IP_Consultant1LookupSplitShare__r.Brand__c);

        Email_Template_Mapping__mdt templateMapping = [SELECT TemplateId__c, Brand_Logo__c
        FROM Email_Template_Mapping__mdt
        WHERE Label = 'Assignment Confirmation Email'
        AND Brand__r.Label =: place.IP_Consultant1LookupSplitShare__r.Brand__c];
        //logoUrl = PageReference.forResource('Tate_Logo_Sole').getUrl(); //'/resource/1527915657000/Blue_Arrow_new_logo';
        logoUrl = PageReference.forResource(templateMapping.Brand_Logo__c).getUrl(); //'/resource/1527915657000/Blue_Arrow_new_logo';

        System.debug('## '+department );

        sirenum__Team__c jbrole = [Select id,sirenum__Rate_Card__c from sirenum__Team__c where id=:jobroleid];

        ratecardid = jbrole.sirenum__Rate_Card__c;

        IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department);
        if(shiftemp !=null)
        {
            branchstreet= shiftemp.Branch_Address__c;
            branchcity= shiftemp.IP_Branch_City__c;
            branchCountry=shiftemp.IP_Branch_Country__c;
            branchpostal = shiftemp.IP_Branch_Postal_Code__c;
            branchcounty = shiftemp.IP_Branch_County__c;
            customsitename = shiftemp.IP_Site_Name__c;
            branchemail = shiftemp.Email__c;
            branchphone = shiftemp.Phone__c;
            System.debug('## '+place);
        }

        List<sirenum__Rate_Card_Page__c> ratecardp = [Select id, sirenum__Condition_Suggestions__c, sirenum__Condition_Operator__c, sirenum__Condition_value__c,sirenum__Rate_Card__c,sirenum__SortOrder__c, sirenum__Valid_From_Date__c, sirenum__Valid_Until_Date__c from sirenum__Rate_Card_Page__c where ((sirenum__Valid_From_Date__c = NULL AND sirenum__Valid_Until_Date__c = NULL) OR (sirenum__Valid_Until_Date__c = NULL AND sirenum__Valid_From_Date__c != NULL AND sirenum__Valid_From_Date__c <= :placeend) OR (sirenum__Valid_From_Date__c = NULL AND sirenum__Valid_Until_Date__c != NULL AND sirenum__Valid_Until_Date__c >=:placestart) OR (sirenum__Valid_From_Date__c != NULL AND sirenum__Valid_Until_Date__c != NULL AND sirenum__Valid_From_Date__c <=:placeend AND sirenum__Valid_Until_Date__c >=:placestart)) and ((sirenum__Condition_Suggestions__c = 'Contact__c' and sirenum__Condition_Operator__c = 'Equal to' and sirenum__Condition_value__c =:Candidateid) OR (sirenum__Condition_Suggestions__c = 'sirenum__Contact__r.sirenum__Age__c' and ((sirenum__Condition_Operator__c = 'Less than' and sirenum__Condition_value__c>:candage) OR (sirenum__Condition_Operator__c = 'Less or equal to' and sirenum__Condition_value__c>=:candage))) OR (sirenum__Condition_Suggestions__c != 'sirenum__Contact__r.sirenum__Age__c' and sirenum__Condition_Suggestions__c!= 'Contact__c')) and sirenum__Rate_Card__c =:ratecardid order by sirenum__SortOrder__c desc];
        system.debug('check rate card page list'+ratecardp );
        if(ratecardp.size()>0)
        {
            if(ratecardp.size()>1)
            {
                for(sirenum__Rate_Card_Page__c rcp: ratecardp)
                {
                    System.debug('RCP check'+rcp.sirenum__Condition_Suggestions__c);
                    if(rcp.sirenum__Condition_Suggestions__c != null && rcp.sirenum__Condition_Suggestions__c != 'AWR' && rcp.sirenum__Condition_Suggestions__c != 'Contact__c' && rcp.sirenum__Condition_Suggestions__c != 'sirenum__Contact__r.sirenum__Age__c')
                    {
                        flag = 'true';
                        System.debug('Condition 1');
                    }
                }
                if(flag!= 'true')
                {
                    if(ratecardp[0].sirenum__Condition_Suggestions__c == 'AWR')
                    {
                        awrid.add(ratecardp[0].id);
                        secid.add(ratecardp[1].id);
                        System.debug('Condition 2' + awrid);
                        System.debug('Condition 2' + secid);
                    }
                    if(ratecardp[0].sirenum__Condition_Suggestions__c == 'sirenum__Contact__r.sirenum__Age__c')
                    {
                        displayrates.add(ratecardp[0]);
                        System.debug('Condition 3'+displayrates);
                    }
                    if(ratecardp[0].sirenum__Condition_Suggestions__c == 'Contact__c')
                    {
                        displayrates.add(ratecardp[0]);
                        System.debug('Condition 4'+displayrates);
                    }
                }
            }
            else
            {
                if(ratecardp[0].sirenum__Condition_Suggestions__c == 'AWR')
                {
                    flag = 'true';
                    System.debug('Condition 5');
                }
                else
                {
                    if(ratecardp[0].sirenum__Condition_Suggestions__c != null && ratecardp[0].sirenum__Condition_Suggestions__c != 'AWR' && ratecardp[0].sirenum__Condition_Suggestions__c != 'Contact__c' && ratecardp[0].sirenum__Condition_Suggestions__c != 'sirenum__Contact__r.sirenum__Age__c')
                    {
                        flag = 'true';
                        System.debug('Condition 7');
                    }
                    else
                    {
                        displayrates.add(ratecardp[0]);
                        System.debug('Condition 6'+ displayrates);
                    }

                }
            }
        } else {
            flag = 'true';
            System.debug('Condition 8');
        }
    }

    public void createtask() {
        if(flag == 'true' && placeownerstatus == TRUE) {
            Task tsk = new Task();
            tsk.Ownerid = conownerid;
            tsk.Subject = 'Manually send Rate Card';
            tsk.Whatid = placeID;
            insert tsk;
        }
    }

    Public List<sirenum__Rate_Line__c> getratelines() {
        if(displayrates.size()>0) {
            ratemod = [Select id,sirenum__Pay_Rate__c,sirenum__Rate_Line__c,sirenum__Rate_Modifier_Type__r.Name,sirenum__Overtime_Pay_Rate__c,sirenum__Overtime_2x_Pay_Rate__c from sirenum__Rate_Modifier__c where sirenum__Rate_Line__r.sirenum__Rate_Card_Page__c in: displayrates];
            system.debug('rate modifier'+ratemod);
            for(sirenum__Rate_Modifier__c s: ratemod) {
                if(!comparelist1.containsKey(String.valueof(s.sirenum__Pay_Rate__c)+String.valueOf(s.sirenum__Rate_Line__c))) {
                    comparelist1.put(String.valueof(s.sirenum__Pay_Rate__c)+String.valueOf(s.sirenum__Rate_Line__c),s.id);
                }
            }
            system.debug('after duplicates'+comparelist1);
            rateline = [Select id,sirenum__Pay_Rate__c,sirenum__Overtime_Pay_Rate__c,sirenum__Overtime_2x_Pay_Rate__c,sirenum__Standard_Rate_Name__c,sirenum__Day_Type__c,sirenum__Start_Hour__c,sirenum__End_Hour__c, (Select id,Name,sirenum__Pay_Rate__c,sirenum__Rate_Modifier_Type__r.Name,sirenum__Overtime_Pay_Rate__c,sirenum__Overtime_2x_Pay_Rate__c from sirenum__Rate_Modifiers__r where id in:comparelist1.values()) from sirenum__Rate_Line__c where sirenum__Rate_Card_Page__c in:displayrates order by sirenum__SortOrder__c ASC];
        }
        return rateline;
    }

    Public List<sirenum__Rate_Line__c> getrate1() {
        if(!awrid.isEmpty()) {
            ratemod1 = [Select id,sirenum__Pay_Rate__c,sirenum__Rate_Line__c,sirenum__Rate_Modifier_Type__r.Name,sirenum__Overtime_Pay_Rate__c,sirenum__Overtime_2x_Pay_Rate__c from sirenum__Rate_Modifier__c where sirenum__Rate_Line__r.sirenum__Rate_Card_Page__c in: awrid];

            for(sirenum__Rate_Modifier__c s: ratemod1) {
                if(!comparelist1.containsKey(String.valueof(s.sirenum__Pay_Rate__c)+String.valueOf(s.sirenum__Rate_Line__c))) {
                    comparelist1.put(String.valueof(s.sirenum__Pay_Rate__c)+String.valueOf(s.sirenum__Rate_Line__c),s.id);
                }
            }
            rateline1 = [Select id,sirenum__Pay_Rate__c,sirenum__Overtime_Pay_Rate__c,sirenum__Overtime_2x_Pay_Rate__c,sirenum__Standard_Rate_Name__c,sirenum__Day_Type__c,sirenum__Start_Hour__c,sirenum__End_Hour__c, (Select id,Name,sirenum__Pay_Rate__c,sirenum__Rate_Modifier_Type__r.Name,sirenum__Overtime_Pay_Rate__c,sirenum__Overtime_2x_Pay_Rate__c from sirenum__Rate_Modifiers__r where id in:comparelist1.values()) from sirenum__Rate_Line__c where sirenum__Rate_Card_Page__c in:awrid order by sirenum__SortOrder__c ASC];
        }
        return rateline1;
    }

    Public List<sirenum__Rate_Line__c> getrate2() {
        if(!secid.isEmpty()) {
            ratemod2 = [Select id,sirenum__Pay_Rate__c,sirenum__Rate_Line__c,sirenum__Rate_Modifier_Type__r.Name,sirenum__Overtime_Pay_Rate__c,sirenum__Overtime_2x_Pay_Rate__c from sirenum__Rate_Modifier__c where sirenum__Rate_Line__r.sirenum__Rate_Card_Page__c in: secid];

            for(sirenum__Rate_Modifier__c s: ratemod2) {
                if(!comparelist2.containsKey(String.valueof(s.sirenum__Pay_Rate__c)+String.valueOf(s.sirenum__Rate_Line__c))) {
                    comparelist2.put(String.valueof(s.sirenum__Pay_Rate__c)+String.valueOf(s.sirenum__Rate_Line__c),s.id);
                }
            }
            rateline2 = [Select id,sirenum__Pay_Rate__c,sirenum__Overtime_Pay_Rate__c,sirenum__Overtime_2x_Pay_Rate__c,sirenum__Standard_Rate_Name__c,sirenum__Day_Type__c,sirenum__Start_Hour__c,sirenum__End_Hour__c, (Select id,Name,sirenum__Pay_Rate__c,sirenum__Rate_Modifier_Type__r.Name,sirenum__Overtime_Pay_Rate__c,sirenum__Overtime_2x_Pay_Rate__c from sirenum__Rate_Modifiers__r where id in:comparelist2.values()) from sirenum__Rate_Line__c where sirenum__Rate_Card_Page__c in:secid order by sirenum__SortOrder__c ASC];
        }
        return rateline2;
    }


    Public List<sirenum__Shift__c> getshifts() {
        shlist = [Select id,sirenum__Scheduled_Start_Time__c,sirenum__Scheduled_End_Time__c from sirenum__Shift__c where sirenum__Placement__c =: placeID order by sirenum__Scheduled_Start_Time__c];
        system.debug('shift list'+shlist);
        if(shlist.size()>0){
            Shiftstartdate(shlist[0].sirenum__Scheduled_Start_Time__c);
        }
        return shlist;
    }


    public void Shiftstartdate(Datetime dt) {
        system.debug('@@ '+dt);
        Shiftstart=dt.format('dd/MM/yyyy');
    }


}