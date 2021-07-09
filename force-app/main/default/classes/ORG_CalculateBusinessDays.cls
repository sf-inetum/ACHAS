/*
* @description: Use the BusinessHours methods to set the business hours at which your customer support team operates.
* @author: Nuria Durán Rodríguez (INETUM)
* @version: 1.0 
*/
public class ORG_CalculateBusinessDays 
    {
        public static BusinessHours defaultHours
        {
            get
            {
                if (defaultHours == null)
                    defaultHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true];
                return defaultHours;
            }
            private set;
        }
    /**
    * @name: add() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Adds an interval of time from a start Datetime traversing business hours only. Returns the result Datetime in the local time zone.
    */
        public static Datetime add(Datetime pointer, Integer days)
        {
            pointer = BusinessHours.nextStartDate(defaultHours.Id, pointer);
            // make sure you're starting at a Datetime within BusinessHours
    
            for (Integer elapsed = 0; elapsed < days; elapsed++)
            {
                pointer = pointer.addDays(1);
                if (!BusinessHours.isWithin(defaultHours.Id, pointer))
                    pointer = BusinessHours.nextStartDate(defaultHours.Id, pointer);
            }
            return pointer;
        }
        //Datetime dueDate = BusinessDays.add(createdDate, 3); 
        //Note that the output is in GMT, so you may need to adjust it to include timezone offsets.
        //NOTA: El siguiente día lo da con hora 0:00 (en este caso +4GMT)
    }