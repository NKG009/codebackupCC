public class manualtimeextension
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
public datetime d2{get; set;}
public date d3{get; set;}
public datetime d1{get; set;}
public String timesheetno{get; set;}
public integer datecalculation1{get;set;}
public integer datecalculation2{get;set;}
public integer payweek{get;set;}
Public String reporting{get; set;}
Public String endpt{get; set;}
Public String endpt2{get; set;}

public Date startdate;
public manualtimeextension(ApexPages.StandardController stdController)
{
 this.place = (sirenum__Placement__c )stdController.getRecord();
sirenum__Placement__c p =[Select id,First_Date_of_Year__c ,sirenum__Site__r.sirenum__Travel_Instructions__c,IP_AssignmentRef__c, sirenum__Job_Role__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__StartingDate__c,Payroll_week__c ,Payroll_year__c,Manual_Timesheet_No__c  from sirenum__Placement__c where id =:place.id];

String str = p.IP_AssignmentRef__c;
String Substr = str.subString(2,10);
String str1 = p.Payroll_year__c;
String Substr1 = str1.subString(2,4);
timesheetno = Substr+p.Payroll_week__c+Substr1;
    if(p.sirenum__Site__r.sirenum__Travel_Instructions__c != null)
               {
                   Integer Intlength = p.sirenum__Site__r.sirenum__Travel_Instructions__c.length();                  
                   if(Intlength >90 )
                    reporting= p.sirenum__Site__r.sirenum__Travel_Instructions__c.substring(0,90);
                    else 
                    reporting=p.sirenum__Site__r.sirenum__Travel_Instructions__c.substring(0,Intlength);                                       
               }
//endpt = 'https://www.barcodesinc.com/generator/image.php?code='+p.Manual_Timesheet_No__c+'&style=292&type=C39&width=380&height=60&xres=2&font=3';
 endpt ='http://generator.barcodetools.com/barcode.png?gen=0&data='+p.Manual_Timesheet_No__c+'&bcolor=FFFFFF&fcolor=000000&tcolor=000000&fh=5&bred=0&w2n=2.5&xdim=2&w=404&h=40&debug=1&btype=2&angle=0&quiet=0&balign=2&talign=0&guarg=1&text=0&tdown=1&stst=0&schk=0&cchk=0&ntxt=1&c128=0';

 
    endpt2 = 'http://generator.barcodetools.com/barcode.png?gen=0&data=TST&bcolor=FFFFFF&fcolor=000000&tcolor=000000&fh=1&bred=0&w2n=2.5&xdim=2&w=220&h=30&debug=1&btype=2&angle=0&quiet=1&balign=2&talign=0&guarg=1&text=0&tdown=1&stst=1&schk=0&cchk=0&ntxt=0&c128=0';
datecalculation1 = math.MOD( Date.newInstance(Integer.valueof(p.Payroll_year__c), 1, 1).daysBetween(Date.newInstance(2011, 1, 1)), 7);
if(datecalculation1 <0)
datecalculation1 = datecalculation1 * (-1);
else
datecalculation1 = datecalculation1;
system.debug('$$datecalculation1$$'+datecalculation1);  
datecalculation2 = math.MOD(p.sirenum__Job_Role__r.sirenum__Account__r.sirenum__PayrollCycle__r.sirenum__StartingDate__c.daysBetween(Date.newInstance(2011, 1, 1)), 7);
if(datecalculation2 <0)
datecalculation2 = datecalculation2 * (-1);
else
datecalculation2 = datecalculation2;
system.debug('$$datecalculation2$$'+datecalculation2);
payweek = Integer.valueof(p.payroll_week__c)*7;
system.debug('$$payweek$$'+payweek);
    if(datecalculation1 == 0)
        {
            if(datecalculation2 == 0)
            {
                d1 = Datetime.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-1);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy'); }
        
            else if(datecalculation2 == 1)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-0);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy'); }               
            else if(datecalculation2 == 2)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(1); d2 =  d1.addDays(payweek);  d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 3)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(2);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 4)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(3);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 5)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(4); d2 =  d1.addDays(payweek); d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 6)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(5); d2 =  d1.addDays(payweek); d= d2.format('MMM d yyyy');
            }
            else
                d = null;
        }
        else if (datecalculation1 == 1)
        {
            if(datecalculation2 == 0)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-2);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 1)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-1);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 2)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(0);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 3)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(1); d2 =  d1.addDays(payweek);d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 4)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(2);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 5)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(3); d2 =  d1.addDays(payweek);d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 6)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(4);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else
                d = null;
        }
        else if(datecalculation1 == 2)
        {
            if(datecalculation2 == 0)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-3);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 1)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-2);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 2)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-1);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 3)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(0);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 4)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(1);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 5)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(2);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 6)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(3);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else
                d = null;
        }
        else if(datecalculation1 == 3)
        {
            if(datecalculation2 == 0)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-4);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 1)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-3);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 2)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-2); d2 =  d1.addDays(payweek); d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 3)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-1);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 4)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(0); d2 =  d1.addDays(payweek); d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 5)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(1);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 6)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(2); d2 =  d1.addDays(payweek);d= d2.format('MMM d yyyy');
            }
            else
                d = null;
        }
        else if(datecalculation1 == 4)
        {
            if(datecalculation2 == 0)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-5);d2 =  d1.addDays(payweek); d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 1)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-4);d2 =  d1.addDays(payweek);d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 2)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-3);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 3)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-2);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 4)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-1); d2 =  d1.addDays(payweek); d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 5)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(0);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 6)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(1); d2 =  d1.addDays(payweek);d= d2.format('MMM d yyyy');
            }
            else
                d = null;
        }
        else if(datecalculation1 == 5)
        {
            if(datecalculation2 == 0)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-6);d2 =  d1.addDays(payweek);d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 1)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-5); d2 =  d1.addDays(payweek);d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 2)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-4); d2 =  d1.addDays(payweek); d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 3)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-3);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 4)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-2);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 5)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-1);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 6)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(0);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else
                d = null;
        }
            else if(datecalculation1 == 6)
        {
            if(datecalculation2 == 0)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-7); d2 =  d1.addDays(payweek); d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 1)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-6);d2 =  d1.addDays(payweek);d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 2)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-5); d2 =  d1.addDays(payweek);d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 3)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-4); d2 =  d1.addDays(payweek); d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 4)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-3);d2 =  d1.addDays(payweek); d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 5)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-2);
                d2 =  d1.addDays(payweek);
                d= d2.format('MMM d yyyy');
            }
            else if(datecalculation2 == 6)
            {
                d1 = Date.newInstance(integer.valueof(p.Payroll_Year__c),1,1).addDays(-1); d2 =  d1.addDays(payweek);  d= d2.format('MMM d yyyy');
            }
            else
                d = null;
        } 
        else 
        {}
d3= Date.valueOf(d2);
Datetime dt7 = DateTime.newInstance(d3, Time.newInstance(0, 0, 0, 0));
Datetime dt6 = DateTime.newInstance(d3-1, Time.newInstance(0, 0, 0, 0)); 
Datetime dt5 = DateTime.newInstance(d3-2 , Time.newInstance(0, 0, 0, 0));
Datetime dt4 = DateTime.newInstance(d3-3 , Time.newInstance(0, 0, 0, 0));
Datetime dt3 = DateTime.newInstance(d3-4 , Time.newInstance(0, 0, 0, 0));
Datetime dt2 = DateTime.newInstance(d3-5 , Time.newInstance(0, 0, 0, 0));
Datetime dt1 = DateTime.newInstance(d3-6 , Time.newInstance(0, 0, 0, 0));
  day1=dt1.format('EEEE');
  day2 = dt2.format('EEEE');
  day3 = dt3.format('EEEE');
  day4 = dt4.format('EEEE');
  day5 = dt5.format('EEEE');
  day6 = dt6.format('EEEE');
  day7 = dt7.format('EEEE');
}
}