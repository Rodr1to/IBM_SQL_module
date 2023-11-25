--Write and execute a SQL query to list the school names, community names and average attendance for communities with a hardship index of 98.
SELECT cps.NAME_OF_SCHOOL, csd.COMMUNITY_AREA_NAME, cps.AVERAGE_STUDENT_ATTENDANCE, csd.HARDSHIP_INDEX
FROM CHICAGO_PUBLIC_SCHOOLS AS cps 
LEFT JOIN CHICAGO_SOCIOECONOMIC_DATA AS csd 
ON cps.COMMUNITY_AREA_NUMBER = csd.COMMUNITY_AREA_NUMBER
WHERE csd.HARDSHIP_INDEX = 98;

--Write and execute a SQL query to list all crimes that took place at a school. Include case number, crime type and community name
SELECT cc.CASE_NUMBER, cc.PRIMARY_TYPE, csd.COMMUNITY_AREA_NAME, cc.LOCATION_DESCRIPTION
FROM CHICAGO_CRIME_DATA AS cc
LEFT JOIN CHICAGO_SOCIOECONOMIC_DATA AS csd ON cc.COMMUNITY_AREA_NUMBER = csd.COMMUNITY_AREA_NUMBER
WHERE cc.LOCATION_DESCRIPTION LIKE 'SCHOOL%';

CREATE OR REPLACE VIEW SCHOOL_VIEW (School_Name, Safety_Rating, Family_Rating, 
			Environment_Rating, Instruction_Rating, Leaders_Rating, Teachers_Rating)
AS SELECT NAME_OF_SCHOOL, SAFETY_ICON, FAMILY_INVOLVEMENT_ICON, ENVIRONMENT_ICON,
			INSTRUCTION_ICON, LEADERS_ICON, TEACHERS_ICON
FROM CHICAGO_PUBLIC_SCHOOLS;


SELECT * FROM SCHOOL_VIEW;


SELECT School_Name, Leaders_Rating FROM SCHOOL_VIEW;

--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE( 
    IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)

LANGUAGE SQL                        -- Language used in this routine 
MODIFIES SQL DATA                      -- This routine will only read data from the table

BEGIN 

	UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET Leaders_Score = in_Leader_Score
	WHERE School_ID = in_School_ID;
	
    IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN                           -- Start of conditional statement
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Icon = 'Very_weak'
        WHERE School_ID = in_School_ID;
    
    ELSEIF in_Leader_Score < 40 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Icon = 'Weak'
        WHERE School_ID = in_School_ID;
        
    ELSEIF in_Leader_Score < 60 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Icon = 'Average'
        WHERE School_ID = in_School_ID;   
        
    ELSEIF in_Leader_Score < 80 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Icon = 'Strong'
        WHERE School_ID = in_School_ID;  
        
    ELSEIF in_Leader_Score < 100 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Icon = 'Very strong'
        WHERE School_ID = in_School_ID; 
        
    ELSE 
    	ROLLBACK WORK;

    END IF;  
    
    COMMIT WORK;

END
@                                   -- Routine termination character
