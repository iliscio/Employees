CREATE OR REPLACE PACKAGE DL_EMPLOYEES IS


/*
   This package has been created in order to store all codes that will be responsible to 
 read or write data into the database.
 

   
*/


   FUNCTION GetEmployeesList RETURN SYS_REFCURSOR;

   FUNCTION GetEmployeeById(P_EMP_ID NUMBER) RETURN SYS_REFCURSOR;


END DL_EMPLOYEES;
/
CREATE OR REPLACE PACKAGE BODY DL_EMPLOYEES IS


   FUNCTION GetEmployeesList RETURN SYS_REFCURSOR IS
   
   BEGIN
   
      NULL;
   
   END GetEmployeesList;

   FUNCTION GetEmployeeById(P_EMP_ID NUMBER) RETURN SYS_REFCURSOR IS
   
   BEGIN
   
      NULL;
   
   END GetEmployeeById;


END DL_EMPLOYEES;
/
