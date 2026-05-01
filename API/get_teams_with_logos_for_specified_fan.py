import base64

try:
    from .get_db_connection import get_db_connection
except ImportError:
    from get_db_connection import get_db_connection


def _encode_logo(logo):
    if logo is None:
        return None
    return base64.b64encode(bytes(logo)).decode("utf-8")


def get_teams_with_logos_for_specified_fan(fan_id: int):
    conn = None

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            "EXEC dbo.procGetTeamsWithLogosForSpecifiedFan @NFLFanID = ?",
            (fan_id,),
        )
        rows = cursor.fetchall()
        columns = [column[0] for column in cursor.description]

        data = []
        for row in rows:
            item = dict(zip(columns, row))
            item["TeamLogo"] = _encode_logo(item.get("TeamLogo"))
            data.append(item)

        return {"data": data}
    except Exception as e:
        return {"error": str(e)}
    finally:
        if conn is not None:
            conn.close()
