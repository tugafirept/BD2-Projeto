-- PROCEDIMENTO DE LOG IN

-- FUNCTION to check if a user or company exists. Return the user/company id if it exists, return -1 if it doesn't
CREATE OR REPLACE FUNCION can_login_user(
    u_email VARCHAR,
    u_password VARCHAR
)
RETURNS INTEGER
LANGUAGE 'plpgsql'
DECLARE
    return_id INTEGER;
AS $BODY$
BEGIN

    SELECT id_utilizador INTO return_id FROM utilizadores WHERE email = u_email AND password = u_password;

    IF FOUND
	THEN
		return return_id;
	ELSE
		return -1;
	END IF;
END;
$BODY$;