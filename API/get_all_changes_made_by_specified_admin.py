try:
    from .get_db_connection import get_db_connection
except ImportError:
    from get_db_connection import get_db_connection


def get_all_changes_made_by_specified_admin(user_id: int):
    conn = None

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            "EXEC dbo.procGetAllChangesMadeBySpecifiedAdmin @NFLAdminID = ?",
            (user_id,),
        )
        rows = cursor.fetchall()
        columns = [column[0] for column in cursor.description]

        return {"data": [dict(zip(columns, row)) for row in rows]}
    except Exception as e:
        return {"error": str(e)}
    finally:
        if conn is not None:
            conn.close()
