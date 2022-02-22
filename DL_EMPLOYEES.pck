CREATE OR REPLACE PACKAGE DL_EMPLOYEES IS


/*
   This package has been created in order to store all codes that will be responsible to 
 read or write data into the database.
 
  
*/

   TYPE TEmployeeRec IS RECORD (EmpId        employees.employee_id%TYPE
                               ,EmpFirstName employees.first_name%TYPE
                               ,EmpLastName  employees.last_name%TYPE
                               ,EmpMail      employees.email%TYPE
                               ,EmpPhone     employees.phone_number%TYPE
                               );
                               
   TYPE TEmployeeList IS REF CURSOR RETURN TEmployeeRec;

   FUNCTION GetEmployeesList RETURN TEmployeeList;

   FUNCTION GetEmployeeById(P_EMP_ID NUMBER) RETURN TEmployeeRec;


END DL_EMPLOYEES;
/
CREATE OR REPLACE PACKAGE BODY DL_EMPLOYEES IS


   FUNCTION GetEmployeesList RETURN TEmployeeList IS
   
   BEGIN
   
      NULL;
   
   END GetEmployeesList;

   FUNCTION GetEmployeeById(P_EMP_ID NUMBER) RETURN TEmployeeRec IS
   
   BEGIN
   
      NULL;
   
   END GetEmployeeById;


END DL_EMPLOYEES;
/
