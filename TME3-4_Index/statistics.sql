-- Introduction on SQL command explain plan --


-- card d'une table

EXPLAIN plan FOR
    SELECT * FROM Annuaire;
@p3

-- PLAN_TABLE_OUTPUT                                                                         
-- ------------------------------------------------------------------------------------------
-- ----------                                                                                
-- Plan hash value: 1255195813                                                               
                                                                                          
-- ----------------------------------------------                                            
-- | Id  | Operation         | Name     | Rows  |                                            
-- ----------------------------------------------                                            
-- |   0 | SELECT STATEMENT  |          |  2000 |                                            
-- |   1 |  TABLE ACCESS FULL| ANNUAIRE |  2000 |                                            
-- ----------------------------------------------                                            
                                                                                          
-- Column Projection Information (identified by operation id):                               
-- -----------------------------------------------------------                               
                                                                                          
--    1 - "ANNUAIRE"."NOM"[VARCHAR2,30], "ANNUAIRE"."PRENOM"[VARCHAR2,30],                   
--        "ANNUAIRE"."AGE"[NUMBER,22], "ANNUAIRE"."CP"[NUMBER,22],                           
--        "ANNUAIRE"."TEL"[VARCHAR2,10], "ANNUAIRE"."PROFIL"[VARCHAR2,1500]



EXPLAIN plan FOR
    SELECT * FROM BigAnnuaire;
@p3

-- -------------------------------------------------                                         
-- | Id  | Operation         | Name        | Rows  |                                         
-- -------------------------------------------------                                         
-- |   0 | SELECT STATEMENT  |             |   220K|                                         
-- |   1 |  TABLE ACCESS FULL| BIGANNUAIRE |   220K|                                         
-- -------------------------------------------------       

EXPLAIN plan FOR
    SELECT DISTINCT nom FROM BigAnnuaire;
@p3

-- --------------------------------------------------                                        
-- | Id  | Operation          | Name        | Rows  |                                        
-- --------------------------------------------------                                        
-- |   0 | SELECT STATEMENT   |             |   100 |                                        
-- |   1 |  HASH UNIQUE       |             |   100 |                                        
-- |   2 |   TABLE ACCESS FULL| BIGANNUAIRE |   220K|                                        
--------------------------------------------------      
-- Column Projection Information (identified by operation id):                               
-- -----------------------------------------------------------                               
                                                                                          
--    1 - (#keys=1) "NOM"[VARCHAR2,30]                                                       
--    2 - "NOM"[VARCHAR2,30]                                                                 
                                 

EXPLAIN plan FOR
   SELECT DISTINCT prenom FROM BigAnnuaire;
@p3

-- -----------------------------------------------------------------------                   
-- | Id  | Operation          | Name        | Rows  | Bytes | Cost (%CPU)|                   
-- -----------------------------------------------------------------------                   
-- |   0 | SELECT STATEMENT   |             |    90 |   810 | 70899   (1)|                   
-- |   1 |  HASH UNIQUE       |             |    90 |   810 | 70899   (1)|                   
-- |   2 |   TABLE ACCESS FULL| BIGANNUAIRE |   220K|  1933K| 70893   (1)|                   
-- -----------------------------------------------------------------------                   
                                                                                          
-- Column Projection Information (identified by operation id):                               
-- -----------------------------------------------------------                               
                                                                                          
--    1 - (#keys=1) "PRENOM"[VARCHAR2,30]                                                    
--    2 - "PRENOM"[VARCHAR2,30]                                                              