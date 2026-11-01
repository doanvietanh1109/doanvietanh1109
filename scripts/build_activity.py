
import os
import json
import urllib.request
from datetime import date
from pathlib import Path

USER = "doanvietanh1109"
TOKEN = os.environ.get("GH_TOKEN", "")


def api(url, payload=None):
    headers = {
        "Accept": "application/vnd.github+json",
        "User-Agent": "green-activity-profile",
    }
    if TOKEN:
        headers["Authorization"] = "Bearer " + TOKEN

    data = json.dumps(payload).encode() if payload else None
    request = urllib.request.Request(url, data=data, headers=headers)

    with urllib.request.urlopen(request, timeout=30) as response:
        result = json.load(response)

    if isinstance(result, dict) and result.get("errors"):
        raise RuntimeError(str(result["errors"]))

    return result


def render():
    if not TOKEN:
        raise RuntimeError("GH_TOKEN is missing. Use GitHub Actions.")

    repos = []
    page = 1

    while True:
        url = (
            f"https://api.github.com/users/{USER}/repos"
            f"?per_page=100&page={page}&type=owner"
        )
        chunk = api(url)
        repos += [r for r in chunk if not r["fork"]]
        if len(chunk) < 100:
            break
        page += 1

    stars = sum(r["stargazers_count"] for r in repos)
    forks = sum(r["forks_count"] for r in repos)

    query = """
    query($login:String!) {
      user(login:$login) {
        contributionsCollection {
          contributionCalendar {
            totalContributions
            weeks {
              contributionDays {
                date
                contributionCount
              }
            }
          }
        }
      }
    }
    """

    result = api(
        "https://api.github.com/graphql",
        {"query": query, "variables": {"login": USER}},
    )

    calendar = result["data"]["user"]["contributionsCollection"]["contributionCalendar"]
    total = calendar["totalContributions"]

    today = date.today()
    month_keys = []

    for back in range(11, -1, -1):
        n = today.year * 12 + today.month - 1 - back
        month_keys.append((n // 12, n % 12 + 1))

    monthly = {key: 0 for key in month_keys}

    for week in calendar["weeks"]:
        for day in week["contributionDays"]:
            d = date.fromisoformat(day["date"])
            key = (d.year, d.month)
            if key in monthly and d <= today:
                monthly[key] += day["contributionCount"]

    values = [monthly[k] for k in month_keys]
    scale = max(values) or 1

    s = ['''<svg xmlns="http://www.w3.org/2000/svg"
    width="1100" height="720" viewBox="0 0 1100 720">
    <defs>
      <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
        <stop stop-color="#0A1510"/>
        <stop offset="1" stop-color="#10291C"/>
      </linearGradient>
    </defs>
    <style>
      text{font-family:ui-monospace,SFMono-Regular,Menlo,Consolas,monospace}
      .big{fill:#F0FFF4;font-weight:700}
      .label{fill:#9DC1AA}
      .mint{fill:#6EE7A1}
    </style>
    <rect width="1100" height="720" rx="28" fill="#0B1110"/>
    <text x="45" y="74" font-size="45" class="big">activity</text>
    <rect x="42" y="112" width="1016" height="220" rx="24"
      fill="url(#bg)" stroke="#254735" stroke-width="3"/>
    <line x1="550" y1="149" x2="550" y2="296"
      stroke="#2C4839" stroke-width="2"/>
    <path d="M105 151 L112 165 L128 167 L116 178
      L119 194 L105 186 L91 194 L94 178 L82 167 L98 165 Z"
      fill="none" stroke="#6EE7A1" stroke-width="3"/>
    <text x="136" y="177" font-size="29" class="label">stars</text>
    <path d="M613 153 V181 M613 166 H635 V181
      M605 153 a8 8 0 1 0 16 0 a8 8 0 1 0 -16 0
      M627 189 a8 8 0 1 0 16 0 a8 8 0 1 0 -16 0"
      fill="none" stroke="#6EE7A1" stroke-width="3"/>
    <text x="644" y="177" font-size="29" class="label">forks</text>''']

    s += [
        f'<text x="85" y="263" class="big" font-size="82">{stars:,}</text>',
        f'<text x="594" y="263" class="big" font-size="82">{forks:,}</text>',
        f'<text x="85" y="305" class="label" font-size="22">on {len(repos)} public source repos</text>',
        '<text x="594" y="305" class="label" font-size="22">forks of your public repos</text>',
    ]

    s += [
        '''<rect x="42" y="357" width="1016" height="315" rx="24"
          fill="url(#bg)" stroke="#254735" stroke-width="3"/>
        <path d="M82 408 H99 M116 408 H130
          M99 408 a8 8 0 1 0 16 0 a8 8 0 1 0 -16 0"
          fill="none" stroke="#6EE7A1" stroke-width="3"/>
        <text x="136" y="419" font-size="29"
          class="label">contributions</text>''',
        f'<text x="85" y="547" class="big" font-size="82">{total:,}</text>',
        '<text x="85" y="592" class="label" font-size="23">last 12 months</text>',
        '<path d="M535 601 H1010" stroke="#34513F" stroke-width="2"/>',
    ]

    for i, ((y, m), value) in enumerate(zip(month_keys, values)):
        x = 548 + i * 39
        height = round(143 * value / scale)
        color = "#86EFAC" if i == 11 else "#3B8560"

        if height:
            s.append(
                f'<rect x="{x}" y="{599-height}" width="25" '
                f'height="{height}" rx="5" fill="{color}"/>'
            )

        s.append(
            f'<text x="{x+12}" y="636" text-anchor="middle" '
            f'font-size="17" class="label">{date(y,m,1):%b}</text>'
        )

    s += [
        f'<text x="83" y="695" font-size="17" class="label">'
        f'Source: GitHub API - @{USER} - refreshed {today.isoformat()} UTC</text>',
        '</svg>',
    ]

    Path("dist").mkdir(exist_ok=True)
    Path("dist/activity-green.svg").write_text(
        "\n".join(s), encoding="utf-8"
    )

    print(f"Created activity SVG: {stars} stars, {forks} forks, {total} contributions")


if __name__ == "__main__":
    render()
