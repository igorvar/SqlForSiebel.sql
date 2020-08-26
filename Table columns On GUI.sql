/*
Search columns in table it used on applets
*/
--Fields in BC
select * from (
  select fields.BC, fields.TABLE_NAME, fields.JOIN_NAME, fields.COL_NAME, fields.NAME Field_Name, fields.TYPE, applets.Applet, applets.Type_On_GUI--, applets.Control
    ,captions.LANG_CD ,captions.Display_Name
    --,captions.CONTROL
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
    select applet.NAME Applet, applet.BUSCOMP_NAME, appListClmn.FIELD_NAME, 'ListColumn' Type_On_GUI, appListClmn.ROW_ID Control from  S_APPLET applet --and applet.BUSCOMP_NAME = bc.NAME
      join S_REPOSITORY rep on applet.REPOSITORY_ID = rep.ROW_ID 
      join S_LIST appList on appList.APPLET_ID = applet.ROW_ID
      join S_LIST_COLUMN appListClmn on appListClmn.LIST_ID = appList.ROW_ID and appListClmn.INACTIVE_FLG = 'N'
      where rep.NAME='Siebel Repository' and applet.INACTIVE_FLG = 'N' 
    union all
      select applet.NAME, applet.BUSCOMP_NAME, control.FIELD_NAME, 'FormControl' Type_On_GUI, control.ROW_ID Control from  S_APPLET applet --and applet.BUSCOMP_NAME = bc.NAME
      join S_REPOSITORY rep on applet.REPOSITORY_ID = rep.ROW_ID 
      join S_CONTROL control on control.APPLET_ID = applet.ROW_ID and control.INACTIVE_FLG = 'N'
      where rep.NAME='Siebel Repository' and applet.INACTIVE_FLG = 'N' 
    union all
      select  applet.NAME, applet.BUSCOMP_NAME, appMsgVar.FIELD_NAME, 'AppletMessageVar' Type_On_GUI, appMsgVar.NAME Control from  S_APPLET applet
      join S_REPOSITORY rep on applet.REPOSITORY_ID = rep.ROW_ID 
      join S_APLT_TXT_MSG appMsg on appMsg.APPLET_ID = applet.ROW_ID and appMsg.INACTIVE_FLG = 'N'
      join S_APLT_TM_VAR appMsgVar on appMsgVar.APLT_TXT_MSG_ID = appMsg.ROW_ID and appMsgVar.INACTIVE_FLG = 'N'
      where rep.NAME='Siebel Repository' and applet.INACTIVE_FLG = 'N'
    union all
      select  applet.NAME, applet.BUSCOMP_NAME, dd.SRC_FIELD_NAME, 'DrillDownSource' Type_On_GUI, dd.NAME Control from  S_APPLET applet
      join S_REPOSITORY rep on applet.REPOSITORY_ID = rep.ROW_ID 
      join S_DDOWN_OBJECT dd on dd.APPLET_ID = applet.ROW_ID and dd.INACTIVE_FLG = 'N'
      where rep.NAME='Siebel Repository' and applet.INACTIVE_FLG = 'N'
    union all  
      select  applet.NAME, applet.BUSCOMP_NAME, dd.SRC_FIELD_NAME, 'DynamicDrillDownCondition' Type_On_GUI, ddd.NAME Control from  S_APPLET applet
      join S_REPOSITORY rep on applet.REPOSITORY_ID = rep.ROW_ID 
      join S_DDOWN_OBJECT dd on dd.APPLET_ID = applet.ROW_ID and dd.INACTIVE_FLG = 'N'
      join S_DDOWN_DYNDEST ddd on ddd.DDOWN_OBJECT_ID = dd.ROW_ID and ddd.INACTIVE_FLG = 'N'
      where rep.NAME='Siebel Repository' and applet.INACTIVE_FLG = 'N'
    union all
      select  applet.NAME, applet.BUSCOMP_NAME, toggle.AUTO_TOG_FLD_NAME, 'ToggleField' Type_On_GUI, toggle.NAME Control from  S_APPLET applet
      join S_REPOSITORY rep on applet.REPOSITORY_ID = rep.ROW_ID 
      join S_APPLET_TOGGLE toggle on toggle.APPLET_ID = applet.ROW_ID and toggle.INACTIVE_FLG = 'N'
      where rep.NAME='Siebel Repository' and applet.INACTIVE_FLG = 'N'
      ) applets
    
    on fields.bc = applets.BUSCOMP_NAME and fields.NAME = applets.FIELD_NAME
    
    left outer join
    (
     select applet.NAME applet, applet.BUSCOMP_NAME, 'ListColumn' ControlType, ListColumn.ROW_ID control,ListColumn.FIELD_NAME, case when LanguageAlias.DISPLAY_NAME is not null then LanguageAlias.DISPLAY_NAME else DisplayNameExact.STRING_VALUE end Display_Name
         ,DisplayNameExact.LANG_CD
        from S_APPLET applet
        join S_REPOSITORY repository on applet.REPOSITORY_ID = repository.ROW_ID
        join S_LIST list on list.APPLET_ID = applet.ROW_ID
        join S_LIST_COLUMN  ListColumn on ListColumn.LIST_ID = List.ROW_ID and ListColumn.INACTIVE_FLG = 'N'
        left outer join S_LIST_COL_INTL LanguageAlias on LanguageAlias.INACTIVE_FLG = 'N' and LanguageAlias.LIST_COLUMN_ID = ListColumn.ROW_ID
        left outer join S_SYM_STR_INTL DisplayNameExact on DisplayNameExact.INACTIVE_FLG = 'N' and DisplayNameExact.REPOSITORY_ID = ListColumn.REPOSITORY_ID and DisplayNameExact.SYM_STR_KEY = ListColumn.DISPLAY_NAME_REF 
        where repository.NAME = 'Siebel Repository'
        union all 
        select applet.NAME applet, applet.BUSCOMP_NAME, 'Control' ControlType, control.ROW_ID control,control.FIELD_NAME, case when LanguageAlias.CAPTION is not null then LanguageAlias.CAPTION else CaptionExact.STRING_VALUE end Display_Name
        ,CaptionExact.LANG_CD
        from S_APPLET applet
        join S_REPOSITORY repository on applet.REPOSITORY_ID = repository.ROW_ID
        join S_CONTROL control on control.APPLET_ID = applet.ROW_ID and control.INACTIVE_FLG = 'N'
        left outer join S_CONTROL_INTL LanguageAlias on LanguageAlias.INACTIVE_FLG = 'N' and LanguageAlias.CONTROL_ID = control.ROW_ID
        left outer join S_SYM_STR_INTL CaptionExact on CaptionExact.INACTIVE_FLG = 'N'  and CaptionExact.SYM_STR_KEY = control.CAPTION_REF and CaptionExact.REPOSITORY_ID = control.REPOSITORY_ID
        where repository.NAME = 'Siebel Repository'
    ) captions
    on applets.Control = captions.CONTROL /*applets.Applet = captions.APPLET and */
) t 
  
 where APPLET = 'ServiceRequest Home Public and Private View Link List Applet'
