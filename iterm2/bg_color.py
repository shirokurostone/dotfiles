#!/usr/bin/env python3.10

import iterm2
import colorsys

# https://iterm2.com/python-api/examples/random_color.html
# https://iterm2.com/python-api/examples/settabcolor.html

async def main(connection):
    app = await iterm2.async_get_app(connection)
    counter = 0
    async with iterm2.NewSessionMonitor(connection) as mon:
        while True:
            session_id = await mon.async_get()
            session = app.get_session_by_id(session_id)
            if session:
                profile = await session.async_get_profile()
                if profile.name == "Default":
                    change = iterm2.LocalWriteOnlyProfile()

                    rgb = colorsys.hsv_to_rgb((counter%10)*0.1, 1.0, 0.175)
                    change.set_background_color(iterm2.Color(int(rgb[0]*255), int(rgb[1]*255), int(rgb[2]*255)))
                    rgb = colorsys.hsv_to_rgb((counter%10)*0.1, 1.0, 0.5)
                    change.set_tab_color(iterm2.Color(int(rgb[0]*255), int(rgb[1]*255), int(rgb[2]*255)))
                    change.set_use_tab_color(True)

                    counter += 1
                    await session.async_set_profile_properties(change)

iterm2.run_forever(main)
