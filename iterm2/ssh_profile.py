#!/usr/bin/env python3.10

import asyncio
import iterm2
import colorsys

# https://iterm2.com/python-api/examples/colorhost.html
# https://iterm2.com/python-api/examples/setprofile.html

async def set_profile(connection, session, name):
    profile = await session.async_get_profile()
    if profile.name == name:
        return

    profiles = await iterm2.PartialProfile.async_query(connection)
    for p in profiles:
        if p.name == name:
            full = await p.async_get_full_profile()
            await session.async_set_profile(full)

async def MonitorSession(connection, session):
    async with iterm2.VariableMonitor(connection, iterm2.VariableScopes.SESSION, "commandLine", session.session_id) as mon:
        while True:
            commandLine = await mon.async_get()
            profile = await session.async_get_profile()
            if commandLine.startswith("ssh"):
                await set_profile(connection, session, "ssh")
            else:
                await set_profile(connection, session, "Default")

async def main(connection):
    app = await iterm2.async_get_app(connection)
    async with iterm2.NewSessionMonitor(connection) as mon:
        while True:
            session_id = await mon.async_get()
            session = app.get_session_by_id(session_id)
            if session:
                asyncio.create_task(MonitorSession(connection, session))

iterm2.run_forever(main)
