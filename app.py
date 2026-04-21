import json
import sys
from pathlib import Path
from urllib.parse import parse_qs


APP_DIR = Path(__file__).resolve().parent
PYTHON_TAG = f"py{sys.version_info.major}{sys.version_info.minor}"
PACKAGE_DIR = APP_DIR / "api_packages" / PYTHON_TAG / "lib" / "site-packages"

if PACKAGE_DIR.exists():
    sys.path.insert(0, str(PACKAGE_DIR))


def _json_response(start_response, status, payload):
    body = json.dumps(payload, default=str).encode("utf-8")
    start_response(
        status,
        [
            ("Content-Type", "application/json"),
            ("Content-Length", str(len(body))),
        ],
    )
    return [body]


def _get_query_param(params, name, cast=str):
    values = params.get(name)
    if not values or values[0] == "":
        raise ValueError(f"Missing required query parameter: {name}")

    try:
        return cast(values[0])
    except (TypeError, ValueError) as exc:
        raise ValueError(f"Invalid value for query parameter: {name}") from exc


def application(environ, start_response):
    path = environ.get("PATH_INFO", "/")
    method = environ.get("REQUEST_METHOD", "GET")
    params = parse_qs(environ.get("QUERY_STRING", ""), keep_blank_values=True)

    if method != "GET":
        return _json_response(start_response, "405 Method Not Allowed", {"error": "Only GET is supported."})

    try:
        if path in {"", "/"}:
            return _json_response(
                start_response,
                "200 OK",
                {"message": "NFL Playoffs API is running"},
            )

        if path == "/get_teams_by_conference_division":
            from API.get_teams_by_conference_division import get_teams_by_conference_division

            conference = _get_query_param(params, "conference")
            division = _get_query_param(params, "division")
            return _json_response(
                start_response,
                "200 OK",
                get_teams_by_conference_division(conference, division),
            )

        if path == "/get_teams_in_same_conference_division_as_specified_team":
            from API.get_teams_in_same_conference_division_as_specified_team import (
                get_teams_in_same_conference_division_as_specified_team,
            )

            team_name = _get_query_param(params, "team_name")
            return _json_response(
                start_response,
                "200 OK",
                get_teams_in_same_conference_division_as_specified_team(team_name),
            )

        if path == "/get_teams_for_specified_fan":
            from API.get_teams_for_specified_fan import get_teams_for_specified_fan

            fan_team_id = _get_query_param(params, "FanTeamID", int)
            return _json_response(
                start_response,
                "200 OK",
                get_teams_for_specified_fan(fan_team_id),
            )

        if path == "/validate_user":
            from API.validate_user import validate_user

            email = _get_query_param(params, "email")
            password_hash = _get_query_param(params, "password_hash")
            return _json_response(
                start_response,
                "200 OK",
                validate_user(email, password_hash),
            )

        if path == "/docs":
            return _json_response(
                start_response,
                "200 OK",
                {
                    "message": "Swagger docs are available only when running the FastAPI ASGI app directly.",
                    "endpoints": [
                        "/get_teams_by_conference_division",
                        "/get_teams_in_same_conference_division_as_specified_team",
                        "/get_teams_for_specified_fan",
                        "/validate_user",
                    ],
                },
            )

        return _json_response(start_response, "404 Not Found", {"error": "Endpoint not found."})
    except ValueError as exc:
        return _json_response(start_response, "422 Unprocessable Entity", {"error": str(exc)})
    except Exception as exc:
        return _json_response(start_response, "500 Internal Server Error", {"error": str(exc)})


app = application
