@isTest
public class icDTOShippingRequestTest {

    @isTest
    static void  icDTOShippingRequest() {
        
        icDTOShippingRequest dtoReq = new icDTOShippingRequest();
        dtoReq.ApplicationID='12345';
        dtoReq.OrderID='1234';
        dtoReq.ClientID='1234';
        dtoReq.FirstName='Test';
        dtoReq.LastName='LastName Test';
        dtoReq.TitleOrDept='Head';
        dtoReq.CompanyName='Google';
        dtoReq.AdditionalAddressInformation='No';
        dtoReq.AddressLine1='21491 Columbus Avenue';
        dtoReq.City='Cupertino';
         dtoReq.ProvinceOrState='CA';
         dtoReq.PostalCode='95014';
         dtoReq.CountryCode='US';
         dtoReq.ClientVoicePhone='123-234-5675';
         dtoReq.ClientEmail='www.test123@gmail.com';
         dtoReq.Email2='www.test123@gmail.com';
         dtoReq.Weight='67';
        dtoReq.Length='67';
        dtoReq.Width='67';
        dtoReq.IsEquipmentSwap='67';
         dtoReq.Height='170';
         dtoReq.EmailNotification='yes';
         dtoReq.ShippingReturnRequired='yes';
         dtoReq.CpeResourceCategoryCode='';
         dtoReq.ResourceCustomerRelationship='';
         dtoReq.AccessoryCode='';
         dtoReq.SpecialInstructions='';
         dtoReq.BusinessUnit='';
        
    }

}