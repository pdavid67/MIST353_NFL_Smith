from get_db_connection import get_db_connection

def get_teams_for_specified_fan(FanTeamID):
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(
            "EXEC dbo.GetTeamsForSpecifiedFan @FanTeamID = ?",
            FanTeamID
        )

        rows = cursor.fetchall()
        columns = [column[0] for column in cursor.description]

        data = []
        for row in rows:
            data.append(dict(zip(columns, row)))

        conn.close()
        return {"data": data}

    except Exception as e:
        conn.close()
        return {"error": str(e)}