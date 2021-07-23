/*
* @description: Test Class for ORG_CalculateBusinessDays
* @author: Nuria Durán Rodríguez (INETUM)
* @version: 1.0 
*/
@isTest
public class ORG_CalculateBusinessDays_test {
 
    /**
    * @name: addTest()
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Starting from the specified target date, returns the next date when business hours are open. If the specified target date falls within business hours, this target date is returned.
    */
    @isTest static void addTest(){
		string year = '2021';
		string month = '06';
		string day = '19';
		string hour = string.valueOf(system.now().hour());
		string minute = string.valueOf(system.now().minute());
		string second =  string.valueOf(system.now().second());
		string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':'+ minute +  ':' + second;
        DateTime  createdDate = Datetime.valueOf(stringDate);
        
        Test.startTest();
        Datetime dueDate = ORG_CalculateBusinessDays.add(createdDate, 3);
        Test.stopTest();
        
		string year1 = '2021';
		string month1 = '06';
		string day1 = '24';
		string hour1 = '00';
		string minute1 = '00';
		string second1 = '00' ;
		string stringDateFinal = year1 + '-' + month1 + '-' + day1 + ' ' + hour1 + ':'+ minute1 +  ':' + second1;

        System.assertEquals(Datetime.valueOf(stringDateFinal), dueDate);

        
    }
    /**
    * @name: addTest2()
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Starting from the specified target date, returns the next date when business hours are open. If the specified target date falls within business hours, this target date is returned.
    */
    @isTest static void addTest2(){
		string year = '2021';
		string month = '06';
		string day = '03';
		string hour = string.valueOf(system.now().hour());
		string minute = string.valueOf(system.now().minute());
		string second =  string.valueOf(system.now().second());
		string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':'+ minute +  ':' + second;
        DateTime  createdDate = Datetime.valueOf(stringDate);
        
        Test.startTest();
        Datetime dueDate = ORG_CalculateBusinessDays.add(createdDate, 3);
        Test.stopTest();
        
		string year1 = '2021';
		string month1 = '06';
		string day1 = '08';
		string hour1 = '00';
		string minute1 = '00';
		string second1 = '00' ;
		string stringDateFinal = year1 + '-' + month1 + '-' + day1 + ' ' + hour1 + ':'+ minute1 +  ':' + second1;

        System.assertEquals(Datetime.valueOf(stringDateFinal), dueDate);

        
    }   
}