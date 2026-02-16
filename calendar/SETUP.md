# Google Calendar Integration Setup

## Prerequisites

1. Install required Python packages:
```bash
pip install --user google-auth-oauthlib google-auth-httplib2 google-api-python-client
```

## Google Cloud Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the Google Calendar API:
   - Go to "APIs & Services" > "Library"
   - Search for "Google Calendar API"
   - Click "Enable"

4. Create OAuth 2.0 credentials:
   - Go to "APIs & Services" > "Credentials"
   - Click "Create Credentials" > "OAuth client ID"
   - Choose "Desktop app" as application type
   - Give it a name (e.g., "Quickshell Calendar")
   - Click "Create"

5. Download the credentials:
   - Click the download button (⬇) next to your newly created OAuth client
   - Save the file as `credentials.json`
   - Move it to: `~/.config/quickshell/calendar/credentials.json`

## First Run

1. The first time the calendar widget tries to fetch events, it will:
   - Open your browser for authentication
   - Ask you to sign in to your Google account
   - Request permission to read your calendar
   - Save the token for future use

2. The token will be saved at: `~/.config/quickshell/calendar/token.json`

## Troubleshooting

- If you get authentication errors, delete `token.json` and try again
- Make sure `credentials.json` is in the correct location
- Check that the Google Calendar API is enabled in your project
- Verify Python packages are installed: `pip list | grep google`

## Files Location

- Script: `~/.config/quickshell/scripts/google_calendar.py`
- Credentials: `~/.config/quickshell/calendar/credentials.json`
- Token: `~/.config/quickshell/calendar/token.json` (auto-generated)

