try:
    from .get_db_connection import get_db_connection
except ImportError:
    from get_db_connection import get_db_connection

def get_teams_for_specified_fan(FanTeamID):
    conn = None

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            "EXEC dbo.GetTeamsForSpecifiedFan @FanTeamID = %s",
            (FanTeamID,)
        )

        rows = cursor.fetchall()
        columns = [column[0] for column in cursor.description]

        data = []
        for row in rows:
            data.append(dict(zip(columns, row)))
        return {"data": data}
    except Exception as e:
        return {"error": str(e)}
    finally:
        if conn is not None:
            conn.close()
