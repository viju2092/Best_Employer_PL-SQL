set serveroutput on;

declare

type bonusCompensation
is record (CashPayment     number(6),
           CompanyCar      boolean,
           VacationWeeks   number(2)
           );
           
type empRecord
is record (ssn       employee.ssn%type,
           LName     employee.LName%type,
           DName     department.DName%type,
           bonusPayment   bonusCompensation
           );

type managerRecord
is record  (ssn    employee.ssn%type,
            bonusPayment  bonusCompensation
           );

bestEmp        empRecord;
bestManager    managerRecord;
           
begin

--Employee Section

select essn, LName, DName
into bestEmp.ssn, bestEmp.LName, bestEmp.DName
from employee, department, works_on
where employee.dno = department.dnumber
and employee.ssn = works_on.essn
and hours = (select max(hours) from works_on)
and rownum <= 1;


bestEmp.bonusPayment.CashPayment := 5000;
bestEmp.bonusPayment.CompanyCar :=  true;
bestEmp.bonusPayment.VacationWeeks := 1;

dbms_output.put_line ('Best employee name: ' || bestEmp.LName);
dbms_output.put_line ('Best employee department: ' || bestEmp.DName);
dbms_output.put_line ('Best employee bonus payment: $' || bestEmp.bonusPayment.CashPayment);

if bestEmp.bonusPayment.CompanyCar = true then
dbms_output.put_line('Compay Car has been provided');
end if;

if bestEmp.bonusPayment.VacationWeeks > 0 then
dbms_output.put_line('Exra Vacation weeks granted ' || bestEmp.bonusPayment.VacationWeeks);
end if;

--Manager Section

select ssn
into bestManager.ssn
from employee, department
where employee.ssn = department.MgrSSN
and rownum <= 1;

bestManager.bonusPayment.CashPayment := 10000;
bestManager.bonusPayment.CompanyCar :=  true;
bestManager.bonusPayment.VacationWeeks := 2;

dbms_output.put_line('');
dbms_output.put_line('Best Manager SSN: ' || bestManager.ssn);
dbms_output.put_line('Best Manager bonus payment: $' || bestManager.bonusPayment.CashPayment);


if bestManager.bonusPayment.CompanyCar = true then
dbms_output.put_line('Compay Car has been provided');
end if;

if bestManager.bonusPayment.VacationWeeks > 0 then
dbms_output.put_line('Exra Vacation weeks granted ' || bestManager.bonusPayment.VacationWeeks);
end if;

end;
           