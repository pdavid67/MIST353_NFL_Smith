from datetime import date, time

from fastapi import FastAPI

app = FastAPI()


def _load_api_functions():
    try:
        from .get_teams_by_conference_division import get_teams_by_conference_division
        from .get_teams_in_same_conference_division_as_specified_team import (
            get_teams_in_same_conference_division_as_specified_team,
        )
        from .get_teams_for_specified_fan import get_teams_for_specified_fan
        from .schedule_game import schedule_game
        from .validate_user import validate_user
    except ImportError:
        from get_teams_by_conference_division import get_teams_by_conference_division
        from get_teams_in_same_conference_division_as_specified_team import (
            get_teams_in_same_conference_division_as_specified_team,
        )
        from get_teams_for_specified_fan import get_teams_for_specified_fan
        from schedule_game import schedule_game
        from validate_user import validate_user

    return {
        "get_teams_by_conference_division": get_teams_by_conference_division,
        "get_teams_in_same_conference_division_as_specified_team": get_teams_in_same_conference_division_as_specified_team,
        "get_teams_for_specified_fan": get_teams_for_specified_fan,
        "schedule_game": schedule_game,
        "validate_user": validate_user,
    }

@app.get("/")
def root():
    return {"message": "NFL Playoffs API is running"}

@app.get("/get_teams_by_conference_division")
def teams_by_conference_division(conference: str, division: str):
    functions = _load_api_functions()
    return functions["get_teams_by_conference_division"](conference, division)

@app.get("/get_teams_in_same_conference_division_as_specified_team")
def teams_in_same_conference_division_as_specified_team(team_name: str):
    functions = _load_api_functions()
    return functions["get_teams_in_same_conference_division_as_specified_team"](team_name)

@app.get("/get_teams_for_specified_fan")
def teams_for_specified_fan(user_id: int):
    functions = _load_api_functions()
    return functions["get_teams_for_specified_fan"](user_id)

@app.post("/schedule_game/")
def schedule_game_api(
    home_team_id: int,
    away_team_id: int,
    game_round: str,
    game_date: date,
    game_time: time,
    stadium_id: int,
    nfl_admin_id: int,
):
    functions = _load_api_functions()
    return functions["schedule_game"](
        home_team_id,
        away_team_id,
        game_round,
        game_date,
        game_time,
        stadium_id,
        nfl_admin_id,
    )

@app.get("/validate_user")
def validate_user_route(email: str, password_hash: str):
    functions = _load_api_functions()
    return functions["validate_user"](email, password_hash)
