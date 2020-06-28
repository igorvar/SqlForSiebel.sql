/*
Instead of serach in tools
*/
select 
       Links.CHILD_BC_NAME, 
       --Links.DST_FLD_NAME, 
       Links.PARENT_BC_NAME, 
       --Links.SRC_FLD_NAME, 
       SrsField.CALCVAL
from 
     S_LINK Links
     
join S_REPOSITORY 
       on S_REPOSITORY.ROW_ID = Links.REPOSITORY_ID 
      and S_REPOSITORY.NAME = 'Siebel Repository'
      
left outer join S_BUSCOMP BcParent 
       on BcParent.NAME = Links.PARENT_BC_NAME 
      and BcParent.REPOSITORY_ID = Links.REPOSITORY_ID

left outer join S_FIELD SrsField 
       on SrsField.BUSCOMP_ID = BcParent.ROW_ID 
      and SrsField.NAME = Links.SRC_FLD_NAME 

where Links.CHILD_BC_NAME like 'My Strong % VBC'


/*
select CALCVAL, REGEXP_SUBSTR(CALCVAL,'<\w+?>'), 
--REGEXP_SUBSTR(CALCVAL,'<(\w+)>(.*)(?=<\/\1)')
REGEXP_SUBSTR(CALCVAL,'<(\w+)>(.*)(?!</\1)')
from S_FIELD where ROW_ID = '1M-10SWJCG'

*/


/*select XMLType(
'<hello-world>
   <word seq="1">Hello</word>
   <word seq="2">world</word>
</hello-world>
') XML
from dual*/
