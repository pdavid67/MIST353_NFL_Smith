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
            "EXEC dbo.procValidateUser @Email = ?, @PasswordHash = ?",
            (email, bytes.fromhex(password_hash.replace("0x", "")))
        )

        rows = cursor.fetchall()

        results = [
            {
                "AppUserID": row.AppUserID,
                "FullName": row.FullName,
                "UserRole": row.UserRole
            }
            for row in rows
        ]
        return {"data": results}
    except Exception as e:
        return {"error": str(e)}
    finally:
        if conn is not None:
            conn.close()
