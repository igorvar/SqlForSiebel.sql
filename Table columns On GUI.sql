/*
Search columns in table it used on applets
*/
--Fields in BC
select * from (
  select fields.BC, fields.TABLE_NAME, fields.JOIN_NAME, fields.COL_NAME, fields.NAME Field_Name, fields.TYPE, applets.Applet, applets.Type_On_GUI 
    from 
    (
    select bc.NAME bc, bc.TABLE_NAME, fld.NAME, fld.JOIN_NAME, fld.COL_NAME,  fld.TYPE from S_FIELD fld
    join S_BUSCOMP bc on fld.BUSCOMP_ID = bc.ROW_ID and bc.INACTIVE_FLG = 'N' 
    join S_REPOSITORY rep on bc.REPOSITORY_ID = rep.ROW_ID
    where rep.NAME='Siebel Repository' and fld.INACTIVE_FLG = 'N'
    ) fields

  --Applets: 
  
  --left outer 
    join
  
  /*select * from*/ 
    (
    select applet.NAME Applet, applet.BUSCOMP_NAME, appListClmn.FIELD_NAME, 'ListColumn' Type_On_GUI from  S_APPLET applet --and applet.BUSCOMP_NAME = bc.NAME
      join S_REPOSITORY rep on applet.REPOSITORY_ID = rep.ROW_ID 
      join S_LIST appList on appList.APPLET_ID = applet.ROW_ID
      join S_LIST_COLUMN appListClmn on appListClmn.LIST_ID = appList.ROW_ID and appListClmn.INACTIVE_FLG = 'N'
      where rep.NAME='Siebel Repository' and applet.INACTIVE_FLG = 'N' 
    union all
      select applet.NAME, applet.BUSCOMP_NAME, control.FIELD_NAME, 'FormControl' Type_On_GUI  from  S_APPLET applet --and applet.BUSCOMP_NAME = bc.NAME
      join S_REPOSITORY rep on applet.REPOSITORY_ID = rep.ROW_ID 
      join S_CONTROL control on control.APPLET_ID = applet.ROW_ID and control.INACTIVE_FLG = 'N'
      where rep.NAME='Siebel Repository' and applet.INACTIVE_FLG = 'N' 
    union all
      select  applet.NAME, applet.BUSCOMP_NAME, appMsgVar.FIELD_NAME, 'AppletMessageVar' Type_On_GUI from  S_APPLET applet
      join S_REPOSITORY rep on applet.REPOSITORY_ID = rep.ROW_ID 
      join S_APLT_TXT_MSG appMsg on appMsg.APPLET_ID = applet.ROW_ID and appMsg.INACTIVE_FLG = 'N'
      join S_APLT_TM_VAR appMsgVar on appMsgVar.APLT_TXT_MSG_ID = appMsg.ROW_ID and appMsgVar.INACTIVE_FLG = 'N'
      where rep.NAME='Siebel Repository' and applet.INACTIVE_FLG = 'N'
    union all
      select  applet.NAME, applet.BUSCOMP_NAME, dd.SRC_FIELD_NAME, 'DrillDownSource' Type_On_GUI from  S_APPLET applet
      join S_REPOSITORY rep on applet.REPOSITORY_ID = rep.ROW_ID 
      join S_DDOWN_OBJECT dd on dd.APPLET_ID = applet.ROW_ID and dd.INACTIVE_FLG = 'N'
      where rep.NAME='Siebel Repository' and applet.INACTIVE_FLG = 'N'
    union all  
      select  applet.NAME, applet.BUSCOMP_NAME, dd.SRC_FIELD_NAME, 'DynamicDrillDownCondition' Type_On_GUI from  S_APPLET applet
      join S_REPOSITORY rep on applet.REPOSITORY_ID = rep.ROW_ID 
      join S_DDOWN_OBJECT dd on dd.APPLET_ID = applet.ROW_ID and dd.INACTIVE_FLG = 'N'
      join S_DDOWN_DYNDEST ddd on ddd.DDOWN_OBJECT_ID = dd.ROW_ID and ddd.INACTIVE_FLG = 'N'
      where rep.NAME='Siebel Repository' and applet.INACTIVE_FLG = 'N'
    union all
      select  applet.NAME, applet.BUSCOMP_NAME, toggle.AUTO_TOG_FLD_NAME, 'ToggleField' Type_On_GUI from  S_APPLET applet
      join S_REPOSITORY rep on applet.REPOSITORY_ID = rep.ROW_ID 
      join S_APPLET_TOGGLE toggle on toggle.APPLET_ID = applet.ROW_ID and toggle.INACTIVE_FLG = 'N'
      where rep.NAME='Siebel Repository' and applet.INACTIVE_FLG = 'N'
      ) applets
    
    on fields.bc = applets.BUSCOMP_NAME and fields.NAME = applets.FIELD_NAME
) t 
 
--------------------------------------------------------------------------------

  where col_name = 'X_PHONE'
  
  
