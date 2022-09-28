select * from
(
select tParUser.LOGIN MANAGER, tIntParPos.PARTY_ID MANAGER_POS_ID, tParPos.NAME MANAGER_Position,
case when tParContact.PR_HELD_POSTN_ID = tIntParPos.PARTY_ID then 'Y' else ' ' end IS_MNGR_PRIMARY_POS,
S_PARTY_RPT_REL.SUB_PARTY_ID EMPLOYEE_ID,
tChldUser.LOGIN EMPLOYEE
from S_PARTY_PER tIntParPos

join S_CONTACT tParContact on tParContact.PAR_ROW_ID = tIntParPos.PERSON_ID
join S_PARTY_RPT_REL on S_PARTY_RPT_REL.PARTY_ID = tIntParPos.PARTY_ID
join S_POSTN tParPos on tParPos.PAR_ROW_ID = S_PARTY_RPT_REL.PARTY_ID
join s_USER tParUser on  tParUser.PAR_ROW_ID = tParContact.PAR_ROW_ID

join S_CONTACT tChldContact on tChldContact.PR_HELD_POSTN_ID = S_PARTY_RPT_REL.SUB_PARTY_ID
join S_USER tChldUser on tChldContact.PAR_ROW_ID = tChldUser.PAR_ROW_ID

)
where Manager = 'SADMIN'
;
