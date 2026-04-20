try:
    from .get_db_connection import get_db_connection
except ImportError:
    from get_db_connection import get_db_connection

def validate_user(email: str, password_hash: str):
    conn = None

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            "EXEC dbo.procValidateUser @Email = %s, @PasswordHash = %s",
            (email, bytes.fromhex(password_hash.replace("0x", "")))
        )

        rows = cursor.fetchall()

        results = [
            {
                "AppUserID": row[0],
                "FullName": row[1],
                "UserRole": row[2]
            }
            for row in rows
        ]
        return {"data": results}
    except Exception as e:
        return {"error": str(e)}
    finally:
        if conn is not None:
            conn.close()
