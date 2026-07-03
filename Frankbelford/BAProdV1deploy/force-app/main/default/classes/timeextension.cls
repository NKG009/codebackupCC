public class timeextension
{

Public sirenum__Placement__c place;
public String day1{get;set;}
public String day2{get;set;}
public String day3{get;set;}
public String day4{get;set;}
public String day5{get;set;}
public String day6{get;set;}
public String day7{get;set;}
public String d{get; set;} 
Public String endpt{get; set;}
Public String endpt2{get; set;}
Public Datetime totalend;
Public String reporting{get; set;}

public Date startdate;
public timeextension(ApexPages.StandardController stdController)
{
    this.place = (sirenum__Placement__c )stdController.getRecord();
 
    sirenum__Placement__c p =[Select id,IP_TimesheetNumberBulk__c,sirenum__Site__r.sirenum__Travel_Instructions__c, sirenum__Job_Role__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__StartingDate__c from sirenum__Placement__c where id =:place.id];

endpt ='http://generator.barcodetools.com/barcode.png?gen=0&data='+p.IP_TimesheetNumberBulk__c+'&bcolor=FFFFFF&fcolor=000000&tcolor=000000&fh=5&bred=0&w2n=2.5&xdim=2&w=404&h=40&debug=1&btype=2&angle=0&quiet=0&balign=2&talign=0&guarg=1&text=0&tdown=1&stst=0&schk=0&cchk=0&ntxt=1&c128=0';

//endpt = 'https://www.barcodesinc.com/generator/image.php?code='+p.IP_TimesheetNumberBulk__c+'&style=292&type=C39&width=380&height=60&xres=2&font=3';
    endpt2 = 'http://generator.barcodetools.com/barcode.png?gen=0&data=TST&bcolor=FFFFFF&fcolor=000000&tcolor=000000&fh=1&bred=0&w2n=2.5&xdim=2&w=220&h=30&debug=1&btype=2&angle=0&quiet=1&balign=2&talign=0&guarg=1&text=0&tdown=1&stst=1&schk=0&cchk=0&ntxt=0&c128=0';

  system.debug('@@ '+p.sirenum__Site__r.sirenum__Travel_Instructions__c);
    if(p.sirenum__Site__r.sirenum__Travel_Instructions__c != null)
               {
                   Integer Intlength = p.sirenum__Site__r.sirenum__Travel_Instructions__c.length();
                   
                   if(Intlength >90 )
                    reporting= p.sirenum__Site__r.sirenum__Travel_Instructions__c.substring(0,90);
                    else 
                    reporting=p.sirenum__Site__r.sirenum__Travel_Instructions__c.substring(0,Intlength);
                       
                   
                   
               }

    system.debug('@@ '+p);

    startdate=p.sirenum__Job_Role__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__StartingDate__c;


    Datetime dt1 = DateTime.newInstance(startdate, Time.newInstance(0, 0, 0, 0));
    Datetime dt2 = DateTime.newInstance(startdate +1, Time.newInstance(0, 0, 0, 0)); 
    Datetime dt3 = DateTime.newInstance(startdate +2 , Time.newInstance(0, 0, 0, 0));
    Datetime dt4 = DateTime.newInstance(startdate +3 , Time.newInstance(0, 0, 0, 0));
    Datetime dt5 = DateTime.newInstance(startdate +4 , Time.newInstance(0, 0, 0, 0));
    Datetime dt6 = DateTime.newInstance(startdate +5 , Time.newInstance(0, 0, 0, 0));
    Datetime dt7 = DateTime.newInstance(startdate +6 , Time.newInstance(0, 0, 0, 0));

    day1=dt1.format('EEEE');
    System.debug('Day : ' + day1);
    day2 = dt2.format('EEEE');
    day3 = dt3.format('EEEE');
    day4 = dt4.format('EEEE');
    day5 = dt5.format('EEEE');
    day6 = dt6.format('EEEE');
    day7 = dt7.format('EEEE');

    If(day7 =='Monday')
    {
        totalend = System.today()+10;
        d=totalend.format('MMM d yyyy');
    }
    else if(day7 =='Tuesday')
    {
        totalend = System.today()+11;
        d=totalend.format('MMM d yyyy');
    }
    else if(day7 =='Wednesday')
    {
        totalend = System.today()+12;       d=totalend.format('MMM d yyyy');
    }
    else if(day7 =='Thursday')
    {
        totalend = System.today()+13;       d=totalend.format('MMM d yyyy');
    }
    else if(day7 =='Friday')
    {
        totalend = System.today()+7;        d=totalend.format('MMM d yyyy');
    }
    else if(day7 =='Saturday')
    {
        totalend = System.today()+8;        d=totalend.format('MMM d yyyy');
    }
    else
    {
        totalend = System.today()+9;
        d=totalend.format('MMM d yyyy');
    }   
}
}