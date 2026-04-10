from get_db_connection import get_db_connection

def validate_user(email: str, password_hash: str):
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
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

        conn.close()
        return {"data": results}

    except Exception as e:
        conn.close()
        return {"error": str(e)}