try:
    from .get_db_connection import get_db_connection
except ImportError:
    from get_db_connection import get_db_connection

def get_teams_in_same_conference_division_as_specified_team(team_name):
    conn = None

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            "EXEC dbo.GetTeamsInSameConferenceDivisionAsSpecifiedTeam @TeamName = ?",
            team_name
        )

        rows = cursor.fetchall()

        data = []
        for row in rows:
            data.append({
                "TeamID": row[0],
                "TeamName": row[1],
                "TeamCityState": row[2],
                "TeamColors": row[3],
                "Confrence": row[4],
                "Division": row[5]
            })

        return {"data": data}
    except Exception as e:
        return {"error": str(e)}
    finally:
        if conn is not None:
            conn.close()
