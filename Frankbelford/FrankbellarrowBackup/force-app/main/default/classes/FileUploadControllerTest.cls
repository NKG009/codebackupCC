@isTest
private class FileUploadControllerTest {
    
     @testSetup 
    static void shiftSetup() {
        
         
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        Contact contact1 ;
        Contact contact2 ;
        Contact contact3 ;
        System.runAs(portalAccountOwner1) {
            //custom setting data
            Payroll_Swtich__c objCustomPayrol = new Payroll_Swtich__c();
            objCustomPayrol.Batch_check__c = false;
            objCustomPayrol.Name = 'Stoppayroll';
            insert objCustomPayrol;
            
            //Create account
            Account portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner1.Id
            );
            Database.insert(portalAccount1);
            
            //Create contact
            contact1 = new Contact(
                FirstName = 'Test1',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact1);
            //Create contact
            contact2 = new Contact(
                FirstName = 'Test2',
                Lastname = 'McTesty2',
                AccountId = portalAccount1.Id,
                Email = 'test2'+System.now().millisecond() + 'test2@test.com'
            );
            Database.insert(contact2);
            //Create contact
            contact3 = new Contact(
                FirstName = 'Test3',
                Lastname = 'McTesty3',
                AccountId = portalAccount1.Id,
                Email = 'test3'+System.now().millisecond() + 'test3@test.com'
            );
       
       /* Database.insert(contact3);
       
        Document document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'my_document';
        document.IsPublic = true;
        document.Name = 'My Document';
        document.FolderId = [select id from folder LIMIT 1].id;
        insert document;
             */
        
        }
        //Create user
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Customer Community User%' Limit 1];
        User user1 = new User(
            Username = System.now().millisecond() + 'test12345@test.com',
            ContactId = contact1.Id,
            ProfileId = portalProfile.Id,
            Alias = 'test123',
            Email = 'amit.kohli@espire.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        Database.insert(user1); 
        
    }
    
    @istest 
    static void testMethodOne() {
    
         
        
      User u = [select id , contactId from user where lastname = 'McTesty' limit 1];
      String strBase64 = 'iVBORw0KGgoAAAANSUhEUgAAANkAAABFCAYAAADHGkNOAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAABqKSURBVHhe7Z0LmF1VdccpgtCiWKwKagW19Y1abGvxgYqi2ApFirXQQhGoVqu0giIKUq2oRQuiVoQCogIKQngkIU8eeRECefFKCCTkRSYzSSaZyUwmk0kmyen/d2fWzLo759xH5py5CbP3990vk3vP2Wfvtdd/rbXXXmudfZLYIgUiBQqlwD6F9h47jxSIFEgiyCITRAoUTIEIsoIJHLuPFIggizwQKVAwBSLICiZw7D5SIIIs8kCkQMEUiCArmMBD7X7bjp3J9p07h9pNvL+BFCgUZD0FMMjWHUnSq35HQtuyfWdyZ1N38nRn70iY7vN2jrmCDNZfs2V78lj7tuTGFZuTf5nTljy+cduQiNfX545kYce25Nbn+vqcsq5nSH3uLTcv3tSbvGXimuQXy7qSHVGb7S3Ltss4cwXZpJYtyRH3tCSHjmlODr5rdfKK0auT+QLcUNpk9XnkpDXJYerzJerzoDubkltWbh5Kl3vNvbc+153sc9uq5K+ntyabpdVi2zspkCvIfi3tBVPYB7A92jY0kN20ojvZf1TTQJ8H3bk6+Z002vO99QhUrx3XMjDvma0jQ3s/H9c1V5CNXb0ld5CNUZ8vk0Y04I4UkF23tKuMlmiz3mgy7pUYzBVko7VJz1uTjV7dnfzR3SMLZO3y7rxDJrKnJX8/2Lp1r2SykT7oCLI9kAOuk6PjQGciG9j+6r61coDsgQOOQ6pIgQiyPYxB1vfsSD754Ppk39sH97YGsj8e25w8siFqsz1syaoOp3CQ4c4fShtJ5iJbrnHNW5LD5aENTUX+v68+X3lsY7IlqrOhsNSw31soyHC7P6XzLRp8wSEy0Qv1nPnsySBjLnjWdT6e5OGT2Ny7I/na4xuT/W4f9KaGYHvbxJbSmWGezdamXuxiuTL/WiNSWPc+mulT78PynPAw91UoyA7WmdbFT25MTp65PnnjhJbkDeP7Pm+asCY5R4fKy7q2V91j1AOyzt6dyT3SBJzX8Zm8ZkvS3L09k6QcnN8t7yXXTtBnhhwLRFlUavw8c31P8p7712pOawbm9BbNb7z62DoE5lmog/vXyCQ0YO0nkxFB9Qd3DIIOM/Lnz3bVzCacr9231mjSkyzRAbfNsE0OFtaHA2/W5ah71ya/Wt5VAg7tWV0LXaDPWNHVaINAeVQWCntEW9Oj71+XrM6g9QY951sLOrTugzwA7T46rTW5d01PJs15/l1ypvH8ifo8qGOMzm2ItOy2XDyFNcC4ub67ynpCD/rmGXiymVc9SqCWhSgUZGkmj//u92T+HPPAumSaIjiEj9RWD8ieFJP6/g8Sc161ZFMmHejbX/8nOpd6ujNdS+wUZ00XCP9mRmuqKWf9vF1ewTvEGMQc1tt+9Mymsr7fLEZcpJCqMx7ZUDIV7Rl/LjBUYx57NpYEh/l2798/tD55Rn3+Rgf6hzivLb8D6vNljtrBNwD09LljVXcyV3vCE1NogCB4aH35fnGRnv3F+e3J7zshkcYT/H7Tiq6kRULPt8kC4Mvd8Q3jZdxZDZB/wo3tdeOak/skaLPa8q7e5CNT1w3MEaVAdE39K1d5pRsKMiP4n0qK3qSD7LRWD8gWaFH9Iv7hXU3SVN2ZFEDr+euR6Gi3sCG5b9biHuEOhysJEA7hf7o4G9xpA9okKXOoYyj6h2HAKpLWazPAQDRILW2pGOmdkwdBdsQ9zakg4XmH6zc0i7XLn+kso8/7JRARImlz/5TA6zUADpr3SdtXE7Rea5/+8IZkUcdgnCYa8B9mbRjoY3/NG+BnCZiHZGGgWa3PA0etSv57Uaesi3RKzZCmw5lk1zPe5zZnWz610DvtmmEB2ZFi3i/Na0++/Gh75iLBYBNTpM7QQLa6FGCb1UKQvVnmTChNuZc9kF8MFuUvZSoR3nW7pPv1kn6vcovF74SAVXp2OKYLHmvfhSFNCmMifeCBcoY9avLapFN7uGoNk8uDLGR6DvdfLAnO95j1m1yf//N0OcjCew/QMcP+YmS+R+NaWyCLwjN7n5ZsSv5O/XM8QVwre89d+pNG+7d5bcnGfpMQAXOltPuL+sfH9R+W5mlWLGvYuPYaHeAjgHy/WAGYxWFjX/izJYNHJdyHU6mKNVqN3Km/Fwoy4hdRv36OhAshmf0BsxEFSdoV2I2NBhnDOU3SdF/njPiEoi/CccIYaGS/wG+f1FJ1j8eqoMVeIq3r7325TCPffrW8PGSNa9lDVGtZIGNt5rdvLZmGZEssk8YLBUwayGDGK6WlOzRf9mgcnHuA8d37A4HAWMc1d5ccRL7NlPmN9RCCzZudiwVeT9dXjVmdPJni+GEv/HkBNOwLYTc/JbSPcX5SoLfr2Vo8XNDxSKEgO0wEyUrTWCoJ+/rA/ILRwrjERoNsXtvWMu3Lgj8c7D2McXCcsKi2cOwn7myqDoRvLdhYFp+Jc2NW8AxMJEDrmQjHAc6eSi0E2QFiJpxOtewZQ5ChzQF2pe3m/Wt7FCQ+aIK9UNru/6RhshqWwMuCveEJMpOt4XH96LTBfRPzx4kStlUy8w7M2PulxbriEHvD+EGA47hC2BXRCgUZe5NKqS6jtWBIEGMcFuQCmRGeARoJMkj+MzlOMIsYI44aUm2y9gQcJJ/q9hDso2DUSu79Zu0BPybNSN9GBzyXaIqwfe+pzjIHCJ5IvGL1gOyVWpMsIRH2E4IMDVXJ+8pvAMAz+59pP7hMAjWroYE+MKUcRNABi8faL+Xx9MLlQ7o+JA9bjUH6rSvrk71teMyA19L3+V3RtqhWOMgqReG3b9uZfNoxJYyG3W42OZNuJMgA+7cXdgwsBuM7TZtzvHO4imEe+6zY3Fs6E8QB4Dfz/6F9aCXGHKXFJiXIL/hVz25K1Ra4l72Z/QJpPIRSpf5DTcbe8ZEMTVwNZHiCKx1RIGT+UfSxuUAv9kTV3O43B9kb3P+Ey0NE63gvIyFnHHdY48yN4wF77j0yTR+VKezXYaN4zbezZw+O8xWjm5OVBTg87HkNBRnSKnQTYxr485ZGgox917/LBR3a+fX8n/lkLSDes1NnDYKSfv9C7nm8pGkN0/B0Ma3Xei+VqRWalv7eEGRoslpDs0JNBsi8hgnH2CQwfFxa2eiDJmf/Vs0IQ2uHNMWz6Rtg9ddcv3TQe9sqcHtriCijdvXpU6RucelR7D29IPig5lVkayjIiAD5YeDBOk5MiX1trZEgQwJ/IWUzXQ/IOIfhPCatkSPmJTQu6i8J1JUk/9U6iPbeNsby3ad23aPY84YTZAgTvH9GH7yWnFNWAxnzDWmKNvdt6rqtZccYBDfYHgoT1e4/Z84Gmdpy5kiAny3T3r4nmdgcpxxU2/ec0Y3SvrDI1lCQ4XW8JDjwPEnBsd7l2kiQsYgcpnoGYFP/mdltcjW3V/18fm6b9mSbknWStGGD8XBX+77RMnheK7UWua/Rdv4+zM20PRz9DDfI/OHui3Q88JMaNFmnQBGCDGHiG1bFu928ETSYlPgq3tX//Qt1nPBjPQ/HDPvgG7WXM62PN3WFhABbgFOdScu5H57VIltDQQYTn+nMANQ7exi/qR0KyIgQuHsI52Tsdb7+RPl5zj9rvICGsVf7IKE367o0SY5JHGokzDFc4tVaqP1hUM6d0tpwggwnzokPDpqLtmcMtkO7DBNNH4JsYkt5Jjh+kMt0sGyggVf+S/vl57QXtv0YkS1znBsesxHHC33jVCOihjU7UvGf9jzOxmqNnqm2Llm/NxRkT2zsLTMBYLprAjNhSCCT9CLmLquNDcKqwsNoFhaPnt8DfWRqa6b5V+siALoLtLiesTiHC+ee1R97Ob/foB9CwnA8hG04QYYFwt7J0+vkma2ph8F+nBcFgoz5bEwRNsQk+hCt9ypeEiGIluKZ7H+hjTW0+xnSWvxGWNrZskBwHtnREcALNWata1jPdYWD7DF5edIaFaj+1kk9CMs5THiutivImpLbMmxoIg0849rGO4sgmGb++rSID8KpCM+y62BuNvO1Rp6nPRvzxKIsrF8Cgb1XtdIiAtI0hwwhROFxwXCCDFPs+xJKHgivkXldKaMbp8XbglCt12r/lHYWtypwrPi1AzBoeD//UsSI1grhDdBeLf7irJFrubeoMKpw7QoFWV+qy672Lt4z9l6hiQBBwkZJA++25szq6gwX90oxL0Gh1i+Huni7sMXDhofpc3PL91tpIOO6DwbnOLjBr9cBa9aBLjF8M+UmT3OtwwTnKYTKp7NgVn1DErmehlv7UB32exoeq3Hi4fNtOEHGc2fLXAtDqjjXAkxhw3RjT04FMj8PolvSGnTlyAJ6hbwDkNJyF9m3eZ6w+6A/pmLeEfdp4y4UZJxnEF2Ay5i9BlqKcyfs5BcEOVNflCMh7QzmdgXCeqmPRDpMG33iIC+RV2mtWzxs6/ODGEA2w0QQYCbgzSQAGJC+UZEbB/TH3Rnh00AGKIhKCCPJGRNnekSFY6YxdmLqCHQ+S2cwCJirUlJSOEt7lwvY5dn0lRYzWVGbaVzsXz2zIYx4PhkD1oYbZAieMLwJULAPImaRNWJ4rMO5Gn8IMOIn/ZqGNCACx1fxsvn3FRralWKEjR2vyJgQlC+WU8ZyHesRbrtzba4gC0/RbWIwM9I/JCiAIToA50d4WGiTmUtYU0p8G33j/vbRC9CY6IC01ArCiXD7lh9q9tnqNs63ihHWZkThkwKSFrbDHF4pjYL09lW16JMICX+uxPjwtuGq94t+YRDlUutCTlLEPOkZvi8A7s3OMAqfsdZ6TnZ5kHrTdxhdfXQ4ro4TY4fBulgh7IcQsn4dGD905PswXSZ8GtbBuxWc7efMvf9bIaUJoRqCDO2WolyrT243rsgVZESdswkNJ5T2f6TbWwUeDqObKpy2c+bxT9q8ejBYfzBYmF8Eg10o0yutEI3fV5FweKn2D2gv+x4JOV+gTmssyNcFBvYYafU3wjmSVcC417iVxJQ7zp0jcc8h2u9Vc9tnrSt7lOPd4S/9EWTtc6iITvHpKYdofWqtesX5m59XSWjUmCeH0wErBjB5R0gaL6DJjxVd7ldyabUzNWiBheD7OVhaqVJyLgHCoeCtlJe2GziqeEuuIEPNX629CqFHr0vJvSqZepKkJ8nhcdmiDmmh6pmrjJ6Ihk+7cCUjMN4kn/9kM8XF/uPFnaWD0f1c1Sc0CHGBmKw4SWAYIgu4jv0M+8RK0ROYHuPkLOHA2FzDfrExTZGy/D5GnsvVgVYcL+8YKSvHTun/6Lm43tP2K7UsNBoDE+xjosNAn+obM9osxqUK/zrjkba+3/W8j+vaLEESPhNmhi7W97nz2ypGfIT3E3VxG6XVdV6Yti8iWgWaU2MSs7bWhnBBOHI+yNkiOWeVGnIBgcf1gJ7UK44bhqvlCjIGzb4HKUZpgQckmdBuxKb9Tnsr0uAXKfMY4tcSBW5EYI+BhiKd/Bb181vtg6Yqm3q9bJesl09gn6/r2V7KZibvi+eTgY1X05twRHnj9uWDC7rauJC0gI39FxHn1OdHKuIFxdRh8TgbS2tdug9A2fPWa3xhyky9C4/5xritT/71rnyOIfzv/F1rsHmXow39Zh14V2ZwzhPhh97kXtGLiPjfrOwuCSEcYPBCvRXIoS5Ae1r3kwpTi5CCV9Dq+AWaunfkUpOl1rXKHWS1PjheFykwUigQQTZSVjrOs2EUiCBrGOnjg0cKBSLIRspKx3k2jAIRZA0jfXzwSKFABNlIWek4z4ZRIIKsYaSPDx4pFIggGykrHefZMArkDjIOhzngLSoRjiiHoRagLAWpNozktT+YhEQOT7MOa4njq3Z4nva0GiOjah+ou5KDZwv0Jii83oPmSg8lioUoHZ4BjxU5j92afMZNuYKMaALCpXh3NOE+RFvk3WZv2FaW/Ur/9bxRBQYgqj4rIDnv8fr+6gE2VYupXUEYV1mQseuErO95db6Tm/mTI1dEQ/j9Umkq8/tfl0UqCVW98mhMe4YidgiwJtOAT9FlA/IYN33kCjIqyZJW8pT+XaxYtH9VzNoUhdLk2XhTy6SgnPc0hVvVmirSF6+YXncjz3GGfc0WGAgvq7URXEtOms93IjQIYFmhHRiOfutpaABqjxTRCNciOJvy5zRiCrOKCNX7fHLFPqdxk0FAYVzexlKtsGu9zyjq+lxBRoImLw2wdAhSu8kZQppBpG8o4p5EPYr6U6CGQOIH+kGIWXGvAw+R4kTg05Zs2q7U8Q2lbGCyX33UOgGwpGCQamISeoW+s/6nSPr5hiSn2Aq1B6nX8QP1Z1oNjYEG5s0nacxLLCYp8Ocojf0KAdUaVXVPUR7U18Rg9sIKSitM1dyuEQ2oyXi4Un0s38ubOTzz50rFOFmBslcqWBlzm2zyVyvwlXLgVCW2Rok2gpDPF01p1yqwFqB9RUHGBD1vdbYZCbAwOTGV/nmYyuf1308cJ8VRv6doe3LAWBtiCykhYAG7VKAiEZN5U46Ocg7WH/GbX9WzKfgKwzN2ygEYyM4UnYgxROBCaz6WZkO8Iev4U6WoEFDN0KdrregrLInHb1RmRsiEDQ5hfIz3chUtQohQxpuxUqjI3uVG+XyfFkWwNsKK8XEvdKBmJPGo9VhGtQAzV5AhXWBQipkwOcwFVDoBtEcrOp3f+aDheM3RswIDhKDWBgtEcp01JowUXCjgkm/F3oQ+yVImQNgaexJSMnhdEUHEvPqIxE0S8gDgt2VyEVhsjQU7V4tK9HuLCMwre64Qc8PsaBoCkAks/oxA7UHP/SQGfvPJjlL2MS+Z+EJ/oil7D5iGeu/kxlG0daz+fqdS3Yn2R8KT+Xye6OHNVAKJf6CSAWQCU4WKGh/fWdhZCuilIM0YMQJMYw0zDGluJRooDPNV9QkQKKEG0PpKAHQInD0l+pEHR96ZNQ8yNCUR/LwOieyDY0RbTHyCu49RtgA8jXmOEMMsRVhSvGaarkFYAVaKiGLBHKVcsA7NB/qEIOOZCB+EMEKSIkJ8qDLFGOib1CMsFOhFgVhvIs9StgYR9Mb8CAOug7cAPC//gAegG0Hgx1PrUr/RL/MH5G1b4bX2gT5I2yG4GF49WpkZ8BYBxPAG75/Ls+UKMgiHdkLCYtYAIhpS30oLUIWI91yZNESCEMkOI3oz5sLH2xVNvr0kiUetItu3b9r2UjpPBGqtI43oE8mIxLfofMBA7QuLPIc5rtDvln1LFDhSj5y2U1T0ZUJLd0naUhkJAPj2ZYHXIr5h/ZOkvXguAuNmRZazH0Fak9vEy/RIlbfG20wo+e3bSmk4NGmr5knjPgAPiAETZpFvMD9jMjOJ/mAqGvMgq3iFmIvUHebAh7nf6oSSBxkvWKA/aAN5SWsxACPkiLwnE/lajd0aibnQmDQerkeLABRKwTGf/5RQGwCZUmyooUn0Pi8eoVoy2dzMg3QkrB7Gw5qQSW6WC8LIJ8+S1U5JcuMZ1g5B+1nRiHvhOcsQuFRgM6FK9gblt+9q2lzKnKD+iDXoixDC0kHoW8Ma4t0EebZcQcYCnSV1T/qG3+T/UGrcGIw3W0Ig+x2Jj6OEhSbnxxpSEsn0W2mWm6VtrOEImBCUC0OKI2XZv/D3j8SoZjmxuH2Fb/p6MJBZLURAw2IjIJBumLIwF4scpqHAIFayDdCjnWEAAPmMNChmDn/DWL9YtrkEZmsAnwzdctD0lkxotBgN0wVnB2OgshKS1TesAEBj44Kms/pLoEEr6AcDn9Bfu7JNzM08/TxgasxLGuaTCSQY+DRVMzZgI9Fb1SeS/jrNxRpOI2hKxvUJM/pqZJJaQ4oPjg8qTxnI0Bz0AfjZLkDjnyjPD+YGKPyOtiS1iyJKVhMFre9BhnZ+j2i9QCa4NUw9nsV8sChMCAMQtLg1LBZ4DhpgJVij9iJCgQRXTGVrN2hu0CTPlivIcHiwN2kLCu0hcS6VmUFD8lPcBkJwPS9omNxf0PNEMQeailwxXrgHoZGUJGdyPd+/XmnjNwaFVpDGF4lZ10ojlBhUQKdsAebEd/RcTBprLNhZYmBqhFBg55u6jwRPqk8h9ZBwMDsvyghdxJ9Vv5iuAIr72ffNkUnCPgTtAwNS9wONxMKTgm8Njf0OVWXyL5nDJMLEA1gAjSxxTGwEQd+cy72zCBLoO72fiTDd0PQ0BANZ18wPsAFAmBlg+oI+MNunHuoTZuwxeSYCDs2P+WaFjzAdl2h9oOF7ZU4xFjQ2Wn+6qvnC1O+TGUm+IGu6WDRhPjA1r/WlkcDKGmOOsY5oTt5UijBeLtrz6iIABlAwBy0PDmuAfbVvvFMBIThBJjT3osGhNXNj3nZsQN+8YAIhgLl/ikxPxoeJCe3IaWPfjebEhIUH2ILMEb/wAkKEe97v5M4VZEgXwBDuT5GGPvMVWxhpdbHs97nOOwajYrOjsvEibuo/EOM9WpgvaCj6D7NaMRV4j/L4fg0HoS/u7x9pHZYJo4IRYL7oiQ7VhugaqNWHSXGtaqzDpGQXh2c8SHdeNIcH7QZJd34HnIwVoFNK+nFJbJhtnv71ThfGQCk7nCRey7P4ODwAF/M2ZgG8YTIioMchZG/ZhJEs7R6gABrGBONBj9MfXi/N17dXscZ4MQFpaBP2NoyNvskyt9LX0JnzKH6/ROsEmNDkaCk7m0MTIJhwlJCESR9odvP0AjY0GcyMBuatpwhK9qIkhGLWcQ8fTDoTBqyPvVLXAw3NjnkNj1AP08CAWewFIsKAtfq+nomQoTFH+PAy3cscoCPrhACGF9FgVIbGGx4K16FqtVxBVs9gkJxpLy/AjvbVlqxPmK+a18czL4xQ7UAcn4K/p7QY+rDAac/Cdofx0g5YaykwU4k+1cZaD23tWph2KPUh6YcX9d3QbzmkHXxDi1peRs91eTEvb3Gp1hhrLQf1v9bczpSTi1bEGtBvw0BWjUh74u+YPLUs3J449t0dE9oUy+P52tB05jwqao4RZEVRNvYbKdBPgQiyyAqRAgVTIIKsYALH7iMFIsgiD0QKFEyBCLKCCRy7jxSIIIs8EClQMAUiyAomcOw+UiCCLPJApEDBFIggK5jAsftIgQiyyAORAgVTIIKsYALH7iMFIsgiD0QKFEyB/wf6AqOKk2ikcgAAAABJRU5ErkJggg==';  
      
      
      
      System.runAs(u) {
        Document d= new Document();
        d.name = 'UserImage';
        d.body = EncodingUtil.base64Decode(strBase64 ); // body field in document object which holds the file.
        d.AuthorId = UserInfo.getUserId();
        d.FolderId = UserInfo.getUserId(); 
        insert d;
        Test.startTest();
           FileUploadController.fetchUserDetail();
           FileUploadController.saveTheChunk('UserImage',strBase64, '.pdf','');
           FileUploadController.saveTheChunk('UserImage',strBase64, '.pdf',d.id);
        Test.stopTest();     
                    
       }
    }

}