/**
 * MR: USE Schema classess to get RecordType Id instead of using SOQL as part of RJSPT-87 JIRA ticket.
 * CHANGE REQUIREMNTS: JIRA RJSPT-87: Reinstate Process - Not working for certain workers
 * DATE OF UPDATE: 23/07/2020
 */
public class ReinstateButtonLightning{
	@AuraEnabled
    public static IP_PayProfile__c getPayProfileDetail(String payProfileId) {
		IP_PayProfile__c payProfile = [Select id,IP_Status__c from IP_PayProfile__c where id=:payProfileId];
		return payProfile;
	}
	
	@AuraEnabled
    public static String updatedata(String payProfileId) {
    	System.debug('********Limits.getQueries()::::: '+Limits.getQueries());
		try {
			//ADDED FOLLOWING VAR TO BULKIFY THE CODE EXECUTION 
			Map<Id, ts2__Certification__c> allCerts = new  Map<Id, ts2__Certification__c>();
			List<sirenum__Ticket__c> allComps = new List<sirenum__Ticket__c>();
			List<IP_PayProfile__c> allPayProfiles = new List<IP_PayProfile__c>();

			List<ts2__Certification__c> certlist = new  List<ts2__Certification__c>();
			List<ts2__Certification__c> drivinglist = new  List<ts2__Certification__c>();
			List<ts2__Certification__c> certlistupdate = new  List<ts2__Certification__c>();
			List<sirenum__Ticket__c> comp = new List<sirenum__Ticket__c>();
			
			IP_PayProfile__c payrec = [Select id,RecordType.name,IP_Payroll_Leaver__c,IP_NewStarterTaxStatus__c,
									IP_Candidate__c,IP_Status__c,Date_P45_Requested__c,IP_StudentLoan__c,P45_Requested__c,
									P45_Date_by_Head_Office__c,Reason_for_Leaving1__c,Reason_for_P45_Internal__c,
									IP_PassToTempest__c,IP_LastPassedToTempest__c,IP_BankAccountName__c,IP_AccountNumber__c,
									IP_SortCode__c,IP_BuildingSocietyNumber__c from IP_PayProfile__c where id=:payProfileId];
			Date today = System.today();
			Date future = System.today().addDays(30);
			id contactid = payrec.IP_Candidate__c;
			String paystatus = payrec.IP_Status__c;
			string rectype = payrec.RecordType.name;
				
			Contact con = [Select ID,Person_Status__c,WTR_Completed__c,IP_Allpayprofiles__c,IP_WorkerStartDate__c,
							P45_Suppression_Reason__c,PORTW_Completed__c,IP_LCC__c,Declaration_Completed__c ,IP_LTDCount__c,
							IP_UmbCount__c,IP_ActivePAYEPayProfiles__c,Medical_Completed__c,TOE_Completed__c,New_Starter_Form__c,
							Equal_Opportunity_Completed__c,VISA_Expiration_Date__c from Contact where id=:contactid];
				
				if(paystatus == 'Inactive'){
					if(con.IP_Allpayprofiles__c == 0){
						drivinglist = [Select id,IP_Status__c,RecordType.Name,ts2__Contact__c from ts2__Certification__c 
										where ts2__Contact__c=:contactid and RecordType.Name in ('Driving Licence','DVLA Licence Check') 
										and IP_Status__c !='Lapsed'];
						if(drivinglist.size()>0){
							for(ts2__Certification__c c:drivinglist){
								c.IP_Status__c = 'Lapsed';
								allCerts.put(c.Id, c);
							}							
						}
						comp = [Select id,sirenum__TicketType__c,sirenum__TicketType__r.Name,sirenum__Valid__c,sirenum__Revoked__c,sirenum__Valid_until__c from sirenum__Ticket__c where sirenum__TicketType__r.Name in ('LGV C1 Licence','PCV Licence','PCV Licence (Minibus)','LGV C + E Licence (102 Restriction)','LGV C1+E Licence','LGV C Licence','LGV C + E Licence','Driving Licence (Standard)','LGV ADR C1 Licence','LGV HIAB C Licence','LGV ADR C1+E Licence','DVLA Licence Check')  and sirenum__Owner__c=:contactid];
						if(comp.size()>0){
							for(sirenum__Ticket__c t : comp){
								if(payrec.P45_Date_by_Head_Office__c != null){
									t.sirenum__Valid_until__c = payrec.P45_Date_by_Head_Office__c;
								}
								else{
									t.sirenum__Valid_until__c = System.today().addDays(-1);
								}
								allComps.add(t);
							}
						}
					}

					payrec.IP_NewStarterTaxStatus__c = null; 
					payrec.IP_Status__c = 'Active'; 
					payrec.Date_P45_Requested__c = null; 
					payrec.IP_StudentLoan__c =null; 
					payrec.P45_Requested__c =false; 
					payrec.P45_Date_by_Head_Office__c = null; 
					payrec.Reason_for_Leaving1__c =null;
					payrec.IP_PassToTempest__c = false; 
					payrec.IP_LastPassedToTempest__c = null; 
					payrec.IP_Payroll_Leaver__c = '';
					if(payrec.RecordType.name == 'PAYE' || payrec.RecordType.name == 'LTD'){
						payrec.IP_BankAccountName__c ='';
						payrec.IP_AccountNumber__c ='';
						payrec.IP_SortCode__c ='';
						payrec.IP_BuildingSocietyNumber__c = '';
					}
					allPayProfiles.add(payrec);

					system.debug('active pay profile1'+con.IP_Allpayprofiles__c);
					if(con.IP_Allpayprofiles__c == 0){
						system.debug('active pay profile'+con.IP_Allpayprofiles__c);
						con.IP_LCC__c =false;
						con.Declaration_Completed__c = false;
						con.Medical_Completed__c = false;
						con.TOE_Completed__c = false;
						con.New_Starter_Form__c = false;
						con.Person_Status__c = 'Active';
						con.IP_WorkerStartDate__c = null;
						con.P45_Suppression_Reason__c = null;
						con.WTR_Completed__c = false;               
					}   
					else{
						if(rectype == 'PAYE' && con.IP_LTDCount__c == 0 && con.IP_UmbCount__c == 0){
							con.TOE_Completed__c = false;
							con.New_Starter_Form__c = false;
							con.WTR_Completed__c =false;
							con.Declaration_Completed__c = false;
							con.Medical_Completed__c = false;
						}   
						else if (rectype == 'PAYE' && con.IP_LTDCount__c > 0){
							con.TOE_Completed__c = false;
							con.WTR_Completed__c = false;
							con.New_Starter_Form__c = false;
						}
						else if(rectype == 'PAYE' && con.IP_UmbCount__c > 0 && con.IP_LTDCount__c == 0){
							con.TOE_Completed__c = false;
							con.New_Starter_Form__c = false;
							con.WTR_Completed__c =false;
							con.Declaration_Completed__c = false;
							con.Medical_Completed__c = false;
						}
						else if(rectype == 'LTD' && con.IP_UmbCount__c == 0 && con.IP_ActivePAYEPayProfiles__c == 0){
							con.IP_LCC__c = false;
							con.Declaration_Completed__c = false;
							con.Medical_Completed__c = false;
						}
						else if(rectype == 'LTD' && con.IP_ActivePAYEPayProfiles__c > 0){
							con.IP_LCC__c = false;
						}
						else if(rectype == 'LTD' && con.IP_UmbCount__c > 0 && con.IP_ActivePAYEPayProfiles__c == 0){
							con.IP_LCC__c = false;
							con.Declaration_Completed__c = false;
							con.Medical_Completed__c = false;
						}
						else{
							system.debug('In Umbrella');
						}
					}
					
					if(con.IP_Allpayprofiles__c == 0){
						certlist = [Select id,ts2__Contact__c,IP_Status__c,Verfied__c from ts2__Certification__c 
								where ts2__Contact__c=:contactid and RecordType.name not in ('Right to Work','Equal Opportunities Question','WTRT- Driving') and IP_Status__c != 'Lapsed'];
						for(ts2__Certification__c c:certlist){
							c.IP_Status__c = 'Lapsed';
							allCerts.put(c.Id, c);
						}
					}else if(rectype == 'PAYE' && con.IP_UmbCount__c == 0 && con.IP_LTDCount__c == 0){
						certlist = [Select id,ts2__Contact__c,IP_Status__c,Verfied__c from ts2__Certification__c 
								where ts2__Contact__c=:contactid and RecordType.name in ('TOE','New Starter Declaration Form','Declaration','Medical','WTR') and IP_Status__c != 'Lapsed'];

						for(ts2__Certification__c c:certlist){
							c.IP_Status__c = 'Lapsed';
							allCerts.put(c.Id, c);
						}
					}
					else if(rectype == 'PAYE' && con.IP_LTDCount__c > 0){
						certlist = [Select id,ts2__Contact__c,IP_Status__c,Verfied__c from ts2__Certification__c 
									where ts2__Contact__c=:contactid and RecordType.name in ('TOE','New Starter Declaration Form','WTR') and IP_Status__c != 'Lapsed'];

						for(ts2__Certification__c c:certlist){
							c.IP_Status__c = 'Lapsed';
							allCerts.put(c.Id, c);
						}
					}
					else if(rectype == 'PAYE' && con.IP_UmbCount__c > 0 && con.IP_LTDCount__c == 0){
						certlist = [Select id,ts2__Contact__c,IP_Status__c,Verfied__c from ts2__Certification__c 
									where ts2__Contact__c=:contactid and RecordType.name in ('TOE','New Starter Declaration Form','Declaration','Medical','WTR') and IP_Status__c != 'Lapsed'];

						for(ts2__Certification__c c:certlist){
							c.IP_Status__c = 'Lapsed';
							allCerts.put(c.Id, c);
						}           
					}
					else if(rectype == 'LTD' && con.IP_ActivePAYEPayProfiles__c == 0 && con.IP_UmbCount__c == 0){
						certlist = [Select id,ts2__Contact__c,IP_Status__c,Verfied__c from ts2__Certification__c 
						where ts2__Contact__c=:contactid and RecordType.name in ('Limited Company Contract','Declaration','Medical') and IP_Status__c != 'Lapsed'];
						for(ts2__Certification__c c:certlist){
							c.IP_Status__c = 'Lapsed';
							allCerts.put(c.Id, c);
						}
					}
					else if(rectype == 'LTD' && con.IP_ActivePAYEPayProfiles__c > 0){
						certlist = [Select id,ts2__Contact__c,IP_Status__c,Verfied__c from ts2__Certification__c 
							where ts2__Contact__c=:contactid and RecordType.name = 'Limited Company Contract' and IP_Status__c != 'Lapsed'];
						for(ts2__Certification__c c:certlist){
							c.IP_Status__c = 'Lapsed';
							allCerts.put(c.Id, c);
						}
					}
					else if(rectype == 'LTD' && con.IP_UmbCount__c > 0 && con.IP_ActivePAYEPayProfiles__c == 0){
						certlist = [Select id,ts2__Contact__c,IP_Status__c,Verfied__c from ts2__Certification__c 
						where ts2__Contact__c=:contactid and RecordType.name in ('Limited Company Contract','Declaration','Medical') and IP_Status__c != 'Lapsed'];
						for(ts2__Certification__c c:certlist){
							c.IP_Status__c = 'Lapsed';
							allCerts.put(c.Id, c);
						}
					}
					else{
						system.debug('In Umbrella');
					}            
				} 
				else{
					if(con.IP_Allpayprofiles__c == 1){
						drivinglist = [Select id,IP_Status__c,RecordType.Name,ts2__Contact__c from ts2__Certification__c where ts2__Contact__c=:contactid and RecordType.Name in ('Driving Licence','DVLA Licence Check') and IP_Status__c !='Lapsed'];
						if(drivinglist.size()>0){
							for(ts2__Certification__c c:drivinglist)						{
								c.IP_Status__c = 'Lapsed';
								allCerts.put(c.Id, c);
							}
						}
						comp = [Select id,sirenum__TicketType__c,sirenum__TicketType__r.Name,sirenum__Valid__c,sirenum__Revoked__c,
								sirenum__Valid_until__c from sirenum__Ticket__c where sirenum__TicketType__r.Name 
								in ('LGV C1 Licence','PCV Licence','PCV Licence (Minibus)','LGV C + E Licence (102 Restriction)','LGV C1+E Licence','LGV C Licence','LGV C + E Licence','Driving Licence (Standard)','LGV ADR C1 Licence','LGV HIAB C Licence','LGV ADR C1+E Licence','DVLA Licence Check')  and sirenum__Owner__c=:contactid];
						if(comp.size()>0){
							for(sirenum__Ticket__c t : comp){
								if(payrec.P45_Date_by_Head_Office__c != null){
									t.sirenum__Valid_until__c = payrec.P45_Date_by_Head_Office__c;
								}
								else{
									t.sirenum__Valid_until__c = System.today().addDays(-1);
								}
								allComps.add(t);
							}
						}
					}
					payrec.IP_NewStarterTaxStatus__c = null; 
					payrec.IP_Status__c = 'Active'; 
					payrec.Date_P45_Requested__c = null; 
					payrec.IP_StudentLoan__c =null; 
					payrec.P45_Requested__c =false; 
					payrec.P45_Date_by_Head_Office__c = null; 
					payrec.Reason_for_Leaving1__c =null;
					payrec.IP_PassToTempest__c = false; 
					payrec.IP_LastPassedToTempest__c = null; 
					payrec.IP_Payroll_Leaver__c = '';
					if(payrec.RecordType.name == 'PAYE' || payrec.RecordType.name == 'LTD'){
						payrec.IP_BankAccountName__c ='';
						payrec.IP_AccountNumber__c ='';
						payrec.IP_SortCode__c ='';
						payrec.IP_BuildingSocietyNumber__c = '';
					}
					allPayProfiles.add(payrec);
					if(con.IP_Allpayprofiles__c == 0){
					
						system.debug('active pay profile'+con.IP_Allpayprofiles__c);
						con.IP_LCC__c =false;
						con.Declaration_Completed__c = false;
						con.Medical_Completed__c = false;
						con.TOE_Completed__c = false;
						con.New_Starter_Form__c = false;
						con.Person_Status__c = 'Active';
						con.IP_WorkerStartDate__c = null;
						con.P45_Suppression_Reason__c = null;
						con.WTR_Completed__c = false;               
					}   
					else
					{
						if(rectype == 'PAYE' && con.IP_LTDCount__c == 0 && con.IP_UmbCount__c == 0)
						{
							con.TOE_Completed__c = false;
							con.New_Starter_Form__c = false;
							con.WTR_Completed__c =false;
							con.Declaration_Completed__c = false;
							con.Medical_Completed__c = false;
						}   
						else if (rectype == 'PAYE' && con.IP_LTDCount__c > 0)
						{
							con.TOE_Completed__c = false;
							con.WTR_Completed__c =false;
							con.New_Starter_Form__c = false;
						}
						else if(rectype == 'PAYE' && con.IP_UmbCount__c > 0 && con.IP_LTDCount__c == 0)
						{
							con.TOE_Completed__c = false;
							con.New_Starter_Form__c = false;
							con.WTR_Completed__c =false;
							con.Declaration_Completed__c = false;
							con.Medical_Completed__c = false;
						}
						else if(rectype == 'LTD' && con.IP_UmbCount__c == 0 && con.IP_ActivePAYEPayProfiles__c == 0)
						{
							con.IP_LCC__c = false;
							con.Declaration_Completed__c = false;
							con.Medical_Completed__c = false;
						}
						else if(rectype == 'LTD' && con.IP_ActivePAYEPayProfiles__c > 0)
						{
							con.IP_LCC__c = false;
						}
						else if(rectype == 'LTD' && con.IP_UmbCount__c > 0 && con.IP_ActivePAYEPayProfiles__c == 0)
						{
							con.IP_LCC__c = false;
							con.Declaration_Completed__c = false;
							con.Medical_Completed__c = false;
						}
						else
						{
							system.debug('In Umbrella');
						}
					}
					
					if(con.IP_Allpayprofiles__c == 1){
						certlist = [Select id,ts2__Contact__c,IP_Status__c,Verfied__c from ts2__Certification__c where ts2__Contact__c=:contactid and RecordType.name not in ('Right to Work','Equal Opportunities Question','WTRT- Driving') and IP_Status__c != 'Lapsed'];
						for(ts2__Certification__c c:certlist)
						{
							c.IP_Status__c = 'Lapsed';
							allCerts.put(c.Id, c);
						}
					}
					
					else if(rectype == 'PAYE' && con.IP_UmbCount__c == 0 && con.IP_LTDCount__c == 0){
						certlist = [Select id,ts2__Contact__c,IP_Status__c,Verfied__c from ts2__Certification__c where ts2__Contact__c=:contactid and RecordType.name in ('TOE','New Starter Declaration Form','Declaration','Medical','WTR') and IP_Status__c != 'Lapsed'];

						for(ts2__Certification__c c:certlist){
							c.IP_Status__c = 'Lapsed';
							allCerts.put(c.Id, c);
						}				
					}
					else if(rectype == 'PAYE' && con.IP_LTDCount__c > 0){
						certlist = [Select id,ts2__Contact__c,IP_Status__c,Verfied__c from ts2__Certification__c where ts2__Contact__c=:contactid and RecordType.name in ('TOE','New Starter Declaration Form','WTR') and IP_Status__c != 'Lapsed'];
						
						for(ts2__Certification__c c:certlist){
							c.IP_Status__c = 'Lapsed';
							allCerts.put(c.Id, c);
						}
					}
					else if(rectype == 'PAYE' && con.IP_UmbCount__c > 0 && con.IP_LTDCount__c == 0){
						certlist = [Select id,ts2__Contact__c,IP_Status__c,Verfied__c from ts2__Certification__c where ts2__Contact__c=:contactid and RecordType.name in ('TOE','New Starter Declaration Form','Declaration','Medical','WTR') and IP_Status__c != 'Lapsed'];

						for(ts2__Certification__c c:certlist){
							c.IP_Status__c = 'Lapsed';
							allCerts.put(c.Id, c);
						}           
					}
					else if(rectype == 'LTD' && con.IP_ActivePAYEPayProfiles__c == 0 && con.IP_UmbCount__c == 0){
						certlist = [Select id,ts2__Contact__c,IP_Status__c,Verfied__c from ts2__Certification__c 
						where ts2__Contact__c=:contactid and RecordType.name in ('Limited Company Contract','Declaration','Medical') and IP_Status__c != 'Lapsed'];
						for(ts2__Certification__c c:certlist){
							c.IP_Status__c = 'Lapsed';
							allCerts.put(c.Id, c);
						}
					}
					else if(rectype == 'LTD' && con.IP_ActivePAYEPayProfiles__c > 0){
						certlist = [Select id,ts2__Contact__c,IP_Status__c,Verfied__c from ts2__Certification__c where ts2__Contact__c=:contactid and RecordType.name = 'Limited Company Contract' and IP_Status__c != 'Lapsed'];
						for(ts2__Certification__c c:certlist){
							c.IP_Status__c = 'Lapsed';
							allCerts.put(c.Id, c);
						}
					}
					else if(rectype == 'LTD' && con.IP_UmbCount__c > 0 && con.IP_ActivePAYEPayProfiles__c == 0){
						certlist = [Select id,ts2__Contact__c,IP_Status__c,Verfied__c from ts2__Certification__c where ts2__Contact__c=:contactid and RecordType.name in ('Limited Company Contract','Declaration','Medical') and IP_Status__c != 'Lapsed'];
						for(ts2__Certification__c c:certlist){
							c.IP_Status__c = 'Lapsed';
							allCerts.put(c.Id, c);
						}
					}
					else{
						system.debug('In Umbrella');
					}
				}
				//COMMITING ALL UPDATES AT TEH END
				update allPayProfiles;
				update allComps;
				System.debug('+++++ allCerts: '+allCerts);
				update new List<ts2__Certification__c>(allCerts.values());
				update con;
				update allPayProfiles; //MR: THIS UPDATE IS ADDED TO RE-CALCULATE THE FIELDS. NOT IDEAL BUT DOES THE JOB
				System.debug('********Limits.getQueries()::::: '+Limits.getQueries());
				return System.Label.Reinstate_Success;
        }
        catch (DmlException e) {
            return e.getMessage();
        }

   }
}