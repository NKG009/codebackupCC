/*******************************************************************************************
* @Name         PropertyTree_Me_Scheduler 
* @Author       Rajesh & Badri
* @Description  This class schedule data upsert for Property Tree & Me.
*******************************************************************************************/
public class PropertyTree_Me_Scheduler implements Schedulable{
    public String propertyCompanyId;
	public String propertySource;
	public String apiCallType;
	public String NCPortfolio;
    public String PMPortfolioName;
    
    public PropertyTree_Me_Scheduler(String source,String propCompanyId,String apiType,String NCPortfolioName,String portfolioName){
        propertySource = source;
		propertyCompanyId = propCompanyId;
		apiCallType = apiType;
		NCPortfolio = NCPortfolioName;
        PMPortfolioName = portfolioName;
    } 
    public void execute(SchedulableContext sc){ 
		if(propertySource != null & propertySource != ''){
			//Proprty Tree Data Upsert
			if(propertySource.equalsIgnoreCase( 'Property Tree')){
				if((propertyCompanyId != null && propertyCompanyId != '') && (apiCallType != null && apiCallType != '')){
					//Property Data upsert
					if(apiCallType.equalsIgnoreCase('Properties')){						
						PropertiesDataUpsert.getPropertiesDataUpsert(propertyCompanyId);
					}
					//Tenant Data upsert
					if(apiCallType.equalsIgnoreCase('Tenancies')){
						TenanciesDataUpsert.getTenanciesDataUpsert(propertyCompanyId);
					}
					//Agent Data upsert	
					if(apiCallType.equalsIgnoreCase('Agents')){	
						AgentsDataUpsert.getAgentsDataUpsert(propertyCompanyId);
					}
					//Ownership Data upsert	
					if(apiCallType.equalsIgnoreCase('Ownerships')){
						OwnerShipsDataUpsert.getOwnershipsDataUpsert(propertyCompanyId);
					}                    
				}
			}
			//Proprty Me Data Upsert
			if(propertySource.equalsIgnoreCase( 'Property Me')){
                if((propertyCompanyId != null && propertyCompanyId != '') && (apiCallType != null && apiCallType != '')){
                    //Property Me Lots/Properties
                    if(apiCallType.equalsIgnoreCase('PMLots')){
                         	PropertyLotsDataUpsert.getLotsDataUpsert(propertyCompanyId,NCPortfolio,PMPortfolioName);
                    }
                    //Property Me Tenants/Contacts
                    if(apiCallType.equalsIgnoreCase('PMLotTenants')){
                         	PropertyLotsTenantDataUpsert.getPropertyLotsTenantDataUpsert(propertyCompanyId,NCPortfolio,PMPortfolioName);
                    }
                    //Property Me Agents/Members
                    if(apiCallType.equalsIgnoreCase('PMLotMembers')){
                         	PropertyLotsAgentMembersDataUpsert.getPropertyLotsAgentMembersDataUpsert(propertyCompanyId,NCPortfolio,PMPortfolioName);
                    }
                }    
			}
		}		
    }
}