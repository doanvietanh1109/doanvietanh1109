
#!/bin/bash
set -e

# Backup README
cp README.md ../README_before_green.md

# Create SVG folder
mkdir -p assets

# Dark Green Profile
cat > assets/green-dark.svg <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="1100" height="1000" viewBox="0 0 1100 1000">
<defs>
  <linearGradient id="bg" x2="1" y2="1">
    <stop stop-color="#07180F"/>
    <stop offset="1" stop-color="#113525"/>
  </linearGradient>
  <style>
    text {font-family:Arial,Helvetica,sans-serif}
    .title {fill:#E5FFEE;font-weight:800}
    .heading {fill:#4ADE80;font-weight:bold}
    .body {fill:#B7E4C5}
    .panel {fill:#113525;stroke:#2B6B49;stroke-width:2}
  </style>
</defs>

<rect width="1100" height="1000" rx="25" fill="url(#bg)"/>
<rect x="25" y="25" width="1050" height="950" rx="18" fill="none" stroke="#2B6B49" stroke-width="2"/>

<!-- Terminal header -->
<rect x="25" y="25" width="1050" height="60" rx="18" fill="#04140A"/>
<circle cx="65" cy="55" r="9" fill="#FB7185"/>
<circle cx="95" cy="55" r="9" fill="#FACC15"/>
<circle cx="125" cy="55" r="9" fill="#4ADE80"/>
<text x="165" y="63" class="body" font-size="21">~/doanvietanh1109/profile</text>

<!-- Hero -->
<text x="65" y="145" class="heading" font-size="23">// HELLO, WORLD!</text>
<text x="65" y="225" class="title" font-size="78">VANHDOANDEV</text>
<text x="67" y="277" class="heading" font-size="29">DOAN VIET ANH</text>
<text x="67" y="320" class="body" font-size="24">Full-Stack Developer | Software Engineering</text>
<text x="67" y="359" class="body" font-size="21">Building web products, backend systems and useful tools.</text>

<!-- Education card -->
<rect x="65" y="402" width="460" height="180" rx="18" class="panel"/>
<text x="92" y="452" class="heading" font-size="22">01 / EDUCATION</text>
<text x="92" y="503" class="title" font-size="28">PTIT</text>
<text x="92" y="543" class="body" font-size="21">Information Technology</text>

<!-- Focus card -->
<rect x="550" y="402" width="485" height="180" rx="18" class="panel"/>
<text x="577" y="452" class="heading" font-size="22">02 / CURRENT FOCUS</text>
<text x="577" y="503" class="title" font-size="23">Backend Engineering</text>
<text x="577" y="543" class="body" font-size="21">Full-Stack Development and AI</text>

<!-- Experience -->
<rect x="65" y="607" width="970" height="170" rx="18" class="panel"/>
<text x="92" y="657" class="heading" font-size="22">03 / EXPERIENCE AND RESEARCH</text>
<text x="92" y="703" class="title" font-size="24">Viettel Digital Talent  |  VNPT IT</text>
<text x="92" y="742" class="body" font-size="22">PTIT NITS - Research and Development</text>

<!-- Stack -->
<rect x="65" y="802" width="970" height="145" rx="18" class="panel"/>
<text x="92" y="850" class="heading" font-size="22">04 / TECH STACK</text>
<text x="92" y="891" class="title" font-size="23">C++  Python  JavaScript  TypeScript  React</text>
<text x="92" y="925" class="body" font-size="22">Node.js  NestJS  Git  GitHub  REST APIs</text>
</svg>
SVG

# Light Green Profile
sed \
  -e 's/#07180F/#EFFCF3/g' \
  -e 's/#113525/#FFFFFF/g' \
  -e 's/#E5FFEE/#064E3B/g' \
  -e 's/#B7E4C5/#166534/g' \
  -e 's/#4ADE80/#15803D/g' \
  -e 's/#2B6B49/#86EFAC/g' \
  -e 's/#04140A/#DCFCE7/g' \
  assets/green-dark.svg > assets/green-light.svg

# GitHub README
cat > README.md <<'MARKDOWN'
<div align="center">

<a href="https://vanhdoandev-fe.vercel.app/">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./assets/green-dark.svg">
  <source media="(prefers-color-scheme: light)" srcset="./assets/green-light.svg">
  <img src="./assets/green-dark.svg" width="100%" alt="VANHDOANDEV Green GitHub Profile">
</picture>
</a>

### Full-Stack Developer | PTIT

[![Portfolio](https://img.shields.io/badge/Portfolio-166534?style=for-the-badge&logo=vercel&logoColor=white)](https://vanhdoandev-fe.vercel.app/)
[![GitHub](https://img.shields.io/badge/GitHub-15803D?style=for-the-badge&logo=github&logoColor=white)](https://github.com/doanvietanh1109)

</div>

## About Me

Hello! I'm **Doan Viet Anh**, an Information Technology student at PTIT.

I'm interested in Full-Stack Development, Backend Engineering, AI, and building real-world applications.

## Experience & Research

- Viettel Digital Talent
- VNPT Information Technology
- PTIT NITS Research Lab

## Tech Stack

**Languages:** C++, Python, JavaScript, TypeScript

**Frontend:** React, HTML, CSS

**Backend:** Node.js, NestJS, REST APIs

**Tools:** Git, GitHub, VS Code

## Featured Projects

### VANHDOANDEV Portfolio

My personal developer portfolio.

- [Live Website](https://vanhdoandev-fe.vercel.app/)
- [Source Code](https://github.com/doanvietanh1109/VANHDOANDEV_FE)

### AIC Challenge 2025

AI and problem-solving project experience.

## GitHub Activity

![GitHub Activity](https://github-readme-stats.vercel.app/api?username=doanvietanh1109&show_icons=true&theme=dark&title_color=4ade80&icon_color=4ade80&hide_border=true)

---

<div align="center">

**VANHDOANDEV | Building. Learning. Improving.**

</div>
MARKDOWN

echo "GREEN PROFILE CREATED SUCCESSFULLY!"
