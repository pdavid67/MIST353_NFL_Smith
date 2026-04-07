from get_db_connection import get_db_connection

def get_teams_by_conference_division(conference: str, division: str):
    conn = get_db_connection()
    cursor = conn.cursor()

    query = """
        SELECT
            t.TeamName,
            cd.Confrence,
            cd.Division,
            t.TeamColors
        FROM Team t
        INNER JOIN ConfrenceDivision cd
            ON t.ConfrenceDivisionID = cd.ConfrenceDivisionID
        WHERE cd.Confrence = ? AND cd.Division = ?
    """

    cursor.execute(query, (conference, division))
    rows = cursor.fetchall()

    data = []
    for row in rows:
        data.append({
            "teamName": row[0],
            "Conference": row[1],
            "Division": row[2],
            "TeamColors": row[3]
        })

    conn.close()
    return {"data": data}