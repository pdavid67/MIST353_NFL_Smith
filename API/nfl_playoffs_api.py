from fastapi import FastAPI
from get_teams_by_conference_division import get_teams_by_conference_division
from get_teams_in_same_conference_division_as_specified_team import get_teams_in_same_conference_division_as_specified_team
from get_teams_for_specified_fan import get_teams_for_specified_fan
from validate_user import validate_user

app = FastAPI()

@app.get("/")
def root():
    return {"message": "NFL Playoffs API is running"}

@app.get("/get_teams_by_conference_division")
def teams_by_conference_division(conference: str, division: str):
    return get_teams_by_conference_division(conference, division)

@app.get("/get_teams_in_same_conference_division_as_specified_team")
def teams_in_same_conference_division_as_specified_team(team_name: str):
    return get_teams_in_same_conference_division_as_specified_team(team_name)

@app.get("/get_teams_for_specified_fan")
def teams_for_specified_fan(FanTeamID: int):
    return get_teams_for_specified_fan(FanTeamID)

@app.get("/validate_user")
def validate_user_route(email: str, password_hash: str):
    return validate_user(email, password_hash)