from fastapi import FastAPI

app = FastAPI()


def _load_api_functions():
    try:
        from .get_teams_by_conference_division import get_teams_by_conference_division
        from .get_teams_in_same_conference_division_as_specified_team import (
            get_teams_in_same_conference_division_as_specified_team,
        )
        from .get_teams_for_specified_fan import get_teams_for_specified_fan
        from .validate_user import validate_user
    except ImportError:
        from get_teams_by_conference_division import get_teams_by_conference_division
        from get_teams_in_same_conference_division_as_specified_team import (
            get_teams_in_same_conference_division_as_specified_team,
        )
        from get_teams_for_specified_fan import get_teams_for_specified_fan
        from validate_user import validate_user

    return {
        "get_teams_by_conference_division": get_teams_by_conference_division,
        "get_teams_in_same_conference_division_as_specified_team": get_teams_in_same_conference_division_as_specified_team,
        "get_teams_for_specified_fan": get_teams_for_specified_fan,
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
def teams_for_specified_fan(FanTeamID: int):
    functions = _load_api_functions()
    return functions["get_teams_for_specified_fan"](FanTeamID)

@app.get("/validate_user")
def validate_user_route(email: str, password_hash: str):
    functions = _load_api_functions()
    return functions["validate_user"](email, password_hash)
