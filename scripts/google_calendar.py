#!/usr/bin/env python3
"""
Google Calendar integration script for Quickshell
Fetches upcoming events and outputs them as JSON
"""

import json
import sys
from datetime import datetime, timedelta
from pathlib import Path
import os

try:
    from google.auth.transport.requests import Request
    from google.oauth2.credentials import Credentials
    from google_auth_oauthlib.flow import InstalledAppFlow
    from googleapiclient.discovery import build
    from googleapiclient.errors import HttpError
except ImportError:
    print(json.dumps({
        "error": "Google Calendar API not installed",
        "message": "Install with: pip install --user google-auth-oauthlib google-auth-httplib2 google-api-python-client",
        "events": []
    }))
    sys.exit(0)

# If modifying these scopes, delete the file token.json.
SCOPES = ['https://www.googleapis.com/auth/calendar.readonly']

# Config directory
CONFIG_DIR = Path.home() / '.config' / 'quickshell' / 'calendar'
CONFIG_DIR.mkdir(parents=True, exist_ok=True)

TOKEN_FILE = CONFIG_DIR / 'token.json'
CREDENTIALS_FILE = CONFIG_DIR / 'credentials.json'


def get_credentials():
    """Get or refresh Google Calendar credentials"""
    creds = None
    
    # Token file stores the user's access and refresh tokens
    if TOKEN_FILE.exists():
        creds = Credentials.from_authorized_user_file(str(TOKEN_FILE), SCOPES)
    
    # If there are no (valid) credentials available, let the user log in
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            try:
                creds.refresh(Request())
            except Exception as e:
                return None, f"Failed to refresh token: {e}"
        else:
            if not CREDENTIALS_FILE.exists():
                return None, f"Credentials file not found at {CREDENTIALS_FILE}"
            
            try:
                flow = InstalledAppFlow.from_client_secrets_file(
                    str(CREDENTIALS_FILE), SCOPES)
                creds = flow.run_local_server(port=0)
            except Exception as e:
                return None, f"Failed to authenticate: {e}"
        
        # Save the credentials for the next run
        with open(TOKEN_FILE, 'w') as token:
            token.write(creds.to_json())
    
    return creds, None


def get_upcoming_events(max_results=10, days_ahead=7):
    """Fetch upcoming events from Google Calendar including tasks and birthdays"""
    creds, error = get_credentials()
    
    if error:
        return {
            "error": error,
            "events": []
        }
    
    try:
        service = build('calendar', 'v3', credentials=creds)
        
        # Get events from now until days_ahead
        now = datetime.utcnow()
        time_min = now.isoformat() + 'Z'
        time_max = (now + timedelta(days=days_ahead)).isoformat() + 'Z'
        
        # Get list of all calendars
        calendar_list = service.calendarList().list().execute()
        calendars = calendar_list.get('items', [])
        
        all_events = []
        
        # Fetch events from all calendars (including birthdays and tasks)
        for calendar in calendars:
            calendar_id = calendar['id']
            try:
                events_result = service.events().list(
                    calendarId=calendar_id,
                    timeMin=time_min,
                    timeMax=time_max,
                    maxResults=max_results,
                    singleEvents=True,
                    orderBy='startTime'
                ).execute()
                
                events = events_result.get('items', [])
                
                # Add calendar info to each event
                for event in events:
                    event['calendar_name'] = calendar.get('summary', 'Calendar')
                    event['calendar_color'] = calendar.get('backgroundColor', '#4285f4')
                all_events.extend(events)
            except HttpError:
                # Skip calendars we can't access
                continue
        
        # Sort all events by start time
        all_events.sort(key=lambda x: x['start'].get('dateTime', x['start'].get('date')))
        
        # Limit to max_results
        all_events = all_events[:max_results]
        
        formatted_events = []
        for event in all_events:
            start = event['start'].get('dateTime', event['start'].get('date'))
            end = event['end'].get('dateTime', event['end'].get('date'))
            
            # Parse datetime
            try:
                if 'T' in start:
                    start_dt = datetime.fromisoformat(start.replace('Z', '+00:00'))
                    end_dt = datetime.fromisoformat(end.replace('Z', '+00:00'))
                    is_all_day = False
                else:
                    start_dt = datetime.fromisoformat(start)
                    end_dt = datetime.fromisoformat(end)
                    is_all_day = True
                
                # Determine event type
                event_type = 'event'
                calendar_name = event.get('calendar_name', 'Calendar')
                if 'birthday' in calendar_name.lower() or 'birthdays' in calendar_name.lower():
                    event_type = 'birthday'
                elif 'task' in calendar_name.lower() or 'tasks' in calendar_name.lower():
                    event_type = 'task'
                
                formatted_events.append({
                    'summary': event.get('summary', 'No Title'),
                    'start': start,
                    'end': end,
                    'start_formatted': start_dt.strftime('%b %d, %I:%M %p') if not is_all_day else start_dt.strftime('%b %d'),
                    'is_all_day': is_all_day,
                    'location': event.get('location', ''),
                    'description': event.get('description', ''),
                    'html_link': event.get('htmlLink', ''),
                    'calendar_name': calendar_name,
                    'event_type': event_type
                })
            except Exception as e:
                continue
        
        return {
            "events": formatted_events,
            "count": len(formatted_events)
        }
        
    except HttpError as error:
        return {
            "error": f"Google Calendar API error: {error}",
            "events": []
        }
    except Exception as e:
        return {
            "error": f"Unexpected error: {e}",
            "events": []
        }


def main():
    """Main function"""
    # Get command line arguments
    max_results = int(sys.argv[1]) if len(sys.argv) > 1 else 10
    days_ahead = int(sys.argv[2]) if len(sys.argv) > 2 else 7
    
    result = get_upcoming_events(max_results, days_ahead)
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()

