/*
Show mapping external IO to Siebel BC fields
*/

select 
--tIOmap.NAME,
     tIOs.NAME Source_IO_NAME
    ,tICFs.XML_TAG Source_tag
--  , tICFs.NAME Source_ICField_name
    ,tICFs.ADAPTER_INFO Source_ICF_Path
    ,tICFmap.SRC_EXPR DM_SRC_EXPR
    ,tIOmap.DST_INT_OBJ_NAME || '.' || tICmap.DST_INT_COMP_NAME || '.' || tICFmap.DST_INT_FLD_NAME DST_ICField_NAME
    ,tICt.EXT_NAME || '.' || tICFt.EXT_NAME BC_FIELD
    ,tBCFt.TYPE || '(' || tBCFt.TEXTLEN || ')' FIELD_TYPE
    ,tBCFt.PICKLIST_NAME
    --,case when S_JOIN.DEST_TBL_NAME is null THEN tBCt.TABLE_NAME else S_JOIN.DEST_TBL_NAME end TABLE_NAME
    ,case when tBCFt.JOIN_NAME is null then tBCt.TABLE_NAME else case when S_JOIN.DEST_TBL_NAME is null then tBCFt.JOIN_NAME else S_JOIN.DEST_TBL_NAME end end TABLE_NAME
    
    ,tBCFt.COL_NAME

    ,tLOV_ClmnPhisType.NAME || '(' || tColumn.LENGTH || case when tColumn.DATA_TYPE = 'N' then ',' || tColumn.PREC_NUM || ',' || tColumn.SCALE end || ')'  Column_Type
--,tColumn.DATA_TYPE
--,case when tBCFt.JOIN_NAME is null then tBCt.TABLE_NAME else case when S_JOIN.DEST_TBL_NAME is null then tBCFt.JOIN_NAME else S_JOIN.DEST_TBL_NAME end end
--,case when S_JOIN.DEST_TBL_NAME is null then tBCt.TABLE_NAME else S_JOIN.DEST_TBL_NAME end

from S_REPOSITORY tRepository  
join S_INT_OBJ tIOs on tRepository.ROW_ID = tIOs.REPOSITORY_ID
join S_INT_COMP tICs on tICs.INT_OBJ_ID = tIOs.ROW_ID
join S_INT_FIELD tICFs on tICs.ROW_ID = tICFs.INT_COMP_ID


/*join S_INT_OBJMAP tIOmap on tIOmap.NAME = 'MNR JMS SF Upsert Simple Lead WF'
join S_INT_COMPMAP tICmap on tICmap.INT_OBJ_MAP_ID = tIOmap.ROW_ID and tICs.NAME = tICmap.SRC_INT_COMP_NAME
left outer join S_INT_FLDMAP tICFmap on tICFmap.INT_COMP_MAP_ID = tICmap.ROW_ID and tICFmap.SRC_EXPR like '%[' || tICFs.NAME || ']%'*/

left outer join S_INT_FLDMAP tICFmap on  tICFmap.SRC_EXPR like '%[' || tICFs.NAME || ']%'
join S_INT_COMPMAP tICmap on tICmap.ROW_ID = tICFmap.INT_COMP_MAP_ID and tICs.NAME = tICmap.SRC_INT_COMP_NAME
join S_INT_OBJMAP tIOmap on tIOmap.ROW_ID = tICmap.INT_OBJ_MAP_ID and tIOmap.SRC_INT_OBJ_NAME = tIOs.NAME

join S_INT_OBJ tIOt on tRepository.ROW_ID = tIOt.REPOSITORY_ID and tIOt.NAME = tIOmap.DST_INT_OBJ_NAME
join S_INT_COMP tICt on tICt.INT_OBJ_ID = tIOt.ROW_ID and tICt.NAME = tICmap.DST_INT_COMP_NAME

/*left outer */join S_INT_FIELD tICFt on tICt.ROW_ID = tICFt.INT_COMP_ID and tICFt.NAME= tICFmap.DST_INT_FLD_NAME


left outer join S_BUSCOMP tBCt on tRepository.ROW_ID = tBCt.REPOSITORY_ID and tBCt.NAME = tICt.EXT_NAME
left outer join S_FIELD tBCFt on tBCFt.BUSCOMP_ID = tBCt.ROW_ID and tBCFt.NAME = tICFt.EXT_NAME

left outer join S_JOIN on S_JOIN.REPOSITORY_ID = tRepository.ROW_ID and S_JOIN.NAME = tBCFt.JOIN_NAME and S_JOIN.BUSCOMP_ID = tBCt.ROW_ID

left outer join S_TABLE tTable on tTable.REPOSITORY_ID = tRepository.ROW_ID and tTable.NAME = case when tBCFt.JOIN_NAME is null then tBCt.TABLE_NAME else case when S_JOIN.DEST_TBL_NAME is null then tBCFt.JOIN_NAME else S_JOIN.DEST_TBL_NAME end end
left outer join S_COLUMN tColumn on tColumn.TBL_ID = tTable.ROW_ID and tColumn.NAME = tBCFt.COL_NAME
left outer join S_LST_OF_VAL tLOV_ClmnPhisType on tColumn.DATA_TYPE = tLOV_ClmnPhisType.VAL and tLOV_ClmnPhisType.TYPE = 'COLUMN_DATA_TYPE'

where tRepository.NAME = 'Siebel Repository' and

--==——==——==——==——==——==——==——==——==——==——==——==——==——==——==——==——==——==——==——==--
--––——————————————————————————————————————————————————————————————————————————––--

tIOmap.NAME = 'InQuira Link Unlink SR DM'

--––——————————————————————————————————————————————————————————————————————————––--
--==——==——==——==——==——==——==——==——==——==——==——==——==——==——==——==——==——==——==——==--

order by tICFs.XML_SEQ_NUM;
