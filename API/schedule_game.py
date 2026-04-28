from datetime import date, time

try:
    from .get_db_connection import get_db_connection
except ImportError:
    from get_db_connection import get_db_connection


def schedule_game(
    home_team_id: int,
    away_team_id: int,
    game_round: str,
    game_date: date,
    game_time: time,
    stadium_id: int,
    nfl_admin_id: int,
):
    conn = None

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            """
            EXEC dbo.ScheduleGame
                @HomeTeamID = ?,
                @AwayTeamID = ?,
                @GameRound = ?,
                @GameDate = ?,
                @GameTime = ?,
                @StadiumID = ?,
                @NFLAdminID = ?
            """,
            (
                home_team_id,
                away_team_id,
                game_round,
                game_date,
                game_time,
                stadium_id,
                nfl_admin_id,
            ),
        )

        rows = cursor.fetchall() if cursor.description else []
        columns = [column[0] for column in cursor.description] if cursor.description else []
        conn.commit()

        data = [dict(zip(columns, row)) for row in rows]
        return {"message": "Game scheduled successfully.", "data": data}
    except Exception as e:
        if conn is not None:
            conn.rollback()
        return {"error": str(e)}
    finally:
        if conn is not None:
            conn.close()
